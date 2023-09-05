
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessagingHelper {
  subscribeToTopic(String topicName) async {
    if (kDebugMode) {
      print("Subscribing");
    }
    await FirebaseMessaging.instance.subscribeToTopic(topicName).onError((error, stackTrace) => print("Error on subscribing ${error}"));
  }
}