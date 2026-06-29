import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:forui/forui.dart';
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

  String _name = '';
  String _description = '';
  double _dosageValue = 0;
  String _notes = '';
  int? _remainingPills;

  late final FDateSelectionController<DateTime?> _startDateController;
  late final FDateSelectionController<DateTime?> _endDateController;
  late final FTimePickerController _timePickerController;

  String _dosageUnit = 'мг';
  int _frequencyPerDay = 1;
  List<String> _times = [];
  int _selectedColor = AppColors.medicationColors[0];
  String? _selectedIcon;
  bool _isLoading = false;
  bool _isEditing = false;

  static const _units = ['мг', 'мл', 'таб', 'капс', 'капли', 'мкг', 'г', 'ед'];

  @override
  void initState() {
    super.initState();
    _startDateController = FDateSelectionController.single(toggleable: true);
    _endDateController = FDateSelectionController.single(toggleable: true);
    _timePickerController = FTimePickerController();
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
      _name = med.name;
      _dosageValue = med.dosageValue;
      _dosageUnit = med.dosageUnit;
      _frequencyPerDay = med.frequencyPerDay ?? 1;
      if (med.times.isNotEmpty) {
        _times = med.times.split(',').where((t) => t.isNotEmpty).toList();
      }
      _selectedColor = med.color;
      _selectedIcon = med.icon;
      _notes = med.notes ?? '';
      _description = med.description ?? '';
      final parsedStart = DateTime.tryParse(med.startDate);
      if (parsedStart != null) _startDateController.value = parsedStart;
      if (med.endDate != null) {
        final parsedEnd = DateTime.tryParse(med.endDate!);
        if (parsedEnd != null) _endDateController.value = parsedEnd;
      }
      _remainingPills = med.remainingPills;
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _timePickerController.dispose();
    super.dispose();
  }

  Future<void> _addTime() async {
    final controller = FTimePickerController();
    final time = await showDialog<FTime>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: SizedBox(
          height: 250,
          child: FTheme(
            data: (Theme.of(ctx).brightness == Brightness.dark
                ? FThemes.zinc.dark
                : FThemes.zinc.light
            ).desktop,
            child: FTimePicker(
              control: FTimePickerControl.managed(controller: controller),
              hour24: true,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          FButton(
            onPress: () => Navigator.pop(ctx, controller.value),
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (time != null) {
      setState(() {
        _times.add('${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
        _times.sort();
      });
    }
  }

  void _removeTime(int index) {
    setState(() => _times.removeAt(index));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    try {
      final dao = ref.read(medicationsDaoProvider);
      final now = DateTime.now().toIso8601String();

      final companion = MedicationsTableCompanion(
        name: Value(_name.trim()),
        description: Value(_description.trim().isEmpty
            ? null
            : _description.trim()),
        dosageValue: Value(_dosageValue),
        dosageUnit: Value(_dosageUnit),
        frequencyPerDay: Value(_frequencyPerDay),
        intervalHours: const Value(null),
        times: Value(_times.isEmpty ? '' : _times.join(',')),
        color: Value(_selectedColor),
        icon: Value(_selectedIcon),
        isArchived: const Value(false),
        isCompleted: const Value(false),
        notes: Value(_notes.trim().isEmpty ? null : _notes.trim()),
        startDate: Value(_startDateController.value?.toIso8601String() ?? ''),
        endDate: Value(_endDateController.value?.toIso8601String()),
        remainingPills: Value(_remainingPills),
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
          medicationName: _name.trim(),
          dosage: '$_dosageValue $_dosageUnit',
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
  Widget build(BuildContext context) => Scaffold(
    body: FTheme(
      data: (Theme.of(context).brightness == Brightness.dark
          ? FThemes.zinc.dark
          : FThemes.zinc.light
      ).desktop,
      child: LayoutBuilder(
        builder: (ctx, _) {
          final fTheme = ctx.theme;
          return Column(
        children: [
          FHeader.nested(
            title: Text(_isEditing ? 'Редактировать лекарство' : 'Добавить лекарство'),
            prefixes: [
              FButton(
                variant: .outline,
                size: .sm,
                onPress: () => context.pop(),
                child: const Icon(FLucideIcons.arrowLeft, size: 16),
              ),
            ],
            suffixes: [
              FButton(
                onPress: _isLoading ? null : _save,
                child: _isLoading
                    ? FCircularProgress(size: .sm)
                    : const Text('Сохранить'),
              ),
            ],
          ),
          Expanded(
            child: _isLoading && _isEditing
                ? const Center(child: FCircularProgress())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Основная информация',
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 16),
                                  FTextFormField(
                                    control: FTextFieldControl.managed(initial: TextEditingValue(text: _name)),
                                    label: const Text('Название'),
                                    hint: 'напр. Аспирин',
                                    validator: (v) =>
                                        v == null || v.trim().isEmpty ? 'Обязательно' : null,
                                    onSaved: (v) => _name = v ?? '',
                                  ),
                                  const SizedBox(height: 12),
                                  FTextFormField(
                                    control: FTextFieldControl.managed(initial: TextEditingValue(text: _description)),
                                    label: const Text('Описание'),
                                    hint: 'Необязательно...',
                                    minLines: 1,
                                    maxLines: 3,
                                    onSaved: (v) => _description = v ?? '',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            FCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Дозировка',
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 16),
                                  FTextFormField(
                                    control: FTextFieldControl.managed(initial: TextEditingValue(
                                        text: _dosageValue == 0 ? '' : _dosageValue.toString())),
                                    label: const Text('Значение'),
                                    hint: '0.5',
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
                                    onSaved: (v) => _dosageValue = double.tryParse(v ?? '') ?? 0,
                                  ),
                                  const SizedBox(height: 12),
                                  FSelect<String>.rich(
                                    control: FSelectControl.managed(initial: _dosageUnit),
                                    hint: 'Выберите единицу',
                                    format: (s) => s,
                                    children: [
                                      for (final unit in _units)
                                        FSelectItemMixin.item(title: Text(unit), value: unit),
                                    ],
                                    onSaved: (v) {
                                      if (v != null) _dosageUnit = v;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            FCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Даты и остаток',
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 16),
                                  FDateField.calendar(
                                    selectionControl: FDateSelectionControl.managedSingle(
                                      controller: _startDateController,
                                      toggleable: true,
                                    ),
                                    label: const Text('Дата начала'),
                                    description: const Text('Выберите дату начала приёма'),
                                    hint: 'Не указана',
                                    clearable: true,
                                    autovalidateMode: AutovalidateMode.disabled,
                                  ),
                                  const SizedBox(height: 12),
                                  FDateField.calendar(
                                    selectionControl: FDateSelectionControl.managedSingle(
                                      controller: _endDateController,
                                      toggleable: true,
                                    ),
                                    label: const Text('Дата окончания'),
                                    description: const Text('Выберите дату окончания приёма'),
                                    hint: 'Не указана',
                                    clearable: true,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    validator: (date) {
                                      final start = _startDateController.value;
                                      if (date != null && start != null && date.isBefore(start)) {
                                        return 'Дата окончания не может быть раньше даты начала';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  FTextFormField(
                                    control: FTextFieldControl.managed(initial: TextEditingValue(
                                        text: _remainingPills?.toString() ?? '')),
                                    label: const Text('Остаток таблеток'),
                                    hint: 'Необязательно',
                                    keyboardType: TextInputType.number,
                                    onSaved: (v) => _remainingPills = int.tryParse(v ?? ''),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            FCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Расписание',
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Text('Раз в день:'),
                                      const SizedBox(width: 12),
                                      FButton(
                                        variant: .outline,
                                        size: .sm,
                                        mainAxisSize: .min,
                                        onPress: _frequencyPerDay > 1
                                            ? () => setState(
                                                () => _frequencyPerDay--)
                                            : null,
                                        child: const Icon(FLucideIcons.minus, size: 16),
                                      ),
                                      const SizedBox(width: 12),
                                      Text('$_frequencyPerDay'),
                                      const SizedBox(width: 12),
                                      FButton(
                                        variant: .outline,
                                        size: .sm,
                                        mainAxisSize: .min,
                                        onPress: _frequencyPerDay < 6
                                            ? () => setState(
                                                () => _frequencyPerDay++)
                                            : null,
                                        child: const Icon(FLucideIcons.plus, size: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Text('Время:'),
                                      const Spacer(),
                                      FButton(
                                        variant: .outline,
                                        size: .sm,
                                        mainAxisSize: .min,
                                        onPress: _addTime,
                                        child: const Text('+ Добавить время'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (_times.isNotEmpty)
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      children: _times.asMap().entries.map((entry) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: fTheme.colors.primary.withAlpha(25),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                entry.value,
                                                style: TextStyle(
                                                  color: fTheme.colors.primary,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              GestureDetector(
                                                onTap: () => _removeTime(entry.key),
                                                child: Icon(
                                                  FLucideIcons.x,
                                                  size: 14,
                                                  color: fTheme.colors.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            FCard(
                              child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                                    color: fTheme.colors.foreground,
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
                                                : fTheme.colors.primary.withAlpha(10),
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
                            const SizedBox(height: 12),
                            FCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Заметки',
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 16),
                                  FTextFormField(
                                    control: FTextFieldControl.managed(initial: TextEditingValue(text: _notes)),
                                    label: const Text('Заметки'),
                                    hint: 'Дополнительные заметки...',
                                    minLines: 3,
                                    maxLines: 5,
                                    onSaved: (v) => _notes = v ?? '',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        );
        },
      ),
    ),
  );
}
