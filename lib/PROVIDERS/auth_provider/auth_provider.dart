// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';
import 'package:project_bist/PROVIDERS/jobs_provider/jobs_provider.dart';
import 'package:project_bist/PROVIDERS/profile_provider/profile_provider.dart';
import 'package:project_bist/PROVIDERS/publications_providers/publications_providers.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/PROVIDERS/topic_providers/topic_providers.dart';
import 'package:project_bist/PROVIDERS/transaction_providers/transaction_providers/transaction_providers.dart';
import 'package:project_bist/SERVICES/api_service.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/VIEWS/all_nav_screens/_all_nav_screens/all_nav_screens.dart.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/VIEWS/auths/check_your_mail.dart';
import 'package:project_bist/VIEWS/auths/login_screens.dart';
import 'package:project_bist/VIEWS/auths/otp_screen.dart';
import 'package:project_bist/VIEWS/auths/reset_password_screen.dart';
import 'package:project_bist/main.dart';

final emailAvailabilityProvider =
    StateNotifierProvider<MultipleBaseProvider, AvailabilityStatus>((_) => MultipleBaseProvider());

class AuthProviders {
  static final ApiService _apiService = ApiService();

  static Future userLogin(BuildContext context, WidgetRef ref,
      {required String email, required String password}) async {

    getIt<AppModel>().appCacheBox!.put(AppConst.HAS_SEEN_ONBOARDING_SCREENS, true);
    if (password.length < 6) {
      Alerts.openStatusDialog(context,
          title: "Retry",
          description: "Password must contains a minimum of 6 characters!",
          isSuccess: false);
    } else {
      _apiService.apiRequest(
        context,
        url: Endpoints.LOGIN,
        method: Methods.POST,
        loadingMessage: "Logging you in, please hold on...",
        formData: {
          "emailOrUserName": email,
          "password": password,
          "deviceToken": getIt<AppModel>().appCacheBox!.get(AppConst.USER_DEVICE_TOKEN)
        },
      ).then((value) {
        if (value.status == true) {
          for (var e in [generalPublicationsProvider, topicsProvider, researcherJobsProvider, researchersProfileProvider, profileProvider, userJobsProvider, transactionProvider, escrowsProvider]) {
    ref.invalidate(e);
  }
          if ((getIt<AppModel>().appCacheBox!.get(AppConst.REMEMBER_ME_STATUS) ?? true) == true) {
            getIt<AppModel>().appCacheBox!.put(AppConst.CACHED_EMAIL, email);
            getIt<AppModel>().appCacheBox!.put(AppConst.CACHED_PASSWORD, password);
          } else {
            getIt<AppModel>().appCacheBox!.put(AppConst.CACHED_EMAIL, null);
            getIt<AppModel>().appCacheBox!.put(AppConst.CACHED_PASSWORD, null);
          }
          getIt<AppModel>().appCacheBox!.put(AppConst.TOKEN_KEY, value.data["token"]);
          ref
              .watch(switchUserProvider.notifier)
              .switchUser(switch ((value.data["role"], value.data["clientType"])) {
                ("researcher", "") => UserTypes.researcher,
                ("client", "student") => UserTypes.student,
                ("client", "professional") => UserTypes.professional,
                _ => UserTypes.researcher
              });
          getIt<AppModel>().appCacheBox!.put(
              AppConst.USER_TYPE,
              switch (ref.watch(switchUserProvider)) {
                UserTypes.researcher => "researcher",
                UserTypes.professional => "professional",
                UserTypes.student => "student"
              });
          Navigator.pushNamed(
            context,
            AllNavScreens.allNavScreens,
          );
        } else if (value.status == false && value.message == AppConst.YET_TO_VERIFY_EMAIL) {
          Alerts.openStatusDialog(context,
              isSuccess: false,
              title: "Email verification failed",
              description: "You are yet to verify your email address",
              actionText: "Ok, verify",
              isDismissible: false, actionTextAction: () {
            Navigator.pop(context);
            if (!AppMethods.isEmailValid(email)) {
              Alerts.openStatusDialog(context,
                  isSuccess: false, description: "A valid email address is expected here");
            } else {
              resendConfirmationMail(context, email: email);
            }
          });
        }
      });
    }
  }

  static Future resendConfirmationMail(BuildContext context, {required String email}) async {
    await _apiService.apiRequest(context,
        url: Endpoints.RESEND_CONFIRMATION_MAIL(email: email),
        method: Methods.POST,
        loadingMessage: "Resending verification email...",
        formData: {"email": email}).then((value) {
      if (value.status == true) {
        Alerts.openStatusDialog(context,
            title: "Check your mail",
            description: "A confirmation link has been sent to $email. Confirm to continue.");
      }
    });
  }

