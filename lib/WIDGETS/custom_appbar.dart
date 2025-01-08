import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/core.dart';

AppBar customAppBar(BuildContext context,
    {String? title,
    Widget? leading,
    double? scale,
    TabBar? tabBar,
    List<Widget>? actions,
    VoidCallback? onTap,
    bool hasIcon = false,
    hasElevation = false}) {
  return AppBar(
    backgroundColor:
        AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
    surfaceTintColor:
        AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
    foregroundColor:
        AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
    shadowColor: AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
    title: TextOf(title ?? "", 20.sp, 7),
    centerTitle: true,
    actions: actions,
    bottom: tabBar,
    leading: Transform.scale(
      scale: scale ?? 0.45.sp,
      child: (leading != null && hasIcon == true)
          ? leading
          : hasIcon == false
              ? const SizedBox.shrink()
              : InkWell(
                  onTap: onTap ?? () => Navigator.pop(context),
                  child: ImageIcon(
                    AssetImage(
                      ImageOf.backIcon,
                    ),
                    color: AppThemeNotifier.colorScheme(context).primary,
                  ),
                ),
    ),
    elevation: hasElevation == true ? 3 : 0,
  );
}
