// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/ROUTES/app_routes.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/VIEWS/all_nav_screens/_all_nav_screens/all_nav_screens.dart.dart';
import 'package:project_bist/VIEWS/onboardings/intro_screens.dart';
import 'package:project_bist/VIEWS/onboardings/splash_screen.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:project_bist/main.dart';

final themeProvider = StateNotifierProvider<AppThemeNotifier, ThemeMode>((ref) {
  return AppThemeNotifier();
});

AppThemeNotifier appTheme = AppThemeNotifier();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AndroidNotificationChannel androidNotificationChannel =
      const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future initializeForegroundNotification() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/logo');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    if (context.mounted) {
      handleForegroundNotification(context);
    }
    final platform =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(androidNotificationChannel);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload ?? ""));
      handleMessage(message, context);
    });
  }

  void handleForegroundNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                androidNotificationChannel.id,
                androidNotificationChannel.name,
                channelDescription: androidNotificationChannel.description,
                icon: android.smallIcon,
              ),
            ),
            payload: jsonEncode(message.toMap()));
      }
      // void onDidReceiveLocalNotification(
      //     int id, String? title, String? body, String? payload) async {
      //   // display a dialog with the notification details, tap ok to go to another page
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) => CupertinoAlertDialog(
      //       title: Text(title ?? ''),
      //       content: Text(body ?? ''),
      //       actions: [
      //         CupertinoDialogAction(
      //           isDefaultAction: true,
      //           child: Text('Ok'),
      //           onPressed: () async {
      //             Navigator.of(context, rootNavigator: true).pop();
      //             // await Navigator.push(
      //             //   context,
      //             //   MaterialPageRoute(
      //             //     builder: (context) => SecondScreen(payload),
      //             //   ),
      //             // );
      //           },
      //         )
      //       ],
      //     ),
      //   );
      // }
    });
  }

  @override
  void initState() {
    initializeForegroundNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Builder(builder: (context) {
          return ValueListenableBuilder<Box>(
              valueListenable: getIt<AppModel>().appCacheBox!.listenable(),
              builder: (context, box, widget) {
                String theme = box.get(AppConst.THEME_MODE_KEY,
                    defaultValue: AppConst.SYSTEM_THEME_KEY);
                return MaterialApp(
                  title: AppConst.APP_NAME,
                  debugShowCheckedModeBanner: false,
                  builder: (context, child) {
                    return botToastBuilder(context, child);
                  },
                  navigatorObservers: [
                    BotToastNavigatorObserver()
                  ],
                  theme: appTheme.lightTheme,
                  darkTheme: appTheme.darkTheme,
                  themeMode: switch (theme) {
                    AppConst.DARK_THEME_KEY => ThemeMode.dark,
                    AppConst.LIGHT_THEME_KEY => ThemeMode.light,
                    AppConst.SYSTEM_THEME_KEY => ThemeMode.system,
                    _ => ThemeMode.system
                  },
                  onGenerateRoute: AppRoutes.onGenerateRoute,
                  initialRoute: SplashScreen.splashScreen,
                );
              });
        });
      },
    );
  }

  void handleMessage(RemoteMessage message, BuildContext context) {
    // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    print("in app.dart");
    if (message.data.containsKey('type')) {
      if (message.data['type'] == 'topic') {
        /// [TO-DO Navigate to corresponding (topic) page]
      }
    } else {
      // navigatorKey.currentState?.pushNamedAndRemoveUntil(
      //     getUserHasSeenOnboardingScreens() == true
      //         ? AllNavScreens.allNavScreens
      //         : IntroScreens.introScreens,
      //     (route) => false);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context,
            AppMethods.getUserHasSeenOnboardingScreens() == true
                ? AllNavScreens.allNavScreens
                : IntroScreens.introScreens,
            (route) => false);
      }
    }
  }
}

