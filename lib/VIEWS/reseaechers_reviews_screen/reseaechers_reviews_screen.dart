import 'package:flutter/material.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/review_item.dart';
import 'package:project_bist/main.dart';

class ResearchersReviewsScreen extends StatelessWidget {
  static const String researchersReviewsScreen = "researchersReviewsScreen";
  const ResearchersReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: "Reviews", hasIcon: true, hasElevation: true),
      body: SingleChildScrollView(
        padding: appPadding(),
        child: Column(
          children: List.generate(
              6,
              (index) => ReviewItem(
                    unratedIcon: ImageOf.ashStar,
                    ratingDate: "Mar 2, 2020",
                    starNumer: index == 1
                        ? 3
                        : index == 3
                            ? 0
                            : index == 5
                                ? 2
                                : 5,
                    hasDivider: index == 5 ? false : true,
                  )),
        ),
      ),
    );
  }
}
