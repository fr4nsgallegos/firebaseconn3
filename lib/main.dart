import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseconn3/pages/home_page.dart';
import 'package:firebaseconn3/pages/login_create_page.dart';
import 'package:firebaseconn3/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initMessaging();

  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}
