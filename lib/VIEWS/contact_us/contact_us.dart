import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/UTILS/launch_url.dart';

class ContactUs extends StatefulWidget {
  static const String contactUs = "contactUs";
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, title: "Contact us", hasIcon: true),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.sp),
            child: Column(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    String pageName = switch (index) {
                      0 => "Facebook",
                      1 => "X",
                      2 => "Instagram",
                      3 => "LinkedIn",
                      _ => ""
                    };
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: InkWell(
                        onTap: () {
                          LaunchUrl.launchWebsite(context,
                              websiteLink: switch (index) {
                                0 => AppConst.OUR_FACEBOOK_PAGE,
                                1 => AppConst.OUR_X_PAGE,
                                2 => AppConst.OUR_INSTAGRAM_PAGE,
                                3 => AppConst.OUR_LINKEDIN_PAGE,
                                _ => ""
                              });
                        },
                        child: SvgPicture.asset(
                          switch (index) {
                            0 => ImageOf.facebook,
                            1 => ImageOf.x,
                            2 => ImageOf.instagram,
                            3 => ImageOf.linkedin,
                            _ => ""
                          },
                          height: 50.sp,
                        ),
                      ),
                    );
                  })),
              YMargin(50.sp),
              TextOf("You can also visit our website at", 16.sp, 5),
              YMargin(10.sp),
              InkWell(
                  onTap: () {
                    LaunchUrl.launchWebsite(context,
                        websiteLink: AppConst.OUR_WEBSITE);
                  },
                  child: TextOf("www.projectbist.com", 16.sp, 5,
                      decoration: TextDecoration.underline,
                      color: AppColors.primaryColor))
            ])));
  }
}
