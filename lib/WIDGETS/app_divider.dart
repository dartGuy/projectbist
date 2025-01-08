import 'package:flutter/material.dart';
import 'package:project_bist/THEMES/app_themes.dart';

// ignore: must_be_immutable
class AppDivider extends StatelessWidget {
  AppDivider({
    this.color,
    super.key,
  });
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 0.4,
      color: color ?? AppThemeNotifier.colorScheme(context).onSecondary,
    );
  }
}
