import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter/material.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/widgets/texts.dart';

class AppThemeNotifier extends StateNotifier<ThemeMode> {
  static ColorScheme colorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  static ThemeData themeColor(BuildContext context) {
    return Theme.of(context);
  }

  AppThemeNotifier() : super(ThemeMode.dark);

  ///==============[TOGGLE THEME]==============
  ///==============[TOGGLE THEME]==============
  ///==============[TOGGLE THEME]==============
  void toggleTheme({required ThemeMode themeMode}) => state = themeMode;

  ///===========[LIGHT THEME]===========[LIGHT THEME]===========[LIGHT THEME]===========[LIGHT THEME]
  ///===========[LIGHT THEME]===========[LIGHT THEME]===========[LIGHT THEME]===========[LIGHT THEME]
  ///===========[LIGHT THEME]===========[LIGHT THEME]===========[LIGHT THEME]===========[LIGHT THEME]
  ThemeData lightTheme = ThemeData(
      iconTheme: const IconThemeData(size: 20),
      useMaterial3: true,
      fontFamily: Fonts.nunito,
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.primaryColor),
      scaffoldBackgroundColor: AppColors.lightScaffoldColor,
      primaryColor: Colors.red,
      colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: AppColors.primaryColor,
          primary: AppColors.black,
          onPrimary: AppColors.white,
          onSecondary: AppColors.grey4,

          /// [onSecondary:] AppColors.grey,
          error: AppColors.red,
          secondary: AppColors.secondaryColor));

  ///===========[DARK THEME]===========[DARK THEME]===========[DARK THEME]===========[DARK THEME]
  ///===========[DARK THEME]===========[DARK THEME]===========[DARK THEME]===========[DARK THEME]
  ///===========[DARK THEME]===========[DARK THEME]===========[DARK THEME]===========[DARK THEME]
  ThemeData darkTheme = ThemeData(
    iconTheme: const IconThemeData(size: 20),
    fontFamily: Fonts.nunito,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.primaryColor),
    scaffoldBackgroundColor: AppColors.darkScaffoldColor,
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        onPrimary: AppColors.black,
        seedColor: AppColors.primaryColor,
        primary: AppColors.white,
        onSecondary: AppColors.grey2,

        /// [onSecondary:] AppColors.grey,
        error: AppColors.red,
        secondary: AppColors.secondaryColor),
    useMaterial3: true,
  );
}
