import 'package:flutter/material.dart';

class TimePickerDialog extends StatelessWidget {
  const TimePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выберите время'),
      content: SizedBox(
        width: 280,
        height: 300,
        child: TimePickerWidget(
          onTimeSelected: (time) => Navigator.pop(context, time),
        ),
      ),
    );
  }
}

class TimePickerWidget extends StatefulWidget {
  final void Function(TimeOfDay time)? onTimeSelected;

  const TimePickerWidget({super.key, this.onTimeSelected});

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  final int _selectedHour = 8;
  final int _selectedMinute = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ListWheelScrollView(
                  itemExtent: 36,
                  diameterRatio: 1.5,
                  children: List.generate(24, (i) {
                    final isSelected = i == _selectedHour;
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withAlpha(25)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          i.toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const Text(':', style: TextStyle(fontSize: 24)),
              Expanded(
                child: ListWheelScrollView(
                  itemExtent: 36,
                  diameterRatio: 1.5,
                  children: List.generate(12, (i) {
                    final minute = i * 5;
                    final isSelected = minute == _selectedMinute;
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withAlpha(25)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          minute.toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () {
            widget.onTimeSelected
                ?.call(TimeOfDay(hour: _selectedHour, minute: _selectedMinute));
          },
          child: const Text('Подтвердить'),
        ),
      ],
    );
  }
}