  static researcherSignup(
    BuildContext context, {
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String phoneNumber,
    required String faculty,
    required String educationLevel,
    required String experience,
    required String institutionCategory,
    required String institutionOwnership,
    required String institutionName,
    required String division,
    required String sector,
    required String department,
  }) {
    getIt<AppModel>().appCacheBox!.put(AppConst.HAS_SEEN_ONBOARDING_SCREENS, true);
    if (!AppMethods.isEmailValid(email)) {
      Alerts.openStatusDialog(context,
          title: "Retry", description: "This email seem invalid", isSuccess: false);
    } else {
      _apiService.apiRequest(context,
          url: Endpoints.RESEARCHER_SIGNUP,
          method: Methods.POST,
          loadingMessage: "Creating your account...",
          formData: {
            "fullName": fullName,
            "userName": userName,
            "email": email,
            "password": password,
            "phoneNumber": phoneNumber,
            "faculty": faculty,
            "educationLevel": educationLevel,
            "experience": experience,
            "institutionCategory": institutionCategory,
            "institutionOwnership": institutionOwnership,
            "institutionName": institutionName,
            "division": division,
            "sector": sector,
            "department": department,
            "deviceToken": getIt<AppModel>().appCacheBox!.get(AppConst.USER_DEVICE_TOKEN)
          }).then((value) {
        if (value.status == true) {
          assertEmailVerificationClicked(context, email: email);
        }
      });
    }
  }

  static professionalSignup(
    BuildContext context, {
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String phoneNumber,
    required String educationLevel,
    required String division,
    required String sector,
  }) {
    if (!AppMethods.isEmailValid(email)) {
      Alerts.openStatusDialog(context,
          title: "Retry", description: "This email seem invalid", isSuccess: false);
    } else {
      getIt<AppModel>().appCacheBox!.put(AppConst.HAS_SEEN_ONBOARDING_SCREENS, true);
      _apiService.apiRequest(context,
          url: Endpoints.PROFESSIONAL_SIGNUP,
          loadingMessage: "Creating your account...",
          method: Methods.POST,
          formData: {
            "fullName": fullName,
            "userName": userName,
            "email": email,
            "password": password,
            "phoneNumber": phoneNumber,
            "division": division,
            "sector": sector,
            "educationLevel": educationLevel,
            "deviceToken": getIt<AppModel>().appCacheBox!.get(AppConst.USER_DEVICE_TOKEN)
          }).then((value) {
        if (value.status == true) {
          assertEmailVerificationClicked(context, email: email);
        }
      });
    }
  }

  static studentSignup(
    BuildContext context, {
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String phoneNumber,
    required String institutionCategory,
    required String institutionOwnership,
    required String institutionName,
    required String studentType,
    required String department,
    required String faculty,
  }) {
    if (!AppMethods.isEmailValid(email)) {
      Alerts.openStatusDialog(context,
          title: "Retry", description: "This email seem invalid", isSuccess: false);
    } else {
      getIt<AppModel>().appCacheBox!.put(AppConst.HAS_SEEN_ONBOARDING_SCREENS, true);
      _apiService.apiRequest(context,
          url: Endpoints.STUDENT_SIGNUP,
          loadingMessage: "Creating your account...",
          method: Methods.POST,
          formData: {
            "fullName": fullName,
            "userName": userName,
            "email": email,
            "password": password,
            "phoneNumber": phoneNumber,
            "faculty": faculty,
            "institutionCategory": institutionCategory,
            "studentType": studentType,
            "institutionOwnership": institutionOwnership,
            "institutionName": institutionName,
            "department": department,
            "deviceToken": getIt<AppModel>().appCacheBox!.get(AppConst.USER_DEVICE_TOKEN)
          }).then((value) {
        if (value.status == true) {
          assertEmailVerificationClicked(context, email: email);
        }
      });
    }
  }

