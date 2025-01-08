




import 'package:flutter/material.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@immutable
class IconOf extends StatelessWidget {
  const IconOf(this.icon, {this.size, this.color, super.key});
  final IconData icon;
  final double? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size ?? 20.sp,
      color: color ?? AppThemeNotifier.colorScheme(context).primary,
    );
  }
}
