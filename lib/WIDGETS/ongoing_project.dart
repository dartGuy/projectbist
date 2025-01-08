// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_model.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class OngoingProject extends StatelessWidget {
  OngoingProject({
    this.escrowModel,
    super.key,
  });
  EscrowModel? escrowModel;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10.r)),
        width: double.infinity,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextOf("My Thesis", 16, 6, color: AppColors.white),
            Tooltip(
              message: 'Delete job',
              preferBelow: false,
              waitDuration: const Duration(seconds: 4),
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 15.sp),
              textStyle: TextStyle(
                  fontSize: 16.sp,
                  color: AppThemeNotifier.colorScheme(context).onPrimary,
                  fontWeight: FontWeight.w400),
              decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 2.r,
                        color: isDarkTheme(context)
                            ? AppColors.grey3
                            : AppColors.grey1,
                        spreadRadius: 0.1.sp)
                  ],
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppThemeNotifier.colorScheme(context).primary),
              child: const IconOf(
                Icons.more_vert_outlined,
                color: AppColors.white,
              ),
            )
          ]),
          YMargin(16.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextOf("Student thesis", 12, 4, color: AppColors.white),
              TextOf("Ongoing", 12, 4, color: AppColors.yellow3),
            ],
          )
        ]));
  }
}
