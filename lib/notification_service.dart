import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';

/// This file like a template you can use it in your projects
/// just copy this file and past it in your project

Future<void> onActionReceivedMethod(ReceivedAction received) async {
  // if (received.buttonKeyPressed == 'Attendance') {
  // Navigate to some page that you want, or change index of BottomNavigationBar
  // bottomBarIndexNotifier.value = 2;
  // }
}

class NotificationsService {
  NotificationsService._();

  static final instance = NotificationsService._();

  final awesomeNotifications = AwesomeNotifications();

  final String _notificationsChannelName = "app_trainer_notifications_channel";

  Future<void> initial() async {
    await _setupLocalNotifications();
  }

  //!Set Local Notifications
  Future<void> _setupLocalNotifications() async {
    await awesomeNotifications.initialize('resource://drawable/launcher_icon', [
      NotificationChannel(
        channelKey: _notificationsChannelName,
        channelName: _notificationsChannelName,
        channelDescription: _notificationsChannelName,
        playSound: true,
      ),
    ], debug: kDebugMode);

    await _requestNotificationPermission();

    await awesomeNotifications.setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  Future<void> _requestNotificationPermission() async {
    bool isAllowed = await awesomeNotifications.isNotificationAllowed();

    if (!isAllowed) {
      await awesomeNotifications.requestPermissionToSendNotifications();
    }
  }

  Future<void> showNotification(
    String title,
    String body, {
    int id = 1,
    Map<String, String?>? payload,
  }) async {
    await awesomeNotifications.createNotification(
      content: NotificationContent(
        id: id,
        channelKey: _notificationsChannelName,
        title: title,
        body: body,
        wakeUpScreen: true,
        payload: payload,
      ),
      // actionButtons: [
      //   NotificationActionButton(key: "Attendance", label: "تسجيل الحضور"),
      // ],
    );
  }

  Future<void> scheduleDailyNotification(String title, String body) async {
    await awesomeNotifications.createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: _notificationsChannelName,
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar(
        hour: 14,
        minute: 54,
        second: 0,
        repeats: true,
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
    );
  }

  Future<void> scheduleWeeklyNotification(
    String title,
    String body, {
    int? weekday,
    int? hour,
    int? minute,
  }) async {
    DateTime dateNow = DateTime.now();

    weekday ??= dateNow.day;
    hour ??= dateNow.hour;
    minute ??= dateNow.minute;

    await awesomeNotifications.createNotification(
      content: NotificationContent(
        id: 3,
        channelKey: _notificationsChannelName,
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar(
        weekday: weekday,
        hour: hour,
        minute: minute,
        second: 0,
        repeats: true,
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
    );
  }
}
