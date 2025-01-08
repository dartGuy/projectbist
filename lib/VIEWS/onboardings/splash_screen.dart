// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/VIEWS/all_nav_screens/_all_nav_screens/all_nav_screens.dart.dart';
import 'package:project_bist/VIEWS/auths/login_screens.dart';
import 'package:project_bist/VIEWS/onboardings/intro_screens.dart';
import 'package:project_bist/WIDGETS/drawer_contents.dart';
import 'package:project_bist/WIDGETS/project_bist_logo.dart';

//ref.watch(switchUserProvider)
class SplashScreen extends ConsumerStatefulWidget {
  static const String splashScreen = "splashScreen";
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  void nextPage() async {
    Future.delayed(Duration(seconds: 3), () {
      ref.invalidate(selectedDrawerProvider);
      setupInteractedMessage();
    });
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    if (initialMessage == null) {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context,
            AppMethods.getUserHasSeenOnboardingScreens() == false
                ? IntroScreens.introScreens
                : AppMethods.getRecognizedUser() == false
                    ? LoginScreen.loginScreen
                    : AllNavScreens.allNavScreens,
            (route) => false);
      }
    }
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data.containsKey("type")) {
      if (message.data['type'] == 'topic') {
        /// [TO-DO Navigate to corresponding (topic) page]
      }
    } else {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context,
            AppMethods.getUserHasSeenOnboardingScreens() == false
                ? IntroScreens.introScreens
                : AppMethods.getRecognizedUser() == false
                    ? LoginScreen.loginScreen
                    : AllNavScreens.allNavScreens,
            (_) => false);
      }
    }
  }

  @override
  void initState() {
    nextPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ProjectBistLogo()),
    );
  }
}
