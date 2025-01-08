
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/core/app.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/firebase_options.dart';

final getIt = GetIt.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  getIt.allowReassignment = true;
  getIt.registerSingleton<AppModel>(AppModel());
  getIt.registerSingleton<UserProfile>(UserProfile());

  await getIt<AppModel>().initApp();
  runApp(const ProviderScope(child: MyApp()));
}

EdgeInsets appPadding() =>
    EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10);

bool isDarkTheme(BuildContext context) {
  return AppThemeNotifier.colorScheme(context).primary == AppColors.white;
}

