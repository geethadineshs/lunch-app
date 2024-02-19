import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../const/stringconst.dart';

class SplashController extends GetxController {
  Future<void> scheduleNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Title',
      'Scheduled Body',
      tz.TZDateTime(tz.local, DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 12, 23),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> onload() async {
    // await scheduleNotification();

    Timer(const Duration(seconds: 6), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var key = prefs.getString(Appstring.userkey);
      if (key == null) {
        Get.offAllNamed(Appstring.login);
      } else {
        Get.offAllNamed(Appstring.home);
      }
    });
  }

  // showDailyNotification({required String title, required String body, required DateTime notificationTime}) {}
}
