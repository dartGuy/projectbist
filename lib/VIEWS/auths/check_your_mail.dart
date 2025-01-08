import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_bist/PROVIDERS/auth_provider/auth_provider.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/auths/login_screens.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

class CheckYourMail extends StatefulWidget {
  static const String checkYourMail = "checkYourMail";
  CheckYourMail({required this.email, super.key});
  String? email;

  @override
  State<CheckYourMail> createState() => _CheckYourMailState();
}

class _CheckYourMailState extends State<CheckYourMail> {
  int minute = 0, seconds = 0;
  Stream<String> timer() async* {
    while (minute < 10) {
      await Future.delayed(const Duration(seconds: 1));
      seconds++;

      if (seconds == 60) {
        minute++;
        seconds = 0;
      }
      yield "${zeroPrecedes(minute, minute < 10 ? 1 : 0)}:${zeroPrecedes(seconds, seconds < 10 ? 1 : 0)}";
    }
  }

  String zeroPrecedes(int numb, int zeroCount) {
    return "${'0' * zeroCount}$numb";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: timer(),
        builder: (context, snapshot) {
          return PopScope(
            canPop: false,
            child: Scaffold(
                body: SafeArea(
              child: Stack(alignment: Alignment.bottomCenter, children: [
                SizedBox.expand(
                    child: Padding(
                  padding: appPadding(),
                  child: Column(children: [
                    YMargin(50.sp),
                    SvgPicture.asset(ImageOf.emailSent),
                    YMargin(30.sp),
                    Row(
                      children: [
                        TextOf("Congratulations!", 26.sp, 7),
                      ],
                    ),
                    Row(
                      children: [
                        TextOf("Your account is being created.", 16.sp, 5),
                      ],
                    ),
                    YMargin(15.sp),
                    Row(
                      children: [
                        Expanded(
                          child: TextOf(
                            "One last step however is to verify email with the link sent to your mail box.",
                            16.sp,
                            5,
                            align: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    YMargin(20.sp),
                    Row(
                      children: [
                        TextOf("The link expires in 10 minutes.", 16.sp, 5),
                      ],
                    ),
                    YMargin(35.sp),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextOf("Didn’t get the link?  ", 15.sp, 5),
                      !(snapshot.data ?? "").contains("10:")
                          ? TextOf("Resend link", 15.sp, 6,
                              color: AppColors.grey2)
                          : InkWell(
                              onTap: () {
                                AuthProviders.resendConfirmationMail(context,
                                        email: widget.email!)
                                    .then((value) {
                                  setState(() {
                                    minute = 0;
                                  });
                                });
                              },
                              child: TextOf("Resend link", 15.sp, 6,
                                  color: AppColors.primaryColor))
                    ]),
                    YMargin(20.sp),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextOf("Resend in ", 14.sp, 5),
                      TextOf(
                        " ${!snapshot.hasData ? "00:00" : snapshot.data!}s",
                        14.sp,
                        6,
                      )
                    ])
                  ]),
                )),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextOf("Email already verified?  ", 16.sp, 5),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                LoginScreen.loginScreen, (route) => false);
                          },
                          child: TextOf("Log in", 16.sp, 5,
                              color: AppColors.primaryColor))
                    ]),
                    YMargin(25.sp)
                  ],
                )
              ]),
            )),
          );
        });
  }
}
