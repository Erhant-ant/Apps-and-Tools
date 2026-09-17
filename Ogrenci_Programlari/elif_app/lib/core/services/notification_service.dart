import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    tz.initializeTimeZones();
    // Default to a common timezone, can be made dynamic
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Initialization
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );
    _isInitialized = true;

    await requestPermissions();
  }

  Future<void> requestPermissions() async {
    if (kIsWeb) return; // Skip dart:io checks on web

    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
      // On Android 12+ we might also need to request exact alarms permission,
      // but usually USE_EXACT_ALARM is enough.
    }
  }

  Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'daily_reminders',
      'Günlük Hatırlatıcılar',
      channelDescription: 'Ders çalışma ve tekrar hatırlatıcıları',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  Future<void> scheduleDailyReminder(int reviewCount) async {
    // Uygulama widget olarak test edildiğinde main() çalışmaz. Bildirim
    // eklentisi başlatılmadan planlama yapmaya çalışmak LateError üretir.
    if (!_isInitialized) return;

    // Cancel previously scheduled daily reminder to avoid duplicates
    await _flutterLocalNotificationsPlugin.cancel(id: 1);

    if (reviewCount <= 0) return;

    // Her gün saat 17:00 için planla
    var now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      17,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'daily_reminders',
      'Günlük Hatırlatıcılar',
      channelDescription: 'Ders çalışma ve tekrar hatırlatıcıları',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: 1,
      title: 'Zamanı Geldi Elif! 🎯',
      body: 'Bugün çözmen gereken $reviewCount tekrar hedefin var, Sebo seni bekliyor!',
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
