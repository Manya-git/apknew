import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ride_mobile/app/modules/landing/views/splash_screen.dart';
import 'package:ride_mobile/app/utils/string_utils.dart';

import '../../modules/home/views/home_view.dart';

class PushNotifications {
  static final localNotifications = FlutterLocalNotificationsPlugin();

  static void pushNotificationsListener() async {
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      StringUtils.debugPrintMode("onMessage: $message");
      showLocalNotification(message.notification!.title!,message.notification!.body!);
      // go to home page....
      // Get.offAll(() => const SplashScreen());
      showLocalNotification(message.notification!.title!,message.notification!.body!);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      StringUtils.debugPrintMode("onMessageOpenedApp: $message");
      Get.offAll(() => const SplashScreen());
    });
  }

  static void initLocalNotifications() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    final initializationSettingsIOS = DarwinInitializationSettings(onDidReceiveLocalNotification: (id, title, body, payload) => onDidReceiveLocalNotification);
    final initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await localNotifications.initialize(initializationSettings, onDidReceiveNotificationResponse: (response) async {Get.offAll(() => const HomeView());});
  }

   static void onDidReceiveLocalNotification() {
    Get.offAll(() => const HomeView());
  }

  static void showLocalNotification(String title, String body) async {
    // print body...
    StringUtils.debugPrintMode("showLocalNotification: $body");
    // print title...
    StringUtils.debugPrintMode("showLocalNotification: $title is title");

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      icon: '@mipmap/launcher_icon',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await localNotifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
