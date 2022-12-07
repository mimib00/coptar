import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestIOSPermissions(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> init() async {
    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //Initialization Settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) => selectNotification(response.payload),
    );
  }

  static const AndroidNotificationDetails _androidNotificationDetails = AndroidNotificationDetails(
    '0',
    'myChannel',
    playSound: true,
    priority: Priority.max,
    importance: Importance.max,
    color: Colors.white,
    enableLights: true,
  );

  static const DarwinNotificationDetails _darwinNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  Future<void> showNotifications(String? title, String? body) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(android: _androidNotificationDetails, iOS: _darwinNotificationDetails),
    );
  }

  void selectNotification(String? payload) async {
    Get.to(() => null);
  }

  @override
  void onInit() async {
    await init();

    Platform.isAndroid
        ? await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
            .requestPermission()
        : await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()!
            .requestPermissions();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotifications(message.notification?.title, message.notification?.body);
      }
    });
    super.onInit();
  }
}
