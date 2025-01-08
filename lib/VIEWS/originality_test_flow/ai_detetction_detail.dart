import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class AiDetectionDetailsPage extends StatefulWidget {
  static const String aiDetectionDetailsPage = "aiDetectionDetailsPage";
  const AiDetectionDetailsPage({super.key});

  @override
  State<AiDetectionDetailsPage> createState() => _AiDetectionDetailsPageState();
}

class _AiDetectionDetailsPageState extends State<AiDetectionDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "AI Detection", hasIcon: true),
      body: Column(
        children: [
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 2.sp),
              padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: 10.sp),
              color: AppColors.red,
              child: Center(
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.white),
                          text: "AI Detection Failed: ",
                          children: [
                    TextSpan(
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white),
                        text: "7% Human")
                  ])))),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: appPadding(),
              child: Column(
                children: [
                  ...List.generate(
                      3,
                      (index) => Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextOf(
                                    index != 0 ? "Found" : "Unique",
                                    16.sp,
                                    5,
                                    color: index != 0
                                        ? AppColors.red
                                        : AppColors.green,
                                  )
                                ],
                              ),
                              YMargin(2.5.sp),
                              Row(
                                children: [
                                  Expanded(
                                      child: TextOf(
                                    height: 1.5.sp,
                                    index == 0
                                        ? "These investigations include those by Sari, Ewing, and Soytas (2008)"
                                        : index == 1
                                            ? "These investigations include those by Sari, Ewing, and Soytas (2008)"
                                            : "Numerous empirical research have examined the connection between economic growth and renewable energy or renewable",
                                    16.sp,
                                    4,
                                    align: TextAlign.left,
                                  ))
                                ],
                              ),
                              YMargin(10.sp),
                            ],
                          )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextOf(
                        "Found",
                        16.sp,
                        5,
                        color: AppColors.red,
                      )
                    ],
                  ),
                  YMargin(2.5.sp),
                  Row(
                    children: [
                      Expanded(
                          child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      height: 1.5.sp,
                                      fontSize: 16.sp,
                                      color:
                                          AppThemeNotifier.colorScheme(context)
                                              .primary,
                                      fontWeight: FontWeight.w400),
                                  text:
                                      "Their findings suggest that for almost all metrics of disaggregated energy consumption, actual output\n\n",
                                  children: [
                            TextSpan(
                                style: TextStyle(
                                    height: 1.5.sp,
                                    fontSize: 16.sp,
                                    decoration: TextDecoration.none,
                                    color: AppColors.red,
                                    fontWeight: FontWeight.w400),
                                text:
                                    "Numerous empirical research have examined the connection between economic growth and renewable energy or renewable power consumption, either in the context of individual countries or in studies using panel data. These investigations include those by Sari, Ewing, and Soytas (2008). ",
                                children: [
                                  TextSpan(
                                      style: TextStyle(
                                          height: 1.5.sp,
                                          fontSize: 16.sp,
                                          color: AppThemeNotifier.colorScheme(
                                                  context)
                                              .primary,
                                          fontWeight: FontWeight.w400),
                                      text:
                                          "They used the autoregressive distributed lag (ARDL) method to analyze the association between disaggregate ",
                                      children: [
                                        //
                                        TextSpan(
                                            style: TextStyle(
                                                height: 1.5.sp,
                                                fontSize: 16.sp,
                                                color: AppColors.red,
                                                fontWeight: FontWeight.w400),
                                            text:
                                                "energy consumption and industrial production in the United States using a sample period spanning 2001:1 to 2005:6. The following energy consumption factors received particular focus: coal, fossil fuels, traditional hydroelectric power, solar energy, wind energy, natural gas, wood, and waste. Their findings suggest that for almost all metrics of disaggregated energy consumption, actual output",
                                            children: [
                                              TextSpan(
                                                  style: TextStyle(
                                                      height: 1.5.sp,
                                                      fontSize: 16.sp,
                                                      color: AppThemeNotifier
                                                              .colorScheme(
                                                                  context)
                                                          .primary,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  text:
                                                      "and employment act as long-term forcing variables.")
                                            ])
                                      ])
                                ])
                          ])))
                    ],
                  ),
                  YMargin(10.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                                text: "Total: ",
                                style: TextStyle(
                                    height: 1.5.sp,
                                    fontSize: 16.sp,
                                    color: AppThemeNotifier.colorScheme(context)
                                        .primary,
                                    fontWeight: FontWeight.w400),
                                children: [
                                  TextSpan(
                                      text: "834 ",
                                      style: TextStyle(
                                          height: 1.5.sp,
                                          fontSize: 16.sp,
                                          color: AppThemeNotifier.colorScheme(
                                                  context)
                                              .primary,
                                          fontWeight: FontWeight.w500),
                                      children: [
                                        TextSpan(
                                            text: "chars, ",
                                            style: TextStyle(
                                                height: 1.5.sp,
                                                fontSize: 16.sp,
                                                color: AppThemeNotifier
                                                        .colorScheme(context)
                                                    .primary,
                                                fontWeight: FontWeight.w400),
                                            children: [
                                              TextSpan(
                                                  text: "115 ",
                                                  style: TextStyle(
                                                      height: 1.5.sp,
                                                      fontSize: 16.sp,
                                                      color: AppThemeNotifier
                                                              .colorScheme(
                                                                  context)
                                                          .primary,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: [
                                                    TextSpan(
                                                        text: "words, ",
                                                        style: TextStyle(
                                                            height: 1.5.sp,
                                                            fontSize: 16.sp,
                                                            color: AppThemeNotifier
                                                                    .colorScheme(
                                                                        context)
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                        children: [
                                                          TextSpan(
                                                              text: '4 ',
                                                              style: TextStyle(
                                                                  height:
                                                                      1.5.sp,
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: AppThemeNotifier
                                                                          .colorScheme(
                                                                              context)
                                                                      .primary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                              children: [
                                                                TextSpan(
                                                                    style: TextStyle(
                                                                        height: 1.5
                                                                            .sp,
                                                                        fontSize: 16
                                                                            .sp,
                                                                        color: AppThemeNotifier.colorScheme(context)
                                                                            .primary,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400),
                                                                    text:
                                                                        "unique sentences, ",
                                                                    children: [
                                                                      TextSpan(
                                                                          style: TextStyle(
                                                                              height: 1.5.sp,
                                                                              fontSize: 16.sp,
                                                                              color: AppColors.red,
                                                                              fontWeight: FontWeight.w500),
                                                                          text: "9%",
                                                                          children: [
                                                                            TextSpan(
                                                                                style: TextStyle(height: 1.5.sp, fontSize: 16.sp, color: AppColors.red, fontWeight: FontWeight.w400),
                                                                                text: " originality")
                                                                          ])
                                                                    ])
                                                              ])
                                                        ])
                                                  ])
                                            ])
                                      ])
                                ])),
                      ),
                    ],
                  ),
                  YMargin(40.sp),
                  Button(
                    text: "Donwload Report as PDF",
                    onPressed: () {},
                    buttonType: ButtonType.blueBg,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
