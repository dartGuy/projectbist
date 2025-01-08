import 'package:flutter/material.dart';
import 'package:project_bist/CORE/app.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/WIDGETS/error_page.dart';

// ignore: must_be_immutable
class FirebaseInitializationErrorPage extends StatelessWidget {
  static const String firebaseInitializationError =
      "firebaseInitializationError";
  String? errorMessage;
  FirebaseInitializationErrorPage({this.errorMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConst.APP_NAME,
      debugShowCheckedModeBanner: false,
      // builder: (context, child) {
      //   return botToastBuilder(context, child);
      // },
      // navigatorObservers: [BotToastNavigatorObserver()],
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      // themeMode: switch (theme) {
      //   AppConst.DARK_THEME_KEY => ThemeMode.dark,
      //   AppConst.LIGHT_THEME_KEY => ThemeMode.light,
      //   AppConst.SYSTEM_THEME_KEY => ThemeMode.system,
      //   _ => ThemeMode.system
      // },
      home: ErrorPage(
          message: errorMessage ??
              "Important components initialization failed.\nEnsure you have a stable internet, close the app and try again!"),
    );
  }
}
