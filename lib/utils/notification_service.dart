import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static initMessaging() async {
    String token = await firebaseMessaging.getToken() ?? '-';
    print("TOKEN");
    print(token);
    print("-----------");
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  }

  //DETECTAR EL MENSAJE CUANDO EL APP ESTA ABIERTO
  static _onMessage(RemoteMessage message) {
    if (message.notification != null) {
      print("******************");
      print(message.notification);
      print(message.notification!.title);
      print(message.notification!.body);
      print("******************");
    }
  }

  //OBTENER INFO CUANDO EL APP ESTA EN SEGUNDO PLANO
  static Future _onBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print("------------------------------");
      print(message.notification!.title);
      print(message.notification!.body);
      print("------------------------------");
    }
  }
}
