import 'package:flutter/material.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_with_submission_paln_model.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/profile_image.dart';
// ignore_for_file: library_private_types_in_public_api
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/escrow_item_card.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';

import '../../MODELS/message_model/single_chat_model.dart';

class ResearcherViewClientProfileScreen extends StatefulWidget {
  static const String researcherViewClientProfileScreen =
      "researcherViewClientProfileScreen";
  const ResearcherViewClientProfileScreen({super.key, required this.user});

  final User user;

  @override
  State<ResearcherViewClientProfileScreen> createState() =>
      _ResearcherViewClientProfileScreenState();
}

class _ResearcherViewClientProfileScreenState
    extends State<ResearcherViewClientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    EscrowWithSubmissionPlanList escrowList =
        (getIt<AppModel>().escrowWithSubmissionPlanList ?? []).where((e) => e.researcherId == widget.user.id).toList();
    return Scaffold(
      appBar: customAppBar(context,
          title: "Profile", hasElevation: true, hasIcon: true),
      body: SingleChildScrollView(
          child: Column(children: [
        topSection(context,
            name: widget.user.fullName, imagePath: widget.user.avatar
            ),
        const Divider(
          color: AppColors.grey4,
          thickness: 0.4,
        ),
        YMargin(5.sp),
        eachResearcherDetailItem(context,
            iconName: ImageOf.locationIcon,
            title: "Institution",
            subtitle: "Obafemi Awolowo Univeristy, Ile-Ife"),
        eachResearcherDetailItem(
          context,
          iconName: ImageOf.areaOfExperienceIcon,
          title: "Discipline",
          subtitle: "Bio-Science",
        ),
        const Divider(
          color: AppColors.grey4,
          thickness: 0.4,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.sp),
          child: Row(
            children: [TextOf("Escrow", 14.sp, 5)],
          ),
        ),
        YMargin(10.sp),
        if (escrowList.isEmpty)
          Column(
            children: [
              YMargin(0.15.sh),
              ErrorPage(
                  message: "You currently don't have any escrow in common with ${widget.user.fullName}",
                  showButton: false),
            ],
          ),
        if (escrowList.isNotEmpty)
          ...List.generate(escrowList.length, (index) {
            EscrowWithSubmissionPlanModel escrowModel =
                escrowList.reversed.toList()[index];
            return Padding(
              padding: appPadding().copyWith(top: 0),
              child: EscrowItemCard(escrowDetails: escrowModel),
            );
          })
      ])),
    );
  }
}

Widget topSection(
  BuildContext context, {
  String? name,
  String? imagePath,
}) {
  return Padding(
    padding: appPadding().copyWith(bottom: 5),
    child: Column(
      children: [
        buildProfileImage(
            radius: 85.sp,
            fontSize: 20.sp,
            fontWeight: 6,
            imageUrl: imagePath!,
            fullNameTobSplit: name!),
        // Image.asset(
        //   imagePath ?? ImageOf.profilePic3,
        //   height: 85.sp,
        // ),
        YMargin(10.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextOf(name ?? 'John Doe', 20.sp, 6),
            XMargin(4.sp),
            Image.asset(
              ImageOf.verified,
              height: 22,
            )
          ],
        ),
        YMargin(10.sp),
        TextOf("Online", 14.sp, 4, color: AppColors.primaryColor),
        YMargin(16.sp),
        eachTopProfileAction(context,
            iconName: ImageOf.messageNav, name: "Message"),
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

Widget eachTopProfileAction(BuildContext context,
    {required String iconName, required String name}) {
  return InkWell(
    onTap: () => Navigator.pop(context),
    child: Column(
      children: [
        Image.asset(
          iconName,
          height: 25.sp,
        ),
        YMargin(5.sp),
        TextOf(name, 14.sp, 5, color: AppColors.primaryColor)
      ],
    ),
  );
}
