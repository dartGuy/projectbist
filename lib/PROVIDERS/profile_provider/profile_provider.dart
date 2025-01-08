import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/PROVIDERS/_base_provider/base_provider.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/SERVICES/api_service.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/VIEWS/auths/login_screens.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/WIDGETS/profile_item.dart';
import "package:project_bist/main.dart";

final profileProvider =
    StateNotifierProvider<BaseProvider<UserProfile>, ResponseStatus>(
        (ref) => BaseProvider<UserProfile>());
final researchersProfileProvider =
    StateNotifierProvider<BaseProvider<ProfileItem>, ResponseStatus>(
        (ref) => BaseProvider<ProfileItem>());

class ProfileProvider {
  static editProfile({
    required WidgetRef ref,
    required BuildContext context,
    required UserTypes userType,
    required UserProfile userProfile,
  }) {
    ref
        .watch(profileProvider.notifier)
        .makeRequest(
          context: context,
          method: Methods.PATCH,
          loadingPostRequestMessage: "Updating your profile...",
          formData: switch (userType) {
            UserTypes.researcher => userProfile.researcherToJson(userProfile),
            UserTypes.professional =>
              userProfile.professionalToJson(userProfile),
            UserTypes.student => userProfile.studentToJson(userProfile),
          },
          url: switch (userType) {
            UserTypes.researcher => Endpoints.EDIT_PROFILE_RESEARCHER,
            UserTypes.professional => Endpoints.EDIT_PROFILE_PROFESSIONAL,
            UserTypes.student => Endpoints.EDIT_PROFILE_STUDENT
          },
        )
        .then((value) {
      if (value.status == true) {
        ref.invalidate(profileProvider);
        Future.delayed(const Duration(milliseconds: 1500), () {
          List.generate(2, (index) => Navigator.pop(context));
        });
      }
    });
  }

  static final ApiService _apiServiceSecond = ApiService();

  static deleteProfile(BuildContext context) {
    Alerts.optionalDialog(context,
        text: "Are you sure you want to delete your account?",
        right: "No",
        left: "Yes, delete", onTapLeft: () {
      Navigator.pop(context);
      _apiServiceSecond
          .apiRequest(context,
              url: Endpoints.DELETE_ACCOUNT,
              method: Methods.DELETE,
              loadingMessage: "Deleting your account...")
          .then((value) {
        if (value.status == true) {
          getIt<AppModel>().appCacheBox!.put(AppConst.CACHED_EMAIL, null);
          getIt<AppModel>().appCacheBox!.put(AppConst.CACHED_PASSWORD, null);
          Navigator.pushNamedAndRemoveUntil(
              context, LoginScreen.loginScreen, (_) => false);
        }
      });
    });
  }
}
