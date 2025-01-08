import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/all_nav_screens/_all_nav_screens/all_nav_screens.dart.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/core.dart';
import 'package:ripple_wave/ripple_wave.dart';

class Alerts {
  static openDialog(BuildContext context,
      {required String title, required String subtitle}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 15.sp),
              backgroundColor:
                  AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.sp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(ImageOf.markDone),
                      YMargin(24.sp),
                      TextOf(title, 16.sp, 5),
                      YMargin(4.sp),
                      TextOf(subtitle, 14.sp, 4),
                      YMargin(24.sp),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                AllNavScreens.allNavScreens, (route) => false);
                          },
                          child: TextOf(
                            "RETURN TO HOME",
                            16.sp,
                            6,
                            color: AppColors.primaryColor,
                          ))
                    ],
                  )),
            ));
  }

  static optionalDialog(BuildContext context,
      {required String text,
      String? left,
      String? right,
      String? title,
      Color? leftColor,
      rightColor,
      VoidCallback? onTapRight,
      VoidCallback? onTapLeft}) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 15.sp),
              backgroundColor:
                  AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
              elevation: 0,
              surfaceTintColor: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 20.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    title == null
                        ? const SizedBox.shrink()
                        : Column(children: [
                            Row(
                              children: [
                                Expanded(
                                    child: TextOf(
                                  title,
                                  24.sp,
                                  6,
                                  align: TextAlign.left,
                                ))
                              ],
                            ),
                            YMargin(24.sp),
                          ]),
                    Row(
                      children: [
                        Expanded(
                            child: TextOf(
                          text,
                          16.sp,
                          5,
                          align: TextAlign.left,
                        ))
                      ],
                    ),
                    YMargin(24.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if (onTapLeft == null) {
                              Navigator.pop(context);
                            } else {
                              onTapLeft();
                            }
                          },
                          child: TextOf(
                            left ?? "Delete",
                            16,
                            5,
                            color: leftColor ?? AppColors.red,
                            align: TextAlign.left,
                          ),
                        ),
                        XMargin(30.sp),
                        InkWell(
                          onTap: () {
                            onTapRight ?? Navigator.pop(context);
                          },
                          child: TextOf(
                            right ?? "Cancel",
                            16,
                            5,
                            color: rightColor ?? AppColors.primaryColor,
                            align: TextAlign.left,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  static openStatusDialog(BuildContext context,
      {String? title,
      Widget? subtitle,
      String? description,
      bool isSuccess = true,
      String? actionText,
      String? canceleText,
      VoidCallback? actionTextAction,
      bool isDismissible = true,
      bool isFull = true,
      bool hasCancel = true}) {
    if (AppConst.DIALOG_ACTIVE == true) return;
    AppConst.DIALOG_ACTIVE == true;
    showDialog(
        context: context,
        barrierDismissible: isDismissible,
        builder: (context) => Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 15.sp),
              backgroundColor:
                  AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
              elevation: 0,
              surfaceTintColor:
                  AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: Padding(
                padding: EdgeInsets.all(15.sp)
                    .add(EdgeInsets.symmetric(horizontal: 2.sp)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      isFull == false
                          ? const SizedBox.shrink()
                          : IconOf(
                              switch (isSuccess) {
                                true => Icons.check_circle,
                                false => Icons.cancel
                              },
                              color: switch (isSuccess) {
                                true => AppColors.green,
                                false => AppColors.red
                              },
                              size: 60.sp,
                            ),
                      isFull == false
                          ? const SizedBox.shrink()
                          : XMargin(10.sp),
                      Expanded(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            isFull == false
                                ? const SizedBox.shrink()
                                : TextOf(
                                    (isSuccess && title == null)
                                        ? "Request Successful"
                                        : (!isSuccess && title == null)
                                            ? "Request Failed"
                                            : title!,
                                    16.sp,
                                    6),
                            isFull == false
                                ? const SizedBox.shrink()
                                : YMargin(8.sp),
                            switch (description == null) {
                              true => subtitle!,
                              false => TextOf(description!, 14.sp, 4,
                                  align: TextAlign.left,
                                  color: AppThemeNotifier.colorScheme(context)
                                      .primary)
                            }
                          ]))
                    ]),
                    actionText != null
                        ? Column(
                            children: [
                              YMargin(8.sp),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    hasCancel == true
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: TextOf(
                                              canceleText ?? "Cancel",
                                              16,
                                              5,
                                              color: AppColors.red,
                                              align: TextAlign.left,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    XMargin(30.sp),
                                    InkWell(
                                      onTap: () {
                                        actionTextAction == null
                                            ? Navigator.pop(context)
                                            : actionTextAction();
                                      },
                                      child: TextOf(
                                        actionText,
                                        16,
                                        5,
                                        color: AppColors.primaryColor,
                                        align: TextAlign.left,
                                      ),
                                    ),
                                  ]),
                            ],
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            )).then((value) {
      AppConst.DIALOG_ACTIVE = false;
    });
  }

  static infoDialog(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 15.sp),
              backgroundColor:
                  AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
              elevation: 0,
              surfaceTintColor: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(horizontal: 15.sp, vertical: 18.sp)
                        .copyWith(bottom: 24.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextOf(
                          title,
                          24.sp,
                          6,
                          align: TextAlign.left,
                        ),
                        InkWell(
                            child: const IconOf(Icons.close),
                            onTap: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                    YMargin(24.sp),
                    Row(children: [
                      Expanded(
                        child: TextOf(
                          subtitle,
                          16.sp,
                          4,
                          align: TextAlign.left,
                        ),
                      )
                    ])
                  ],
                ),
              ),
            ));
  }

  static showLoading(BuildContext context, {String? loadingMessage}) {
    BotToast.cleanAll();
    BotToast.showWidget(
        toastBuilder: (_) => SizedBox.expand(
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 110.sp,
                        child: RippleWave(
                            color: AppColors.primaryColor,
                            child: Image.asset(
                              ImageOf.logoRound,
                              height: 50.sp,
                            )),
                      ),
                      // YMargin(10.sp),
                      loadingMessage == null
                          ? const SizedBox.shrink()
                          : TextOf(
                              loadingMessage,
                              13.sp,
                              5,
                              color: AppColors.white,
                            )
                    ],
                  ),
                ),
              ),
            ));
  }
}
