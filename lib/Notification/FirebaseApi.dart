import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message)async{
  print(message.notification?.title);
}

class FirebaseApi{
  final _firebaseMessage = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessage.requestPermission();
    final token = await _firebaseMessage.getToken();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}