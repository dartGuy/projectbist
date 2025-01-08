import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/auth_provider/auth_provider.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

class ChangePassword extends StatefulWidget {
  static const String changePassword = "changePassword";
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController oldPasswordController,
      newPasswordController,
      confirmNewPasswordController;

  @override
  void initState() {
    setState(() {
      oldPasswordController = TextEditingController();
      newPasswordController = TextEditingController();
      confirmNewPasswordController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    return Scaffold(
      appBar: customAppBar(context,
          title: "Change Password", hasIcon: true, hasElevation: true),
      body: Padding(
        padding: appPadding().copyWith(bottom: 20.sp),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox.expand(
                child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  TextOf("Fill these requirements to change your password.",
                      16.sp, 4),
                  YMargin(24.sp),
                  PasswordField(
                      fieldTitle: "Old Password",
                      hintText: "Enter old password",
                      isPassword: true,
                      fieldController: oldPasswordController),
                  YMargin(16.sp),
                  PasswordField(
                      fieldTitle: "New Password",
                      validator: (value) {
                        if (value != confirmNewPasswordController.text) {
                          return "";
                        } else if (value!.length < 6) {
                          return "Passwords must contain a minimum of 6 characters";
                        }
                        return null;
                      },
                      isPassword: true,
                      hintText: "Enter new password",
                      fieldController: newPasswordController),
                  YMargin(16.sp),
                  PasswordField(
                      isPassword: true,
                      fieldTitle: "Confirm new password",
                      hintText: "Confirm new password",
                      validator: (value) {
                        if (value != newPasswordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      fieldController: confirmNewPasswordController),
                  YMargin(0.3.sh)
                ],
              )),
            )),
            Button(
              text: "Change Password",
              buttonType: oldPasswordController.text.isNotEmpty &&
                      (newPasswordController.text ==
                          confirmNewPasswordController.text)
                  ? ButtonType.blueBg
                  : ButtonType.disabled,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  AuthProviders.changePassword(context,
                      oldPassword: oldPasswordController.text,
                      newPassword: newPasswordController.text);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
