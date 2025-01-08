// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/profile_image.dart';
import 'package:project_bist/VIEWS/researchers_profile_screen/researchers_profile_screen.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/small_button.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class ProfileItem extends StatelessWidget {
  ProfileItem({super.key, this.userProfile, this.padding});
  UserProfile? userProfile;
  EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(
              context, ResearchersProfileScreen.researchersProfileScreen,
              arguments: userProfile!);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          shadowColor: AppColors.grey1.withOpacity(0.5),
          elevation: 2,
          child: Container(
            width: 0.5.sw,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 8.sp),
            decoration: BoxDecoration(
                color: AppColors.brown1(context),
                borderRadius: BorderRadius.circular(10.r)),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildProfileImage(
                          imageUrl: userProfile!.avatar ?? "",
                          radius: 50.sp,
                          fontSize: 20.sp,
                          fontWeight: 6,
                          fullNameTobSplit: userProfile!.fullName!),
                      XMargin(7.sp),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextOf(
                              userProfile!.fullName!,
                              12.sp,
                              7,
                              align: TextAlign.left,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextOf(
                                    "${userProfile!.sector!}  ●  ${userProfile!.institutionName!}",
                                    10.sp,
                                    4,
                                    align: TextAlign.left,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  YMargin(10.sp),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          IconOf(
                            Icons.star_rounded,
                            size: 16.sp,
                            color: AppColors.yellow2,
                          ),
                          XMargin(7.sp),
                          TextOf(
                            "4.5",
                            12.sp,
                            7,
                            color:
                                AppThemeNotifier.colorScheme(context).primary,
                          )
                        ]),
                        const SmallButton(
                          text: "View Profile",
                        ),
                      ])
                ],
              ),
            ),
          ),
        ));
  }
}
