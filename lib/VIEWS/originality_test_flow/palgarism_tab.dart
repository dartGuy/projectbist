import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/originality_test_flow/plagarism_detail.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class PlagarismTab extends StatefulWidget {
  const PlagarismTab({super.key});

  @override
  State<PlagarismTab> createState() => _PlagarismTabState();
}

class _PlagarismTabState extends State<PlagarismTab> {
  bool previousPlagiarismLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: appPadding(),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox.expand(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [TextOf("Recent", 16.sp, 5)],
                  ),
                  YMargin(10.sp),
                  previousPlagiarismLoaded == false
                      ? Column(
                          children: [
                            YMargin(0.125.sh),
                            ErrorPage(
                              message:
                                  "Your plagiarism check on files will appear here when available",
                              showButton: false,
                            )
                          ],
                        )
                      : Column(children: [
                          ...List.generate(
                              2,
                              (firstIndex) => Column(
                                    children: [
                                      YMargin(10.sp),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: TextOf(
                                            "Numerous empirical research have examined the connection between economic growth and renewable energy or renewable power consumption, either in the context of individual countries or in studies using panel data.",
                                            16.sp,
                                            5,
                                            maxLines: 1,
                                            align: TextAlign.left,
                                            textOverflow: TextOverflow.ellipsis,
                                          ))
                                        ],
                                      ),
                                      YMargin(15.sp),
                                      AppDivider(),
                                      ...List.generate(
                                          2,
                                          (index) => Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.sp),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            PlagarismDetail
                                                                .plagarismDetail);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextOf(
                                                                  firstIndex ==
                                                                              1 &&
                                                                          index ==
                                                                              1
                                                                      ? "Chapter 1 Project B"
                                                                      : 'Chapter 1 Project A',
                                                                  16.sp,
                                                                  6),
                                                              TextOf(
                                                                firstIndex ==
                                                                            1 &&
                                                                        index ==
                                                                            1
                                                                    ? "500 KB"
                                                                    : '12 MB',
                                                                14.sp,
                                                                4,
                                                                color: isDarkTheme(
                                                                        context)
                                                                    ? AppColors
                                                                        .grey1
                                                                    : AppColors
                                                                        .grey3,
                                                              ),
                                                            ],
                                                          ),
                                                          Image.asset(
                                                            firstIndex == 1 &&
                                                                    index == 1
                                                                ? ImageOf
                                                                    .docFile
                                                                : ImageOf
                                                                    .pdfFile,
                                                            height: 35.sp,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  AppDivider()
                                                ],
                                              ))
                                    ],
                                  ))
                        ])
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
