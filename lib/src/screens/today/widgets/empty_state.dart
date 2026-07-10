import 'package:flutter/material.dart';
import 'package:icon_plus/icon_plus.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(Bootstrap.capsule_pill, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Нет лекарств',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте первое лекарство для отслеживания',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
