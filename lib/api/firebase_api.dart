// import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print('Title: ${message.notification?.title}');
//   print('Body: ${message.notification?.body}');
//   print('Payload: ${message.data}');
// }

// class FirebaseApi {
//   final _firebaseMassaging = FirebaseMessaging.instance;
//   Future<void> initNotifications() async {
//     await _firebaseMassaging.requestPermission();
//     final fCMToken = await _firebaseMassaging.getToken();
//     print('Token: $fCMToken');
//     FirebaseMessaging.onBackgroundMessage((message) => null)
//   }
// }
