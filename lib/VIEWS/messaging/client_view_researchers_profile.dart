import 'package:flutter/material.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_model.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_with_submission_paln_model.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/profile_image.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/escrow_item_card.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';

import '../../WIDGETS/error_page.dart';

class ClientViewResearchersProfileScreenArgument {
  final UserProfile userProfile;
  final EscrowModel escrowModel;
  ClientViewResearchersProfileScreenArgument(
      {required this.userProfile, required this.escrowModel});
}

class ClientViewResearchersProfileScreen extends StatefulWidget {
  final ClientViewResearchersProfileScreenArgument
      clientViewResearchersProfileScreenArgument;
  static const String clientViewResearchersProfileScreen =
      "clientViewResearchersProfileScreen";
  const ClientViewResearchersProfileScreen(
      {super.key, required this.clientViewResearchersProfileScreenArgument});

  @override
  State<ClientViewResearchersProfileScreen> createState() =>
      _ClientViewResearchersProfileScreenState();
}

class _ClientViewResearchersProfileScreenState
    extends State<ClientViewResearchersProfileScreen> {
  @override
  Widget build(BuildContext context) {
    UserProfile userProfile =
        widget.clientViewResearchersProfileScreenArgument.userProfile;
        EscrowWithSubmissionPlanList escrowList =
        (getIt<AppModel>().escrowWithSubmissionPlanList ?? []).where((e) => e.researcherId == userProfile.id!).toList();
    return Scaffold(
      appBar: customAppBar(context,
          title: "Researcher’s Profile", hasElevation: true, hasIcon: true),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
            child: Column(children: [
          topSection(context, userProfile: userProfile),
          const Divider(
            color: AppColors.grey4,
            thickness: 0.4,
          ),
          YMargin(10.sp),
          eachResearcherDetailItem(context,
              iconName: ImageOf.locationIcon,
              title: "Institution",
              subtitle: userProfile.institutionName!),
          eachResearcherDetailItem(
            context,
            iconName: ImageOf.areaOfExperienceIcon,
            title: "Area of Expertise",
            subtitle: userProfile.faculty!,
            others:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              YMargin(16.sp),
              TextOf(
                "Sector/ parastatal of Expertise",
                16,
                4,
              ),
              YMargin(8.sp),
              TextOf(userProfile.sector!, 18, 6),
            ]),
          ),
          eachResearcherDetailItem(context,
              iconName: ImageOf.yearsOfExperience,
              title: "Years of Experience",
              subtitle: userProfile.experience!),
          eachResearcherDetailItem(context,
              iconName: ImageOf.stariconoutlined,
              title: "Rating",
              subtitle: "3.5/5.0"),
          eachResearcherDetailItem(context,
              iconName: ImageOf.declinerateicon,
              title: "Decline Rate",
              subtitle: "15%(Good)"),
          eachResearcherDetailItem(context,
              iconName: ImageOf.deliveryRateIcon,
              title: "Delivery Rate",
              subtitle: "90%(Fast)"),
          YMargin(20.sp),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [TextOf('Escrow', 14.sp, 4)],
            ),
          ),
          YMargin(20.sp),
          if (escrowList.isEmpty)
          Column(
            children: [
              YMargin(0.15.sh),
              ErrorPage(
                  message: "You currently don't have any escrow in common with ${userProfile.fullName!}",
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
      ),
    );
  }
}

Widget topSection(BuildContext context, {required UserProfile userProfile}) {
  return Padding(
    padding: appPadding().copyWith(bottom: 10),
    child: Column(
      children: [
        buildProfileImage(
            imageUrl: userProfile.avatar!,
            fullNameTobSplit: userProfile.fullName!),
        YMargin(20.sp),
        TextOf(userProfile.fullName!, 20.sp, 6),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     ///[full name Text1`  q]
        //     XMargin(4.sp),
        //     ElTooltip(
        //         color: AppThemeNotifier.themeColor(context)
        //             .scaffoldBackgroundColor,
        //         position: ElTooltipPosition.bottomCenter,
        //         showArrow: false,
        //         content: TextOf("Veteran Researcher", 10.sp, 4),
        //         child: Image.asset(
        //           ImageOf.verified,
        //           height: 22,
        //         )),
        //   ],
        // ),
        YMargin(10.sp),
        TextOf("Online", 14.sp, 4, color: AppColors.primaryColor),
        YMargin(16.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            eachTopProfileAction(iconName: ImageOf.messageNav, name: "Message"),
            eachTopProfileAction(
                iconName: ImageOf.genefratePaymentIcon,
                name: "Generate Payment"),
            eachTopProfileAction(
                iconName: ImageOf.shareIcon, name: "Share Profile")
          ],
        ),
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

Widget eachTopProfileAction({required String iconName, required String name}) {
  return Column(
    children: [
      Image.asset(
        iconName,
        height: 25.sp,
      ),
      YMargin(5.sp),
      TextOf(name, 14.sp, 5, color: AppColors.primaryColor)
    ],
  );
}
