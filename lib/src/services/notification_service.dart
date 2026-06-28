import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      settings: InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }

  Future<void> scheduleMedicationReminder({
    required int medicationId,
    required String medicationName,
    required String dosage,
    required List<DateTime> times,
  }) async {
    await cancelMedicationReminders(medicationId);

    for (var i = 0; i < times.length; i++) {
      final now = DateTime.now();
      final scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        times[i].hour,
        times[i].minute,
      );

      if (scheduledDate.isBefore(now)) {
        continue;
      }

      await _plugin.zonedSchedule(
        id: medicationId * 100 + i,
        title: medicationName,
        body: 'Time to take $medicationName - $dosage',
        scheduledDate: scheduledDate,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'medication_reminder',
            'Medication Reminders',
            channelDescription: 'Reminders to take medications',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelMedicationReminders(int medicationId) async {
    for (var i = 0; i < 10; i++) {
      await _plugin.cancel(id: medicationId * 100 + i);
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
