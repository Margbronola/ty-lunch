// ignore_for_file: avoid_print
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tylunch/services/api/authentication.dart';

class PushNotification {
  PushNotification._pr();
  static final PushNotification _instance = PushNotification._pr();
  static PushNotification get instance => _instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final Authentication auth = Authentication();

  Future<void> init(context, int id, String accesstoken) async {
    try {
      final NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        sound: true,
        provisional: false,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        listen(context);
        print("${settings.authorizationStatus}");
      } else {
        print("NOT GRANTED");
      }
      final String? ff = await fcmToken();
      auth.addfcmtoken(
        token: "$ff",
        id: id,
        accesstoken: accesstoken,
      );
      print("FCM TOKEN : $ff");
    } catch (e) {
      print("UNABLE TO CONNECT TO FIREBASE PROVIDER : $e");
      return;
    }
  }

  void listen(context) {
    _fcm.getInitialMessage().then((value) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("MESSAGE : ${message.notification?.body}");
      // Flushbar(
      //   title: message.notification!.title,
      //   message: message.notification!.body,
      //   flushbarPosition: FlushbarPosition.TOP,
      //   duration: const Duration(seconds: 3),
      // ).show(context);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("MESSAGE : $message");
    });
  }

  Future<String?> fcmToken() async => await _fcm.getToken();
}
