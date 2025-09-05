import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_example/home_page.dart';
import 'package:flutter/material.dart';
import 'package:short_navigation/short_navigation.dart';

late AwesomeNotifications awesomeNotifications;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  awesomeNotifications = AwesomeNotifications();

  await awesomeNotifications.initialize(null, [
    NotificationChannel(
      channelKey: 'key1',
      channelName: 'Test Channel',
      channelDescription: 'Channel Description',
      playSound: true,
    ),
  ], debug: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Go.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
