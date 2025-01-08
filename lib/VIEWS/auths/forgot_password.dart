import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/auth_provider/auth_provider.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String forgotPasswordScreen = "forgotPasswordScreen";
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController usernameAndEmailController;
  @override
  void initState() {
    setState(() {
      usernameAndEmailController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    usernameAndEmailController.dispose();
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
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: 1.sh,
              child: Column(
                children: [
                  YMargin(15.sp),
                  Row(
                    children: [
                      TextOf("Forgot Password", 26.sp, 6),
                    ],
                  ),
                  YMargin(4.sp),
                  Row(
                    children: [
                      Expanded(
                        child: TextOf(
                            "Input your email you used to register on the app. You will receive an OTP that will be used to reset your password.",
                            16.sp,
                            5,
                            align: TextAlign.left,
                            color: AppThemeNotifier.colorScheme(context)
                                .onSecondary),
                      ),
                    ],
                  ),
                  YMargin(24.sp),
                  InputField(
                      hintText: "Email",
                      inputType: TextInputType.emailAddress,
                      fieldController: usernameAndEmailController),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Button(
                    text: "Send OTP",
                    buttonType: usernameAndEmailController.text.isNotEmpty
                        ? ButtonType.blueBg
                        : ButtonType.disabled,
                    onPressed: () {
                      AuthProviders.sendPasswordResetToken(context,
                          email: usernameAndEmailController.text,
                          isDismissible: false,
                          actionText: "Continue");

                      // Navigator.pushNamed(context, OTPScreen.otpScreen);
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
