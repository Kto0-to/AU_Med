import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:icon_plus/icon_plus.dart';
import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/providers/medications_provider.dart';
import 'package:au_med/src/theme/app_theme.dart';
import 'package:au_med/src/services/notification_service.dart';


class AddEditMedicationScreen extends ConsumerStatefulWidget {
  final int? medicationId;
  final int? logId;

  const AddEditMedicationScreen({
    super.key,
    this.medicationId,
    this.logId,
  });

  @override
  ConsumerState<AddEditMedicationScreen> createState() =>
      _AddEditMedicationScreenState();
}

class _AddEditMedicationScreenState
    extends ConsumerState<AddEditMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageValueController = TextEditingController();
  final _notesController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _remainingPillsController = TextEditingController();

  String _dosageUnit = 'мг';
  int _frequencyPerDay = 1;
  double? _intervalHours;
  List<String> _times = [];
  int _selectedColor = AppColors.medicationColors[0];
  String? _selectedIcon;
  bool _isLoading = false;
  bool _isEditing = false;
  bool _useInterval = false;
  DateTime? _startDate;
  DateTime? _endDate;

  static const _units = ['мг', 'мл', 'таб', 'капс', 'капли', 'мкг', 'г', 'ед'];

  @override
  void initState() {
    super.initState();
    if (widget.medicationId != null) {
      _isEditing = true;
      _loadMedication();
    }
  }

  Future<void> _loadMedication() async {
    setState(() => _isLoading = true);
    final dao = ref.read(medicationsDaoProvider);
    final med = await dao.getById(widget.medicationId!);
    if (med != null && mounted) {
      _nameController.text = med.name;
      _dosageValueController.text = med.dosageValue.toString();
      _dosageUnit = med.dosageUnit;
      _frequencyPerDay = med.frequencyPerDay ?? 1;
      _intervalHours = med.intervalHours;
      _useInterval = med.intervalHours != null;
      if (med.times.isNotEmpty) {
        _times = med.times.split(',').where((t) => t.isNotEmpty).toList();
      }
      _selectedColor = med.color;
      _selectedIcon = med.icon;
      _notesController.text = med.notes ?? '';
      _descriptionController.text = med.description ?? '';
      _startDate = DateTime.tryParse(med.startDate);
      if (med.endDate != null) _endDate = DateTime.tryParse(med.endDate!);
      if (med.remainingPills != null) {
        _remainingPillsController.text = med.remainingPills.toString();
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageValueController.dispose();
    _notesController.dispose();
    _descriptionController.dispose();
    _remainingPillsController.dispose();
    super.dispose();
  }

  void _addTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (result != null) {
      setState(() {
        final formatted = '${result.hour.toString().padLeft(2, '0')}:${result.minute.toString().padLeft(2, '0')}';
        _times.add(formatted);
        _times.sort();
      });
    }
  }

  void _removeTime(int index) {
    setState(() => _times.removeAt(index));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final dao = ref.read(medicationsDaoProvider);
      final now = DateTime.now().toIso8601String();

      final companion = MedicationsTableCompanion(
        name: Value(_nameController.text.trim()),
        description: Value(_descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim()),
        dosageValue: Value(double.parse(_dosageValueController.text.trim())),
        dosageUnit: Value(_dosageUnit),
        frequencyPerDay: Value(_useInterval ? null : _frequencyPerDay),
        intervalHours: Value(_useInterval ? _intervalHours : null),
        times: Value(_times.isEmpty ? '' : _times.join(',')),
        color: Value(_selectedColor),
        icon: Value(_selectedIcon),
        isArchived: const Value(false),
        isCompleted: const Value(false),
        notes: Value(_notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim()),
        startDate: Value(_startDate?.toIso8601String() ?? ''),
        endDate: Value(_endDate?.toIso8601String()),
        remainingPills: Value(int.tryParse(_remainingPillsController.text.trim())),
        createdAt: Value(_isEditing
            ? (await dao.getById(widget.medicationId!))?.createdAt ?? now
            : now),
        updatedAt: Value(now),
      );

      late final int medId;
      if (_isEditing) {
        await dao.updateEntry(companion.copyWith(id: Value(widget.medicationId!)));
        medId = widget.medicationId!;
      } else {
        medId = await dao.insert(companion);
        await _createTodayLogs(medId);
      }

      if (_times.isNotEmpty) {
        final times = _times.map((t) {
          final parts = t.split(':');
          return DateTime(2024, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
        }).toList();
        await NotificationService().scheduleMedicationReminder(
          medicationId: medId,
          medicationName: _nameController.text.trim(),
          dosage: '${_dosageValueController.text.trim()} $_dosageUnit',
          times: times,
        );
      }

      ref.invalidate(allMedicationsProvider);
      ref.invalidate(activeMedicationsProvider);
      if (mounted) context.pop();
    } catch (e) {
      _showSnackbar('Ошибка сохранения: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _createTodayLogs(int medId) async {
    final logsDao = ref.read(logsDaoProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final time in _times) {
      final parts = time.split(':');
      final scheduled = DateTime(
        today.year,
        today.month,
        today.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      await logsDao.insert(MedicationLogsTableCompanion(
        medicationId: Value(medId),
        scheduledTime: Value(scheduled.toIso8601String()),
        status: const Value('scheduled'),
        createdAt: Value(now.toIso8601String()),
      ));
    }
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактировать лекарство' : 'Добавить лекарство'),
        actions: [
          ElevatedButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Сохранить'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading && _isEditing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Основная информация',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Название',
                                hintText: 'напр. Аспирин',
                              ),
                              validator: (v) =>
                                  v == null || v.trim().isEmpty ? 'Обязательно' : null,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Описание',
                                hintText: 'Необязательно...',
                              ),
                              minLines: 1,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Дозировка',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _dosageValueController,
                              decoration: const InputDecoration(
                                labelText: 'Значение',
                                hintText: '0.5',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Обязательно';
                                }
                                if (double.tryParse(v.trim()) == null) {
                                  return 'Неверное число';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              initialValue: _dosageUnit,
                              items: _units
                                  .map((u) => DropdownMenuItem(
                                      value: u, child: Text(u)))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _dosageUnit = v!),
                              decoration: const InputDecoration(
                                labelText: 'Единица',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Даты и остаток',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _startDate ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2035),
                                );
                                if (date != null) {
                                  setState(() => _startDate = date);
                                }
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Дата начала',
                                  suffixIcon: _startDate != null
                                      ? IconButton(
                                          icon: const Icon(Bootstrap.x, size: 18),
                                          onPressed: () =>
                                              setState(() => _startDate = null),
                                        )
                                      : null,
                                ),
                                child: Text(
                                  _startDate != null
                                      ? '${_startDate!.day.toString().padLeft(2, '0')}.${_startDate!.month.toString().padLeft(2, '0')}.${_startDate!.year}'
                                      : 'Не указана',
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _endDate ?? _startDate ?? DateTime.now(),
                                  firstDate: _startDate ?? DateTime.now(),
                                  lastDate: DateTime(2035),
                                );
                                if (date != null) {
                                  setState(() => _endDate = date);
                                }
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Дата окончания',
                                  suffixIcon: _endDate != null
                                      ? IconButton(
                                          icon: const Icon(Bootstrap.x, size: 18),
                                          onPressed: () =>
                                              setState(() => _endDate = null),
                                        )
                                      : null,
                                ),
                                child: Text(
                                  _endDate != null
                                      ? '${_endDate!.day.toString().padLeft(2, '0')}.${_endDate!.month.toString().padLeft(2, '0')}.${_endDate!.year}'
                                      : 'Не указана',
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _remainingPillsController,
                              decoration: const InputDecoration(
                                labelText: 'Остаток таблеток',
                                hintText: 'Необязательно',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Расписание',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text('Интервал (каждые X ч)'),
                              value: _useInterval,
                              onChanged: (v) =>
                                  setState(() => _useInterval = v),
                              contentPadding: EdgeInsets.zero,
                            ),
                            if (_useInterval) ...[
                              const SizedBox(height: 8),
                              TextField(
                                controller: TextEditingController(
                                  text: _intervalHours?.toString() ?? '',
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Интервал (ч)',
                                  hintText: '8',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => _intervalHours =
                                    double.tryParse(v),
                              ),
                            ] else ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Раз в день:'),
                                  const SizedBox(width: 12),
                                  OutlinedButton(
                                    onPressed: _frequencyPerDay > 1
                                        ? () => setState(
                                            () => _frequencyPerDay--)
                                        : null,
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(36, 36),
                                      padding: const EdgeInsets.all(0),
                                    ),
                                    child: const Icon(Bootstrap.dash, size: 16),
                                  ),
                                  const SizedBox(width: 12),
                                  Text('$_frequencyPerDay'),
                                  const SizedBox(width: 12),
                                  OutlinedButton(
                                    onPressed: _frequencyPerDay < 6
                                        ? () => setState(
                                            () => _frequencyPerDay++)
                                        : null,
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(36, 36),
                                      padding: const EdgeInsets.all(0),
                                    ),
                                    child: const Icon(Bootstrap.plus_lg, size: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Text('Время:'),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: _addTime,
                                    child: const Text('+ Добавить время'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: _times.asMap().entries.map((entry) {
                                  return Chip(
                                    label: Text(entry.value),
                                    onDeleted: () => _removeTime(entry.key),
                                    deleteIcon:
                                        const Icon(Bootstrap.x, size: 16),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Внешний вид',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 16),
                            const Text('Цвет:', style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  AppColors.medicationColors.map((colorInt) {
                                final c = Color(colorInt);
                                final isSelected = _selectedColor == colorInt;
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedColor = colorInt),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: c,
                                      borderRadius: BorderRadius.circular(8),
                                      border: isSelected
                                          ? Border.all(
                                              color: theme.colorScheme.onSurface,
                                              width: 3)
                                          : null,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            const Text('Иконка:',
                                style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: MedicationIcons.icons.asMap().entries.map((entry) {
                                final icon = entry.value;
                                final isSelected = _selectedIcon == icon.codePoint.toString();
                                return GestureDetector(
                                  onTap: () => setState(
                                      () => _selectedIcon = icon.codePoint.toString()),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Color(_selectedColor).withAlpha(30)
                                          : theme.colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(10),
                                      border: isSelected
                                          ? Border.all(
                                              color: Color(_selectedColor),
                                              width: 2)
                                          : null,
                                    ),
                                    child: Icon(icon,
                                        color: isSelected
                                            ? Color(_selectedColor)
                                            : null),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Заметки',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _notesController,
                              decoration: const InputDecoration(
                                hintText: 'Дополнительные заметки...',
                              ),
                              minLines: 3,
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}
