
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Request permissions
    await _messaging.requestPermission();

    // Initialize local notifications
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _local.initialize(const InitializationSettings(android: android, iOS: ios), onDidReceiveNotificationResponse: _onSelectNotification);

    // Token
    final token = await _messaging.getToken();
    // Optionally send token to backend

    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await _onSelectNotification(message.data['click_url'] ?? message.data['channel_id']);
    });
  }

  Future<void> handleRemoteMessage(RemoteMessage message) async {
    final notif = message.notification;
    final data = message.data;
    final title = notif?.title ?? data['title'] ?? 'Cricket Live HD';
    final body = notif?.body ?? data['message'] ?? '';
    final payload = data['click_url'] ?? data['channel_id'] ?? jsonEncode(data);

    final androidDetails = AndroidNotificationDetails('cricket_live_hd', 'Cricket Live HD', channelDescription: 'Notifications', importance: Importance.max, priority: Priority.high);
    final iosDetails = DarwinNotificationDetails();
    final platform = NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _local.show(0, title, body, platform, payload: payload);

    // store to notifications_history in Realtime DB
    final ref = FirebaseDatabase.instance.ref().child('notifications_history').push();
    await ref.set({
      'title': title,
      'message': body,
      'image_url': data['image_url'] ?? '',
      'logo_url': data['logo_url'] ?? '',
      'click_url': data['click_url'] ?? '',
      'timestamp': ServerValue.timestamp,
      'data': data,
    });
  }

  Future<void> _onSelectNotification(String? payload) async {
    // handle tap - open URL or channel - implemented by UI via navigator listeners
    // For now we simply print. The app listens to initialMessage when launched.
    // You can route by storing the payload into a shared provider or calling a navigator key.
    if (payload == null) return;
    // TODO: implement navigation handler through a global navigator key or provider
    // Example: navigatorKey.currentState?.pushNamed('/channel', arguments: payload);
  }
}
