import 'package:flutter/material.dart';
import 'package:project_bist/THEMES/app_themes.dart';

class AppColors {
  /// [SCAFFOLD COLOR THEMES]
  static Color darkScaffoldColor = const Color(0xff1A1A1A);
  static Color lightScaffoldColor = Colors.grey.shade50;

  /// [BLACK AND WHITE]
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);

  /// [GREY COLORS]
  static const Color grey1 = Color(0xffD8D8D8);
  static const Color grey2 = Color(0xff9C9C9C);
  static const Color grey3 = Color(0xff6B6B6B);
  static const Color grey4 = Color(0xff3A3A3A);

  /// [PRIMARY/SECONDARY COLOR VARIANTS]
  static const Color primaryColor = Color(0xff405888);
  static const Color primaryColorLight = Color(0xff6586c9);
  static const Color blueLite = Color(0xffD9D9D9);
  static const Color blue1 = Color(0xffF5F6FA);
  static const Color secondaryColor = Color(0xff9fabc3);
  static const Color blue2 = Color(0xff212D45);
  static const Color blue3 = Color(0xff74A3B7);
  static const Color blue4 = Color(0xff407488);

  /// [BROWN COLORS]
  static const Color brown = Color(0xff887040);
  static Color brown1(BuildContext context) =>
      AppThemeNotifier.colorScheme(context).primary == AppColors.black
          ? const Color(0xffF8F6F4)
          : Colors.brown.withOpacity(0.3);
  static const Color brown11 = Color(0xffF8F6F4);
  static const Color brown2 = Color(0xffF2EDE3);

  /// [GREEN COLORS]
  static const Color green = Color(0xff40876D);
  static const Color green2 = Color(0xff408743);
  static const Color green1 = Color(0xff36C93C);

  /// [YELLOW COLORS]
  static const Color yellow = Color(0xffFFCD29);
  static const Color yellow2 = Color(0xffF2C94C);
  static const Color yellow3 = Color(0xffF6B93F);

  /// [RED COLORS]
  static const Color red = Color(0xffB81414);
  static const Color red1 = Color(0xff874040);
}