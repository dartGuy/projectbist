import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/research_notes_flow/research_note_reading_page.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/drawer_contents.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class ResearchNotesFlow extends StatefulWidget {
  static const String researchNotesFlow = "researchNotesFlow";
  const ResearchNotesFlow({super.key});

  @override
  State<ResearchNotesFlow> createState() => _ResearchNotesFlowState();
}

class _ResearchNotesFlowState extends State<ResearchNotesFlow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerContents(),
      appBar: customAppBar(context,
          title: "Research Notes",
          hasElevation: true,
          scale: 1.25.sp, leading: Builder(builder: (context) {
        return InkWell(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const IconOf(Icons.menu, color: AppColors.primaryColor),
        );
      }), hasIcon: true, actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.sp),
          child: Image.asset(ImageOf.bell, height: 23.sp),
        )
      ]),
      body: Builder(builder: (context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (value) {
            Scaffold.of(context).openDrawer();
          },
          child: Padding(
            padding: appPadding(),
            child: Column(
              children: [
                Row(children: [
                  Expanded(
                      child: TextOf(
                    "Explore topics on how to write rich research projects below.",
                    16.sp,
                    4,
                    align: TextAlign.left,
                  ))
                ]),
                YMargin(16.sp),
                ...List.generate(
                    3,
                    (index) =>
                        Column(mainAxisSize: MainAxisSize.min, children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context,
                                      ResearchNotesReadingPage
                                          .researchNotesReadingPage,
                                      arguments: index);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextOf(
                                              switch (index) {
                                                0 => "General Overview",
                                                1 => "Chapter One",
                                                2 => "Chapter Two",
                                                _ => ""
                                              },
                                              16.sp,
                                              4,
                                              color: AppColors.brown,
                                              align: TextAlign.left),
                                          YMargin(5.sp),
                                          SizedBox(
                                            width: 0.8.sw,
                                            child: TextOf(
                                                switch (index) {
                                                  0 =>
                                                    "What is Research/Thesis Writing?",
                                                  1 =>
                                                    "Introduction - Baking the Thesis Foundation",
                                                  2 =>
                                                    "Literature Review - Gathering Ingredients for the Thesis Cake",
                                                  _ => ""
                                                },
                                                16.sp,
                                                6,
                                                align: TextAlign.left),
                                          )
                                        ]),
                                    IconOf(Icons.arrow_forward_ios_rounded,
                                        size: 15.sp)
                                  ],
                                ),
                              ),
                              index == 2
                                  ? const SizedBox.shrink()
                                  : AppDivider()
                            ],
                          )
                        ]))
              ],
            ),
          ),
        );
      }),
    );
  }
}
