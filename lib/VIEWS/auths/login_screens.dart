import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/PROVIDERS/auth_provider/auth_provider.dart';
import 'package:project_bist/PROVIDERS/profile_provider/profile_provider.dart';
import 'package:project_bist/PROVIDERS/jobs_provider/jobs_provider.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/VIEWS/auths/forgot_password.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

class Counter extends Notifier<int> {
  @override
  int build() {
    // Inside "build", we return the initial state of the counter.
    return 0;
  }

  void increment() {
    state++;
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  static const String loginScreen = "loginScreen";

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController usernameAndEmailController, passwordController;

  @override
  void initState() {
    setState(() {
      usernameAndEmailController = TextEditingController(
          text: getIt<AppModel>().appCacheBox!.get(AppConst.CACHED_EMAIL));
      passwordController = TextEditingController(
          text: getIt<AppModel>().appCacheBox!.get(AppConst.CACHED_PASSWORD));
    });
    // passwordController.clear();
    // usernameAndEmailController.clear();
    super.initState();
  }

  @override
  void dispose() {
    usernameAndEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool rememberMe =
      getIt<AppModel>().appCacheBox!.get(AppConst.REMEMBER_ME_STATUS) ?? false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    return Scaffold(
      appBar: customAppBar(context),
      body: Padding(
        padding: appPadding().add(EdgeInsets.only(bottom: 25.sp)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox.expand(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    YMargin(15.sp),
                    Row(
                      children: [
                        TextOf("Welcome Back!", 26.sp, 6),
                      ],
                    ),
                    YMargin(4.sp),
                    Row(
                      children: [
                        Expanded(
                          child: TextOf("Login to continue", 16.sp, 5,
                              align: TextAlign.left,
                              color: AppThemeNotifier.colorScheme(context)
                                  .onSecondary),
                        ),
                      ],
                    ),
                    YMargin(24.sp),
                    InputField(
                        hintText: "Username or Email",
                        inputType: TextInputType.emailAddress,
                        fieldController: usernameAndEmailController),
                    YMargin(16.sp),
                    PasswordField(
                        hintText: "Password",
                        isPassword: true,
                        fieldController: passwordController),
                    YMargin(16.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              rememberMe = !rememberMe;
                            });
                            ref.invalidate(userJobsProvider);
                            getIt<AppModel>()
                                .appCacheBox!
                                .put(AppConst.REMEMBER_ME_STATUS, rememberMe);
                          },
                          child: Row(children: [
                            IconOf(
                              (getIt<AppModel>().appCacheBox!.get(
                                              AppConst.REMEMBER_ME_STATUS) ??
                                          true) ==
                                      false
                                  ? Icons.check_box_outline_blank
                                  : Icons.check_box_outlined,
                              color: AppThemeNotifier.colorScheme(context)
                                  .onSecondary,
                            ),
                            XMargin(5.sp),
                            TextOf("Remember me", 16.sp, 4,
                                color: AppThemeNotifier.colorScheme(context)
                                    .onSecondary),
                          ]),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context,
                                ForgotPasswordScreen.forgotPasswordScreen);
                          },
                          child: TextOf("Forgot password?", 16.sp, 4,
                              color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                    YMargin(0.2.sh)
                  ],
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(builder: (context, ref, _) {
                  return Button(
                      text: "Log in",
                      buttonType: usernameAndEmailController.text.isNotEmpty &&
                              passwordController.text.length > 5
                          ? ButtonType.blueBg
                          : ButtonType.disabled,
                      onPressed: () {
                        ref.invalidate(profileProvider);
                        usernameAndEmailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty
                            ? AuthProviders.userLogin(context, ref,
                                    email:
                                        usernameAndEmailController.text.trim(),
                                    password: passwordController.text)
                                .then((value) =>
                                    AppMethods.invalidateProviders(ref: ref))
                            : () {};
                      });
                }),
                YMargin(16.sp),
                RichText(
                    text: TextSpan(
                        text: "Don’t have an account? ",
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: AppThemeNotifier.colorScheme(context)
                                .onSecondary,
                            fontFamily: Fonts.nunito),
                        children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context,
                                BeginUserDetermination.beginUserDetermination);
                          },
                        text: 'Create an Account',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            color: AppColors.primaryColor,
                            fontFamily: Fonts.nunito),
                      )
                    ]))
              ],
            )
          ],
        ),
      ),
    );
  }
}
