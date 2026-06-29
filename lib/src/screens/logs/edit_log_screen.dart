import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:icon_plus/icon_plus.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/providers/logs_provider.dart';
import 'package:au_med/src/theme/app_theme.dart';

class EditLogScreen extends ConsumerStatefulWidget {
  final int medicationId;
  final int logId;

  const EditLogScreen({
    super.key,
    required this.medicationId,
    required this.logId,
  });

  @override
  ConsumerState<EditLogScreen> createState() => _EditLogScreenState();
}

class _EditLogScreenState extends ConsumerState<EditLogScreen> {
  String _status = 'scheduled';
  TimeOfDay? _takenTime;
  String? _medicationName;
  String? _dosageInfo;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dao = ref.read(medicationsDaoProvider);
    final logsDao = ref.read(logsDaoProvider);

    final med = await dao.getById(widget.medicationId);
    final logs = await logsDao.getForMedicationOnDate(
        widget.medicationId, DateTime.now());
    final log = logs.where((l) => l.id == widget.logId).firstOrNull;

    if (med != null && log != null) {
      setState(() {
        _medicationName = med.name;
        _dosageInfo = '${med.dosageValue} ${med.dosageUnit}';
        _status = log.status;
        if (log.takenTime != null) {
          final dt = DateTime.parse(log.takenTime!);
          _takenTime = TimeOfDay.fromDateTime(dt);
        }
        _loaded = true;
      });
    }
  }

  Future<void> _save() async {
    final logsDao = ref.read(logsDaoProvider);

    final companion = MedicationLogsTableCompanion(
      status: Value(_status),
      takenTime: Value(_takenTime != null
          ? DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              _takenTime!.hour,
              _takenTime!.minute,
            ).toIso8601String()
          : null),
    );

    await logsDao.updateLog(widget.logId, companion);
    ref.invalidate(logsForMedicationProvider(widget.medicationId));
    ref.invalidate(todayLogsProvider);
    if (mounted) context.pop();
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _takenTime ?? TimeOfDay.now(),
    );
    if (result != null) {
      setState(() => _takenTime = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_loaded ? 'Редактировать запись' : 'Загрузка...'),
        actions: [
          if (_loaded)
            ElevatedButton(
              onPressed: _save,
              child: const Text('Сохранить'),
            ),
        ],
      ),
      body: _loaded
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _medicationName ?? '',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _dosageInfo ?? '',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Статус',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _StatusChip(
                              label: 'Scheduled',
                              icon: FontAwesome.clock,
                              color: Colors.grey,
                              isSelected: _status == 'scheduled',
                              onTap: () => setState(() => _status = 'scheduled'),
                            ),
                            _StatusChip(
                              label: 'Taken',
                              icon: FontAwesome.circle_check,
                              color: AppColors.taken,
                              isSelected: _status == 'taken',
                              onTap: () => setState(() => _status = 'taken'),
                            ),
                            _StatusChip(
                              label: 'Skipped',
                              icon: EvaIcons.skip_forward_outline,
                              color: AppColors.skipped,
                              isSelected: _status == 'skipped',
                              onTap: () => setState(() => _status = 'skipped'),
                            ),
                            _StatusChip(
                              label: 'Missed',
                              icon: FontAwesome.circle_xmark,
                              color: AppColors.missed,
                              isSelected: _status == 'missed',
                              onTap: () => setState(() => _status = 'missed'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Время приёма',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: _pickTime,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.colorScheme.outline),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(FontAwesome.clock, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  _takenTime != null
                                      ? _takenTime!.format(context)
                                      : 'Выберите время',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _takenTime != null
                                        ? null
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(25) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isSelected ? color : Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
