import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/VIEWS/account_flow/about_us.dart';
import 'package:project_bist/VIEWS/account_flow/change_passwowrd.dart';
import 'package:project_bist/VIEWS/account_flow/faqs.dart';
import 'package:project_bist/PROVIDERS/profile_provider/profile_provider.dart';
import 'package:project_bist/VIEWS/contact_us/contact_us.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import "package:project_bist/THEMES/color_themes.dart";
import 'package:project_bist/UTILS/launch_url.dart';
import 'package:project_bist/UTILS/constants.dart';

class PrivacyPage extends StatefulWidget {
  static const String privacyPage = "privacyPage";
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
} //don't make a permanent decision based on temporary emotions, to be the best, you gotta be able to handle the worst

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: "Privacy", hasIcon: true, hasElevation: true),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox.expand(
            child: SingleChildScrollView(
              padding: appPadding(),
              child: Column(children: [
                accountActions(
                  context,
                  iconName: Icons.password,
                  title: "Change Password",
                  routeToGo: ChangePassword.changePassword,
                  subtitle: "Strenghten your app security",
                ),
                accountActions(context,
                    iconName: Icons.gpp_maybe_outlined,
                    title: "Privacy & policy", onTap: () {
                  LaunchUrl.launchWebsite(context,
                      websiteLink: AppConst.PRIVACY_POLICY_URL);
                }, subtitle: "Let’s be on the same page"),
                accountActions(context,
                    iconName: Icons.info_outline_rounded,
                    title: "About us",
                    subtitle: "Personalize your experience.",
                    routeToGo: AboutUs.aboutUs),
                accountActions(context,
                    iconName: Icons.quiz_outlined,
                    title: "FAQ’s",
                    routeToGo: FaqsScreen.faqsScreen,
                    subtitle: "Find answers to questions you may have."),
                accountActions(context,
                    iconName: Icons.location_pin,
                    title: "Contact Us",
                    routeToGo: ContactUs.contactUs,
                    subtitle: "Find us through our social media"),
              ]),
            ),
          ),
          Column(mainAxisSize: MainAxisSize.min, children: [
            InkWell(
                onTap: () {
                  ProfileProvider.deleteProfile(context);
                },
                child: TextOf("Delete my account", 15.sp, 5,
                    color: AppColors.red)),
            YMargin(25.sp)
          ])
        ],
      ),
    );
  }
}

Widget accountActions(BuildContext context,
    {required IconData iconName,
    required String title,
    required String subtitle,
    String? routeToGo,
    Widget? widgetScreenToGo,
    void Function()? onTap}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 16.sp),
    child: InkWell(
      onTap: onTap ??
          () {
            widgetScreenToGo != null
                ? Navigator.push(context,
                    MaterialPageRoute(builder: (context) => widgetScreenToGo))
                : () {};
            routeToGo == null ? () {} : Navigator.pushNamed(context, routeToGo);
          },
      child: Row(children: [
        IconOf(iconName, color: AppThemeNotifier.colorScheme(context).primary),
        XMargin(20.sp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [TextOf(title, 16.sp, 6), TextOf(subtitle, 12.sp, 4)],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconOf(
                Icons.arrow_forward_ios_rounded,
                color: AppThemeNotifier.colorScheme(context).primary,
              ),
            ],
          ),
        )
      ]),
    ),
  );
}
