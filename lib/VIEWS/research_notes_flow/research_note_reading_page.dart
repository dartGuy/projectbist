// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class ResearchNotesReadingPage extends StatefulWidget {
  static const String researchNotesReadingPage = "researchNotesReadingPage";
  ResearchNotesReadingPage({required this.pageTogo, super.key});
  int pageTogo;
  @override
  State<ResearchNotesReadingPage> createState() =>
      _ResearchNotesReadingPageState();
}

class _ResearchNotesReadingPageState extends State<ResearchNotesReadingPage> {
  late PageController pageController;
  int pageIndex = 0;
  @override
  void initState() {
    setState(() {
      pageController = PageController();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.animateToPage(widget.pageTogo,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
    return Scaffold(
        appBar: customAppBar(context,
            title: "Research Notes", hasIcon: true, hasElevation: true),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox.expand(
                child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        pageIndex = value;
                      });
                    },
                    itemCount: 3,
                    itemBuilder: (context, index) => Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: appPadding().copyWith(bottom: 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextOf(
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
                                      ),
                                    ],
                                  ),
                                ),
                                YMargin(5.sp),
                                Padding(
                                  padding:
                                      appPadding().copyWith(top: 0, bottom: 0),
                                  child: Row(
                                    children: [
                                      Expanded(
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
                                            7,
                                            align: TextAlign.left),
                                      ),
                                    ],
                                  ),
                                ),
                                YMargin(8.sp),
                                AppDivider(),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: appPadding().copyWith(top: 0),
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextOf(
                                              switch (index) {
                                                0 =>
                                                  "Think of research or thesis writing as baking a cake. Just as you follow a recipe to create a delicious cake, you follow a structured process to produce a well-researched thesis. Here's how it works:",
                                                1 =>
                                                  "Think of Chapter One in your thesis as the foundation for your research cake. This chapter sets the stage for everything that follows, just like preparing the ingredients and baking pans for a cake. Here's how it breaks down:",
                                                2 =>
                                                  "Chapter Two is like gathering the right ingredients for your thesis cake. It's where you explore what others have done in your research area, understand relevant theories, and identify gaps to fill. Here's how it's structured:",
                                                _ => ""
                                              },
                                              16.sp,
                                              4,
                                              align: TextAlign.left),
                                        ),
                                      ],
                                    ),
                                    YMargin(20.sp),
                                    switch (index) {
                                      0 => firstContent(),
                                      1 => secondContent(),
                                      2 => thirdContent(),
                                      _ => Container()
                                    },
                                    YMargin(10.sp),
                                    Row(children: [
                                      Expanded(
                                          child: TextOf(
                                              switch (index) {
                                                0 =>
                                                  "So, research or thesis writing is like baking a cake—a step-by-step process where you carefully follow a recipe (methodology) to create a well-crafted and meaningful academic work, contributing to what we know in economics and other fields.",
                                                1 =>
                                                  "In essence, Chapter One is like preparing the ingredients and setting the baking goals for your research cake. It helps readers (and you) understand the context, importance, and goals of your study before you dive into the detailed research process.",
                                                2 =>
                                                  "In a nutshell, Chapter Two is like gathering the best ingredients for your thesis cake. You explore concepts, theories, and previous studies related to your research. You create a clear recipe (conceptual framework) and identify where the missing ingredients (gaps) are. This chapter provides the foundation for your research cake, ensuring you're using the right ingredients and addressing unanswered questions.",
                                                _ => ""
                                              },
                                              16.sp,
                                              4,
                                              align: TextAlign.left))
                                    ]),
                                    YMargin(50.sp),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))),
            Container(
              width: double.infinity,
              height: 50.sp,
              padding: appPadding(),
              color:
                  AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
              child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(2, (index) {
                      List<Widget> controls = [
                        index == 0
                            ? IconOf(
                                Icons.arrow_back_ios_rounded,
                                size: 15.sp,
                                color: returnColor(pageIndex, index),
                              )
                            : const SizedBox.shrink(),
                        XMargin(5.sp),
                        InkWell(
                          onTap: () {
                            if ((index == 1 && pageIndex != 2)) {
                              setState(() {
                                widget.pageTogo = pageIndex + 1;
                              });
                              pageController.animateToPage(pageIndex + 1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                            } else if (index == 0 && pageIndex != 0) {
                              setState(() {
                                widget.pageTogo = pageIndex - 1;
                              });
                              pageController.animateToPage(pageIndex - 1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                            }
                          },
                          child: TextOf(
                              index == 0 ? "Previous" : "Next", 16.sp, 6,
                              color: returnColor(pageIndex, index)),
                        ),
                        XMargin(5.sp),
                        index == 1
                            ? IconOf(
                                Icons.arrow_forward_ios_rounded,
                                size: 15.sp,
                                color: returnColor(pageIndex, index),
                              )
                            : const SizedBox.shrink(),
                      ];
                      return Row(
                        children: controls,
                      );
                    })),
              ),
            )
          ],
        ));
  }

  Widget secondContent() {
    return const Column(children: [
      RichTextParagraph(
        index: 1,
        title: 'Background to the Study Understanding the Recipe: ',
        explanation:
            'This is where you explain why your research topic is important. It\'s like understanding why a specific cake recipe matters. For example, if you\'re studying inflation\'s impact on prices (your cake), you\'d explain why this is a significant topic in economics.',
      ),
      RichTextParagraph(
        index: 2,
        title: 'Statement of the Problem Identifying the Missing Ingredient:',
        explanation:
            'Here, you identify what\'s missing or unclear in the existing knowledge (like finding out you\'re missing a key ingredient for your cake). In our example, it\'s stating what\'s not known about the relationship between inflation and prices.',
      ),
      RichTextParagraph(
        index: 3,
        title: 'Research Questions Setting Your Baking Goals:',
        explanation:
            'Just as a recipe gives you specific steps to follow, research questions guide your study. These questions are like setting baking goals, such as "How does inflation affect different product prices?',
      ),
      RichTextParagraph(
        index: 4,
        title: 'Aim/Objective of the Study Defining the Cake You Want to Bake:',
        explanation:
            'This is where you state what you aim to achieve with your research. It\'s like deciding you want to bake a perfect chocolate cake. In research, you might aim to understand the impact of inflation on specific price categories.',
      ),
      RichTextParagraph(
        index: 5,
        title: "Research Hypothesis Predicting the Cake's Taste:",
        explanation:
            'If applicable, this is where you make educated guesses about your research outcomes. It\'s like predicting how your cake will taste before you bake it. For instance, you might hypothesize that "Higher inflation leads to higher prices for essential goods."',
      ),
      RichTextParagraph(
        index: 6,
        title:
            'Significance/Justification of the Study Explaining Why the Cake Matters:',
        explanation:
            'You explain why your research matters, similar to why a cake recipe is worth trying. You might highlight that understanding inflation\'s effects helps policymakers make better decisions.',
      ),
      RichTextParagraph(
        index: 7,
        title: 'Scope of the Study Defining Your Cake\'s Size:',
        explanation:
            'Just as you decide the size of your cake (a small birthday cake or a large wedding cake), the scope of your study defines its boundaries. You clarify what you will and won\'t include in your research.',
      ),
    ]);
  }

  Widget firstContent() {
    return const Column(children: [
      RichTextParagraph(
        index: 1,
        title: 'Choosing a Recipe (Topic):',
        explanation:
            'Imagine you have a recipe book, and you choose a recipe to bake a cake. In research, you select a topic to investigate, like studying the impact of inflation on prices.',
      ),
      RichTextParagraph(
        index: 2,
        title: 'Gathering Ingredients (Research):',
        explanation:
            'For baking, you gather ingredients like flour, sugar, and eggs. In research, you collect data, facts, and information from sources like books, articles, and surveys.',
      ),
      RichTextParagraph(
        index: 3,
        title: 'Following the Recipe (Methodology):',
        explanation:
            'Just as you follow the steps in a recipe, in research, you create a plan (methodology) to collect and analyze data. It\'s like deciding how long to bake the cake.',
      ),
      RichTextParagraph(
        index: 4,
        title: 'Mixing and Baking (Writing):',
        explanation:
            'When baking, you mix and bake ingredients. In research, you write and organize your findings, mixing data and analysis into a coherent document.',
      ),
      RichTextParagraph(
        index: 5,
        title: "Taste Testing (Editing):",
        explanation:
            'Before serving a cake, you taste it to ensure it\'s delicious. Similarly, you review and edit your thesis to make it well-structured and clear.',
      ),
      RichTextParagraph(
        index: 6,
        title: 'Presentation (Sharing Results):',
        explanation:
            'When the cake is ready, you share it with others. In research, you present your findings and conclusions to professors and peers.',
      ),
      RichTextParagraph(
        index: 7,
        title: 'Adding to Culinary Knowledge (Academic Contribution):',
        explanation:
            'Just as your cake adds to your culinary skills, your thesis adds to academic knowledge by offering new insights in your field, like understanding economic trends',
      ),
    ]);
  }

  Widget thirdContent() {
    return const Column(children: [
      RichTextParagraph(
        index: 1,
        title: 'Conceptual Review - Selecting the Best Ingredients:',
        explanation:
            'This section is like choosing the finest ingredients for your cake. You examine key concepts, terms, and definitions related to your topic. For example, if you\'re studying inflation, you\'d clarify what inflation means in economic terms.',
      ),
      RichTextParagraph(
        index: 2,
        title: 'Theoretical Review - Understanding the Recipe (Theories):',
        explanation:
            'Just as a baker needs to understand the science of baking, you delve into theories related to your topic. In economics, this could involve exploring theories about the relationship between inflation and prices.',
      ),
      RichTextParagraph(
        index: 3,
        title:
            'Empirical Review (According to Objectives) - Checking Past Recipes (Studies):',
        explanation:
            'Here, you review previous studies (like checking different cake recipes) that have examined aspects related to your research objectives. For instance, you\'s look at studies that have analysed how inflation impacted specific product prices.',
      ),
      RichTextParagraph(
        index: 4,
        title: 'Conceptual Framework - Designing Your Cake Recipe:',
        explanation:
            'This is where you create a visual representation of how key concepts are connected in your study. It\'s like sketching out the recipe for your cake, showing the order of ingredients and how they interact. In economics, your conceptual framework might illustrate the relationship between inflation, prices, and other factors.',
      ),
      RichTextParagraph(
        index: 5,
        title: "Gaps in the Study - Finding Missing Ingredients:",
        explanation:
            'Just as you might notice gaps in a recipe, you identify gaps in existing research. These are areas where previous studies haven\'t fully addressed your research questions. You pinpoint what\'s missing and how your study will fill those gaps.',
      ),
    ]);
  }

  returnColor(int pageIndex, int index) {
    if ((pageIndex == 0 && index == 0) || (pageIndex == 2 && index == 1)) {
      return AppColors.blueLite;
    } else {
      return AppColors.primaryColor;
    }
  }
}

class RichTextParagraph extends StatelessWidget {
  final String title;
  final String explanation;
  final int index;

  const RichTextParagraph({
    super.key,
    required this.title,
    required this.index,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextOf("$index.", 16, 4),
            XMargin(10.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TextOf(
                        title,
                        16.sp,
                        6,
                        align: TextAlign.left,
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextOf(
                        explanation,
                        16.sp,
                        4,
                        align: TextAlign.left,
                      )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        YMargin(10.sp),
      ],
    );
  }
}
