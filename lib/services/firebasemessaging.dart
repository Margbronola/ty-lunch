// ignore_for_file: avoid_print
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tylunch/services/api/authentication.dart';

class PushNotification {
  PushNotification._pr();
  static final PushNotification _instance = PushNotification._pr();
  static PushNotification get instance => _instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final Authentication auth = Authentication();

  Future<void> init(context, int id, String accesstoken) async {
    try {
      print("TRYING TO CONNECT TO FIREBASE PROVIDER FOR PUSH NOTIFICATIONS");
      await initializeLocalNotifications();

      final NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        listen(context);
        print("settings.authorizationStatus: ${settings.authorizationStatus}");

        final apns = await FirebaseMessaging.instance.getAPNSToken();
        print("APNS TOKEN: $apns");

        final String? ff = await fcmToken();
        print("FCM TOKEN : $ff");
        if (ff != null) {
          auth.addfcmtoken(token: ff, id: id, accesstoken: accesstoken);
        }
      } else {
        print("NOT GRANTED");
      }
    } catch (e, s) {
      print("UNABLE TO CONNECT TO FIREBASE PROVIDER : $e");
      print("STACK TRACE : $s");
      return;
    }
  }

  void listen(context) {
    _fcm.getInitialMessage().then((value) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage MESSAGE : ${message.notification?.body}");

      display(notification: message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp MESSAGE : $message");
      display(notification: message);
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  Future display({required RemoteMessage notification}) async {
    print("test notification alert");
    print("DATA: ${notification.data}");
    print("TITLE: ${notification.notification?.title ?? ""}");
    print("BODY: ${notification.notification?.body ?? ""}");

    await _flutterLocalNotificationsPlugin.show(
      id: notification.hashCode,
      title: notification.notification?.title ?? "",
      body: notification.notification?.body ?? "",
      notificationDetails: NotificationDetails(
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          // largeIcon: FilePathAndroidBitmap(largeIconPath),
          styleInformation: const BigTextStyleInformation(''),
        ),
      ),
      payload: notification.data['link'],
    );
  }

  Future<String?> fcmToken() async => await _fcm.getToken();
}
