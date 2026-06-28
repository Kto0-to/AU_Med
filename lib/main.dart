import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:au_med/src/database/database.dart';
import 'package:au_med/src/providers/database_provider.dart';
import 'package:au_med/src/services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await AppDatabase.getInstance();

  await NotificationService().initialize();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: const AuMedApp(),
    ),
  );
}
