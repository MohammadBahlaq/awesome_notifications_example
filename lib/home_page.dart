import 'dart:async';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_example/main.dart';
import 'package:flutter/material.dart';
import 'package:short_navigation/short_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    awesomeNotifications.setListeners(
      onActionReceivedMethod: (received) async {
        if (received.buttonKeyPressed == 'OPEN') {
          log("App opened");
        } else if (received.buttonKeyPressed == 'REPLY') {
          String? reply = received.buttonKeyInput.trim();
          GoMessenger.dialog(AlertDialog(content: Text(reply)));
          log('reply : $reply');
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: requestNotificationPermission,
              child: Text("Request permision"),
            ),
            ElevatedButton(
              onPressed: showNotification,
              child: Text("Show Notification"),
            ),
            ElevatedButton(
              onPressed: showNotificationAfterSeconds,
              child: Text("Show Notification after seconds"),
            ),
            ElevatedButton(
              onPressed: showNotificationEveryDay,
              child: Text("Show Notification every day"),
            ),
            ElevatedButton(
              onPressed: showNotificationEveryWeek,
              child: Text("Show Notification every week"),
            ),
            ElevatedButton(
              onPressed: awesomeNotifications.cancelAllSchedules,
              child: Text("Cancel all schedules"),
            ),
          ],
        ),
      ),
    );
  }

  void requestNotificationPermission() async {
    bool isAllowed = await awesomeNotifications.isNotificationAllowed();

    if (!isAllowed) {
      awesomeNotifications.requestPermissionToSendNotifications();
    }
  }

  void showNotification() {
    awesomeNotifications.createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: 'Hello',
        body: 'This is a test notification',
        wakeUpScreen: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'OPEN',
          label: 'فتح التطبيق',
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: 'REPLY',
          label: 'رد',
          icon: 'resource://drawable/ic_reply',
          requireInputText: true,
          autoDismissible: true,
        ),
      ],
    );
  }

  void showNotificationAfterSeconds() {
    awesomeNotifications.createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: 'تنبيه مجدول',
        body: 'هذا إشعار مجدول لوقت معين',
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar.fromDate(
        date: DateTime.now().add(Duration(seconds: 5)),
        preciseAlarm: true,
        repeats: false,
      ),
    );
  }

  Future<void> showNotificationEveryDay() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      confirmText: "Schedule",
    );

    if (time != null) {
      awesomeNotifications.createNotification(
        content: NotificationContent(
          id: 20,
          channelKey: 'key1',
          title: 'تنبيه يومي',
          body: 'هذا إشعار يتكرر يومياً',
        ),
        schedule: NotificationCalendar(
          hour: time.hour,
          minute: time.minute,
          second: 0,
          repeats: true,
          preciseAlarm: true,
        ),
      );
    }
  }

  Future<void> showNotificationEveryWeek() async {
    DateTime? date;
    TimeOfDay? time;

    GoMessenger.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                date = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 6)),
                );
              },
              child: Text("Select date"),
            ),
            ElevatedButton(
              onPressed: () async {
                time = await showTimePicker(
                  context: context,
                  initialTime: time ?? TimeOfDay.now(),
                );
              },
              child: Text("Select time"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (date != null && time != null) {
                  awesomeNotifications.createNotification(
                    content: NotificationContent(
                      id: 30,
                      channelKey: 'key1',
                      title: 'تنبيه أسبوعي',
                      body: 'هذا إشعار يتكرر أسبوعياً',
                    ),
                    schedule: NotificationCalendar(
                      weekday: date!.weekday,
                      hour: time!.hour,
                      minute: time!.minute,
                      second: 0,
                      repeats: true,
                      preciseAlarm: true,
                    ),
                  );
                }
              },
              child: Text("Schedule"),
            ),
          ],
        ),
      ),
    );
  }
}
