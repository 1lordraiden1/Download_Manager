import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Nots {
  static Future initialize(
      FlutterLocalNotificationsPlugin notificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettings =
        new InitializationSettings(android: androidInitialize);

    await notificationsPlugin.initialize(initializationSettings);
  }

  static Future showBigTextNot(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin plugin}) async {
    AndroidNotificationDetails androidChannelSpecs =
        new AndroidNotificationDetails(
      'notificaion',
      'channel_name',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidChannelSpecs,);

    await plugin.show(id, title, body, not);
  }
}