  static sendPasswordResetToken(BuildContext context,
      {required String email, String? actionText, required bool isDismissible}) {
    if (!AppMethods.isEmailValid(email)) {
      Alerts.openStatusDialog(context, description: "This email seem invalid", isSuccess: false);
    } else {
      _apiService.apiRequest(context,
          url: Endpoints.SEND_PASSWORD_RESET_TOKEN,
          method: Methods.POST,
          loadingMessage: "Handling forgot password request...",
          formData: {"email": email}).then((value) {
        if (value.status == true) {
          Alerts.openStatusDialog(context,
              title: "Check your mail",
              description: value.message,
              isDismissible: false,
              actionText: actionText, actionTextAction: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, OTPScreen.otpScreen, arguments: email);
          });
        }
      });
    }
  }

  static verifyPasswordResetToken(BuildContext context, {required String tokenCode}) {
    _apiService
        .apiRequest(context,
            url: Endpoints.VERIFY_PASSWORD_RESET_TOKEN,
            formData: {"token": tokenCode},
            loadingMessage: "Verifying OTP...",
            method: Methods.POST)
        .then((value) {
      if (value.status == true) {
        getIt<AppModel>().appCacheBox!.put(AppConst.TOKEN_KEY, value.data["token"]);
        if (value.data.containsKey("token")) {
          String token =
              getIt<AppModel>().appCacheBox!.get(AppConst.TOKEN_KEY, defaultValue: "token") ??
                  "token";
          print("this contains contains token and token is $token");
        } else {
          print("this doesn't contain token");
        }
        Alerts.openStatusDialog(context, description: value.message, isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pushNamed(context, ResetPasswordScreen.resetPasswordScreen);
        });
      }
    });
  }

  static resetPassword(BuildContext context,
      {required String password, required String confirmPassword}) {
    if (password != confirmPassword) {
      Alerts.openStatusDialog(
        context,
        isSuccess: false,
        description: "Password do not match!",
      );
    } else {
      _apiService.apiRequest(context,
          url: Endpoints.COMPLETE_ACCOUNT_RECOVERY,
          method: Methods.PATCH,
          loadingMessage: "Resetting password...",
          formData: {"password": password}).then((value) {
        if (value.status == true) {
          Alerts.openStatusDialog(context, description: value.message, isDismissible: false);
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.loginScreen, (_) => false);
          });
        }
      });
    }
  }

  static changePassword(BuildContext context,
      {required String newPassword, required String oldPassword}) {
    _apiService.apiRequest(context,
        url: Endpoints.CHANGE_PASSWORD(oldPassword, newPassword),
        method: Methods.PATCH,
        loadingMessage: "Processing password change...",
        formData: {"password": newPassword, "currentPassword": oldPassword}).then((value) {
      if (value.status == true) {
        getIt<AppModel>().appCacheBox!.put(AppConst.CACHED_PASSWORD, null);
        Alerts.openStatusDialog(context, description: value.message, isDismissible: false);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, LoginScreen.loginScreen, (route) => false);
        });
      }
    });
  }

  static logout(BuildContext context, WidgetRef ref) {
    Alerts.optionalDialog(context,
        text: "Are you sure you want to logout?", right: "No", left: "Yes", onTapLeft: () {
      Navigator.pop(context);

      _apiService
          .apiRequest(context,
              url: Endpoints.LOGOUT,
              method: Methods.POST,
              formData: {},
              headerKeys: [Keys.AUTHORIZATION],
              loadingMessage: "Logging you out...")
          .then((value) {
        if (value.status == true) {
          getIt<AppModel>().appCacheBox!.delete(AppConst.TOKEN_KEY);
          AppMethods.invalidateProviders(ref: ref);

          Navigator.pushNamedAndRemoveUntil(context, LoginScreen.loginScreen, (_) => false);
        }
      });
    });
  }
}

assertEmailVerificationClicked(BuildContext context, {required String email}) {
  Navigator.pushNamedAndRemoveUntil(
      context, CheckYourMail.checkYourMail, arguments: email, (route) => false);
}

class MultipleBaseProvider extends StateNotifier<AvailabilityStatus> {
  final ApiService _apiService = ApiService();

  MultipleBaseProvider()
      : super(AvailabilityStatus(responseState: ResponseAvailabilityState.NEUTRAL));

  Future request(
    BuildContext context,
    WidgetRef ref, {
    required String endpoint,
  }) async {
    Future.delayed(const Duration(milliseconds: 500), () {
      state.responseState = ResponseAvailabilityState.LOADING;
    });
    _apiService
        .apiRequest(
      context,
      url: endpoint,
      formData: {},
      method: Methods.GET,
      showLoading: false,
    )
        .then((value) {
      if (value.status == true) {
        state = AvailabilityStatus(responseState: ResponseAvailabilityState.DATA, data: value.data);
      } else {
        state = AvailabilityStatus(
            responseState: ResponseAvailabilityState.ERROR, message: value.message);
      }
    });
  }

  void switchState(ResponseAvailabilityState newState) {
    state.responseState = newState;
  }
// Future<ApiResponse> request(
// BuildContext context,
// WidgetRef ref, {
// required String email,
// required String username,
// }) async {
//   ApiResponse? requestData;
//   await _apiService
//       .apiRequest(
//     context,
// url: Endpoints.EMAIL_USERNAME_AVAILABILITY(
//     ref.watch(switchUserProvider) == UserTypes.researcher
//         ? "researchers"
//         : "client",
//     email: email,
//     username: username),
// formData: {},
// method: Methods.GET,
// showLoading: false,
//   )
//       .then((value) {
//     requestData = value;
//   });
//   return requestData!;
// }
}

enum ResponseAvailabilityState { LOADING, DATA, ERROR, NEUTRAL }

class AvailabilityStatus {
  String? message;
  ResponseAvailabilityState? responseState;
  dynamic data;

  AvailabilityStatus({this.message, this.responseState, this.data});
}
