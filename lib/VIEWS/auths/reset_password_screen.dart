import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:password_policy/password_policy.dart';
import 'package:project_bist/PROVIDERS/auth_provider/auth_provider.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String resetPasswordScreen = "resetPasswordScreen";
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController createNewPasswordController,
      confirmNewPasswordController;
  @override
  void initState() {
    setState(() {
      createNewPasswordController = TextEditingController();
      confirmNewPasswordController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    createNewPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  bool rememberMe = false;

  late PasswordCheck passwordCheck;
  PasswordPolicy passwordPolicy = PasswordPolicy(
    minimumScore: 1,
    validationRules: [
      UpperCaseRule(),
      LowerCaseRule(),
      DigitRule(),
      NoSpaceRule(),
      SpecialCharacterRule(),
    ],
  );
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
                      TextOf("Reset Password", 26.sp, 6),
                    ],
                  ),
                  YMargin(4.sp),
                  Row(
                    children: [
                      Expanded(
                        child: TextOf(
                            "Set a new password to keep your account safe and secured.",
                            16.sp,
                            5,
                            align: TextAlign.left,
                            color: AppThemeNotifier.colorScheme(context)
                                .onSecondary),
                      ),
                    ],
                  ),
                  YMargin(24.sp),
                  PasswordField(
                      hintText: "Create new password",
                      isPassword: true,
                      fieldController: createNewPasswordController),
                  YMargin(16.sp),
                  PasswordField(
                      hintText: "Confirm new password",
                      isPassword: true,
                      suffixIcon: const SizedBox.shrink(),
                      fieldController: confirmNewPasswordController),
                  YMargin(16.sp),
                  ...List.generate(6, (index) {
                    bool thisConditionFilled = switch (index) {
                      0 => createNewPasswordController.text.length > 5,
                      _ => passwordPolicy.validationRules[index - 1]
                              .computeRuleScore(
                                  createNewPasswordController.text) ==
                          1.0
                    };
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          IconOf(
                            thisConditionFilled == true
                                ? Icons.check_circle_outline_rounded
                                : Icons.radio_button_off,
                            color: thisConditionFilled ? AppColors.green : null,
                          ),
                          XMargin(10.sp),
                          TextOf(
                              switch (index) {
                                0 => "Minimum of 6 characters",
                                1 => "Must contain upper case letter",
                                2 => "Must contain lower case letter",
                                3 => "Must contain digit(s)",
                                4 => "No space(s) between",
                                5 => "Must contain special character",
                                _ => ""
                              },
                              14.sp,
                              thisConditionFilled ? 6 : 4)
                        ]),
                        YMargin(10.sp)
                      ],
                    );
                  }),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Button(
                    //
                    text: "Reset password",
                    buttonType: createNewPasswordController.text ==
                            confirmNewPasswordController.text
                        ? ButtonType.blueBg
                        : ButtonType.disabled,
                    onPressed: () {
                      AuthProviders.resetPassword(context,
                          confirmPassword: confirmNewPasswordController.text,
                          password: createNewPasswordController.text);
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
