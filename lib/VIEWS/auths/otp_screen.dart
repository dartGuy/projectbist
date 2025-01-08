// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/auth_provider/auth_provider.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/otp_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class OTPScreen extends StatefulWidget {
  static const String otpScreen = "otpScreen";
  OTPScreen({super.key, this.emailAddress});
  String? emailAddress;
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late TextEditingController otpController;
  @override
  void initState() {
    setState(() {
      otpController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    return Scaffold(
      appBar: customAppBar(context, hasIcon: true),
      body: Padding(
        padding: appPadding().add(EdgeInsets.only(bottom: 25.sp)),
        child: Column(
          children: [
            YMargin(15.sp),
            Row(
              children: [
                TextOf("Enter OTP", 26.sp, 6),
              ],
            ),
            YMargin(4.sp),
            Row(
              children: [
                Expanded(
                  child: TextOf("Input the OTP sent to your email", 16.sp, 5,
                      align: TextAlign.left,
                      color: AppThemeNotifier.colorScheme(context).onSecondary),
                ),
              ],
            ),
            YMargin(24.sp),
            SizedBox(
              width: 0.6.sw,
              child: OtpField(
                  pinController: otpController,
                  onChanged: (value) {
                    if (otpController.text.length == 4) {
                      Future.delayed(const Duration(seconds: 1), () {
                        AuthProviders.verifyPasswordResetToken(context,
                            tokenCode: otpController.text);
                      });
                    }
                  }),
            ),
            YMargin(30.sp),
            RichText(
                text: TextSpan(
                    text: "Didn’t receive code? ",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color:
                            AppThemeNotifier.colorScheme(context).onSecondary,
                        fontFamily: Fonts.nunito),
                    children: [
                  TextSpan(
                    text: 'Resend OTP',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (widget.emailAddress == null) {
                          Navigator.pop(context);
                        } else {
                          AuthProviders.sendPasswordResetToken(context,
                              isDismissible: true, email: widget.emailAddress!);
                        }
                      },
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        color: AppColors.primaryColor,
                        fontFamily: Fonts.nunito),
                  )
                ]))
          ],
        ),
      ),
    );
  }
}
