import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  LocalNotificationsService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static final instance = LocalNotificationsService(FlutterLocalNotificationsPlugin());

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(android: android, iOS: darwin, macOS: darwin);

    await _plugin.initialize(settings: initSettings);

    if (!kIsWeb) {
      await _requestAndroidNotificationsPermissionIfNeeded();
      await _requestDarwinNotificationsPermissionIfNeeded();
    }
  }

  Future<void> _requestAndroidNotificationsPermissionIfNeeded() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  Future<void> _requestDarwinNotificationsPermissionIfNeeded() async {
    final darwin = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await darwin?.requestPermissions(alert: true, badge: true, sound: true);
  }
}
