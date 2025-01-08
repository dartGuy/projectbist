// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({
    super.key,
    required this.message,
  });
  String message = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.sp),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextOf(message, 15.sp, 5),
          YMargin(10.sp),
          const LinearProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ]),
      ),
    );
  }
}
