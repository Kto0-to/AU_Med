import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' show LucideIcons;

class DateNavigation extends StatelessWidget {
  final DateTime selectedDate;
  final bool isToday;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onTapDate;

  const DateNavigation({
    super.key,
    required this.selectedDate,
    required this.isToday,
    required this.onBack,
    required this.onForward,
    required this.onTapDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(LucideIcons.chevronLeft),
              onPressed: onBack,
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTapDate,
                child: Text(
                  DateFormat('d MMMM yyyy', 'ru').format(selectedDate),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.chevronRight),
              onPressed: isToday ? null : onForward,
            ),
          ],
        ),
      ),
    );
  }
}
