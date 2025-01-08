// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/UTILS/profile_image.dart';
import 'package:project_bist/UTILS/methods.dart';

class ClientsJobProfile extends ConsumerStatefulWidget {
  static const String clientsJobProfile = "clientsJobProfile";
  UserProfile userProfile = UserProfile();
  ClientsJobProfile({required this.userProfile, super.key});
  @override
  _ClientsJobProfileState createState() => _ClientsJobProfileState();
}

class _ClientsJobProfileState extends ConsumerState<ClientsJobProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context,
            title:
                "${AppMethods.toTitleCase(widget.userProfile.clientType!)}'s Profile",
            hasElevation: true,
            hasIcon: true),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              topSection(context, userProfile: widget.userProfile),
              eachResearcherDetailItem(context,
                  iconName: ImageOf.locationIcon,
                  title: "Institution",
                  subtitle: (widget.userProfile.institutionName ?? "").isEmpty
                      ? "-institution name-"
                      : widget.userProfile.institutionName!),
              eachResearcherDetailItem(
                context,
                iconName: ImageOf.areaOfExperienceIcon,
                title: !isProfessional(
                        AppMethods.toTitleCase(widget.userProfile.clientType!))
                    ? "Faculty"
                    : "Sector/parastatal of Expertise",
                subtitle: isProfessional(
                        AppMethods.toTitleCase(widget.userProfile.clientType!))
                    ? widget.userProfile.sector ?? "-sector-"
                    : widget.userProfile.faculty ?? "-faculty-",
                others: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YMargin(10.sp),
                      TextOf(
                          isProfessional(AppMethods.toTitleCase(
                                  widget.userProfile.clientType!))
                              ? "Division"
                              : "Department",
                          16.sp,
                          4,
                          color: AppThemeNotifier.colorScheme(context)
                              .onSecondary),
                      TextOf(
                        isProfessional(AppMethods.toTitleCase(
                                widget.userProfile.clientType!))
                            ? widget.userProfile.division??"-division-"
                            : widget.userProfile.department??"-department-",
                        18,
                        6,
                        align: TextAlign.left,
                      ),
                    ]),
              ),
              AppDivider()
            ])));
  }
}

Widget topSection(BuildContext context, {required UserProfile userProfile}) {
  return Padding(
    padding: appPadding().copyWith(bottom: 0),
    child: Column(
      children: [
        buildProfileImage(
            radius: 100.sp,
            fontWeight: 6,
            fontSize: 25.sp,
            imageUrl: userProfile.avatar!,
            fullNameTobSplit: userProfile.fullName!),
        // Image.asset(ImageOf.profilePic3, height: 100.sp),
        YMargin(20.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextOf(userProfile.fullName!, 20.sp, 6),
          ],
        ),
        YMargin(10.sp),
      ],
    ),
  );
}

Widget eachResearcherDetailItem(BuildContext context,
    {required String iconName,
    required String title,
    required String subtitle,
    Widget? others}) {
  return Padding(
    padding: appPadding().copyWith(top: 0, bottom: 16.sp),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageIcon(
          AssetImage(iconName),
          size: 14.sp,
          color: AppThemeNotifier.colorScheme(context).primary,
        ),
        //Image.asset(iconName, height: 14.sp),
        XMargin(14.sp),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextOf(title, 16, 4,
                color: AppThemeNotifier.colorScheme(context).onSecondary),
            YMargin(8.sp),
            TextOf(
              subtitle,
              18,
              6,
              align: TextAlign.left,
            ),
            others ?? const SizedBox.shrink()
          ]),
        ),
      ],
    ),
  );
}

bool isProfessional(String clientType) =>
    AppMethods.toTitleCase(clientType) == "Professional";
