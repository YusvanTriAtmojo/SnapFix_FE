import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Minta izin notifikasi
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('Permission: ${settings.authorizationStatus}');

    // Ambil token
    String? token = await messaging.getToken();

    print("====================================");
    print("FCM TOKEN");
    print(token);
    print("====================================");
  }
}