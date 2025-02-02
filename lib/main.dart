import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/const/stringconst.dart';
import 'package:test_app/pages/MenuList/menulistcontroller.dart';
import 'package:get/get.dart';

import 'package:test_app/const/routeconst.dart';
import 'package:test_app/pages/listLeaveRequest/listRequestController.dart';
import 'package:test_app/services/notifi_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'pages/requests/requestcontroller.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
  '1',
  'test',
  channelDescription: 'your channel description',
);
const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
Future<void> main() async {
  Get.put(MenuListController());
  Get.put(LeaveRequestListController());
  Get.put(RequestViewController());

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  tz.initializeTimeZones();

//  final InitializationSettings initializationSettings = InitializationSettings(
//     android: AndroidInitializationSettings('flutter_logo'),
//    );
//    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
// flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//     AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
// flutterLocalNotificationsPlugin.initialize(initializationSettings);

  WidgetsFlutterBinding.ensureInitialized();
  //NotificationService().initNotification();
  await MenuListController().init();
  var menuListController = MenuListController();
  await menuListController.init();

  // Load deleted entries from shared preferences
  await menuListController.loadDeletedEntries();
  await NotificationService().initNotification();
  Timer(const Duration(seconds: 6), () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var key = prefs.getString(Appstring.userkey);
    if (key == null) {
      runApp(
        GetMaterialApp(
          initialRoute: Appstring.login,
          debugShowCheckedModeBanner: false,
          getPages: Routeconst.route,
        ),
      );
    } else {
      runApp(GetMaterialApp(
        initialRoute: Appstring.home,
        debugShowCheckedModeBanner: false,
        getPages: Routeconst.route,
      ));
    }
  });

  // FlutterNativeSplash.remove();
  await scheduleNotification();
}

Future<void> scheduleNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Scheduled Title',
    'Scheduled Body',
    tz.TZDateTime(tz.local, DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 5, 30),
    platformChannelSpecifics,
    // ignore: deprecated_member_use
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
} 



// Future<void> _zonedScheduleNotification() async {
//   // Calculate the time until 10:30 AM
//   DateTime now = DateTime.now();
//   DateTime scheduledTime = DateTime(now.year, now.month, now.day, 10, 58);

//   if (now.isAfter(scheduledTime)) {
//     // If it's already past 11:32 AM, schedule it for the same time on the next day
//     scheduledTime = scheduledTime.add(Duration(days: 1));
//   }

//   tz.TZDateTime scheduledTZTime = tz.TZDateTime(tz.local, scheduledTime.year,
//       scheduledTime.month, scheduledTime.day, 10, 55);
//   FlutterLocalNotificationsPlugin().
//   await FlutterLocalNotificationsPlugin().zonedSchedule(
//       0,
//       'Lunch',
//       'plz book your lunch',
//       scheduledTZTime.toLocal(),
    
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime);

  

// }
