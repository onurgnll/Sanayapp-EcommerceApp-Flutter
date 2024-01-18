import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

FirebaseMessaging messaging = FirebaseMessaging.instance;

void saveToken(String email) async {
  var token = await FirebaseMessaging.instance.getToken();
  CollectionReference<Map<String, dynamic>> tokens =
      FirebaseFirestore.instance.collection('usertokens');

  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await tokens.where('email', isEqualTo: email).get();

  if (querySnapshot.docs.isNotEmpty) {
    String documentId = querySnapshot.docs.first.id;
    await tokens.doc(documentId).update({'token': token});
  } else {
    await tokens.add({'email': email, 'token': token});
  }
}

void sendPushMessage(String token, String body, String title) async {
  try {
    final String serverUrl = 'https://fcm.googleapis.com/fcm/send';

    final String serverKey =
        '';

    final Map<String, dynamic> payload = {
      'notification': {'title': title, 'body': body},
      'to': token
    };

    final http.Response response = await http.post(
      Uri.parse(serverUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print('Push message sent successfully');
    } else {
      print('Failed to send push message. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error sending push message: $e');
  }
}
