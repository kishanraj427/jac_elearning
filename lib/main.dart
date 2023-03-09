import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'AppColor.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'MyHomePage.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'jac', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    enableVibration: true,
    ledColor: Colors.redAccent,
    showBadge: true,
    enableLights: true,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JAC eLearning',
        theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.redAccent,
            backgroundColor: AppColor.background,
            appBarTheme: AppBarTheme(
              color: AppColor.background,
              iconTheme: IconThemeData(color: Colors.redAccent),
            )),
        home: MySplash()
        //MyHomePage(title: 'JAC eLearning'),
        );
  }
}


class MySplash extends StatefulWidget {
  MySplash({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MySplash> {
  @override
  void initState() {
    super.initState();
    var initializationSettingAndroid =
        AndroidInitializationSettings('@drawable/ic_noti');
    var initializationSetting =
        InitializationSettings(android: initializationSettingAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSetting);
    FirebaseMessaging.instance.subscribeToTopic("jac");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: '@drawable/ic_noti',
              priority: Priority.high,
              importance: Importance.high,
              color: Colors.redAccent,
              playSound: true,
              enableLights: true,
              enableVibration: true,
              vibrationPattern: Int64List.fromList([0, 100, 1000, 200, 2000]),
            )));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

    loadPage();
  }

  loadPage(){

    Timer(Duration(seconds: 4), ()=> Get.off(MyHomePage(), curve: Curves.elasticInOut));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/lottie/animi.json',
          alignment: Alignment.center,
          repeat: false,
          width: 300,
          height: 350,
        ),
      ),
    );
  }
}
