import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/WIDGETS/topic_display_items.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import "package:project_bist/CORE/app_objects.dart";
import 'package:project_bist/MODELS/topics_model/explore_topics_model.dart';

class FilteredTopicPageArgument {
  FilteredTopicPageArgument(
      {required this.topicModelList,
      this.hoursDifference,
      this.sectorOrParastatal,
      this.division,
      this.paperTypeValue,
      this.isResearcher = true});

  String? sectorOrParastatal, division, paperTypeValue;
  int? hoursDifference;
  bool? isResearcher;
  final TopicsList topicModelList;
}

// ignore: must_be_immutable
class FilteredTopicPage extends ConsumerStatefulWidget {
  const FilteredTopicPage({required this.filteredTopicPageArgument, super.key});

  static const String filteredTopicPage = "filteredTopicPage";

  final FilteredTopicPageArgument filteredTopicPageArgument;

  @override
  ConsumerState<FilteredTopicPage> createState() => _FilteredTopicPageState();
}

class _FilteredTopicPageState extends ConsumerState<FilteredTopicPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    List<List<Widget>> researcherSearchBody() {
      TopicsList topicList = widget.filteredTopicPageArgument.topicModelList
          .where((e) =>
              (widget.filteredTopicPageArgument.hoursDifference != null
                  ? (DateTime.now().difference(e.createdAt!).inHours <=
                      widget.filteredTopicPageArgument.hoursDifference!)
                  : true) &&
              (widget.filteredTopicPageArgument.sectorOrParastatal?.toLowerCase() != null
                  ? (e.sector!.toLowerCase().contains(widget.filteredTopicPageArgument.sectorOrParastatal!.toLowerCase()) ||
                      e.faculty!.toLowerCase().contains(widget
                          .filteredTopicPageArgument.sectorOrParastatal!
                          .toLowerCase()))
                  : true) &&
              (widget.filteredTopicPageArgument.division?.toLowerCase() != null
                  ? (e.division!.toLowerCase().contains(widget.filteredTopicPageArgument.division!.toLowerCase()) ||
                      e.discipline!.toLowerCase().contains(
                          widget.filteredTopicPageArgument.division!.toLowerCase()))
                  : true) &&
              (widget.filteredTopicPageArgument.paperTypeValue?.toLowerCase() != null ? (e.type!.contains(widget.filteredTopicPageArgument.paperTypeValue!.toLowerCase()) || e.type!.toLowerCase().contains(widget.filteredTopicPageArgument.paperTypeValue!.toLowerCase())) : true))
          .toList();
      return [
        List.generate(topicList.length, (index) {
          ExploreTopicsModel topic = topicList[index];
          return TopicDisplayItem(topicModel: topic, hasDivider: true);
        }),
        List.generate(
            topicList
                .where((e) => e.type!.toLowerCase().contains("student"))
                .toList()
                .length, (index) {
          ExploreTopicsModel topic = topicList
              .where((e) => e.type!.toLowerCase().contains("student"))
              .toList()[index];
          return TopicDisplayItem(topicModel: topic, hasDivider: true);
        }),
        List.generate(
            topicList
                .where((e) => e.type!.toLowerCase().contains("professional"))
                .toList()
                .length, (index) {
          ExploreTopicsModel topic = topicList
              .where((e) => e.type!.toLowerCase().contains("professional"))
              .toList()[index];
          return TopicDisplayItem(topicModel: topic, hasDivider: true);
        }),
      ];
    }

    var thisWhite =
        AppThemeNotifier.themeColor(context).scaffoldBackgroundColor;
    return Scaffold(
      appBar: customAppBar(context, title: "Filtered Topics"),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: appPadding().copyWith(bottom: 5),
              child: Column(
                children: [
                  widget.filteredTopicPageArgument.isResearcher != true
                      ? const SizedBox.shrink()
                      : YMargin(10.sp),
                  widget.filteredTopicPageArgument.isResearcher != true
                      ? const SizedBox.shrink()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                              3,
                              (index) => InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      currentIndex = index;
                                    });
                                  },
                                  child: Container(
                                    height: 31.sp,
                                    width: 0.285.sw,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: currentIndex == index
                                                ? AppColors.primaryColor
                                                : AppColors.grey1),
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        color: currentIndex == index
                                            ? AppColors.primaryColor
                                            : thisWhite),
                                    child: Center(
                                      child: TextOf(
                                        index == 0
                                            ? "All"
                                            : index == 1
                                                ? "Student"
                                                : "Professional",
                                        12.sp,
                                        4,
                                        color: currentIndex == index
                                            ? AppColors.white
                                            : (AppThemeNotifier.colorScheme(
                                                            context)
                                                        .primary ==
                                                    AppColors.white
                                                ? AppColors.grey1
                                                : AppColors.grey3),
                                      ),
                                    ),
                                  ))),
                        ),
                ],
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10.sp)
                  .add(EdgeInsets.only(top: 7.sp)),
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.all(7.sp),
                decoration: BoxDecoration(color: AppColors.brown1(context)),
                child: Row(
                    children: List.generate(
                        ref.watch(switchUserProvider) == UserTypes.researcher
                            ? 4
                            : 3,
                        (index) => Row(
                              children: [
                                TextOf(
                                    switch (index) {
                                      0 => "Period:",
                                      1 => ref.watch(switchUserProvider) !=
                                              UserTypes.student
                                          ? "Sector/Parastatal"
                                          : "Faculty",
                                      2 => ref.watch(switchUserProvider) !=
                                              UserTypes.student
                                          ? "Discipline"
                                          : "Division",
                                      3 => "Paper Type",
                                      _ => ""
                                    },
                                    14.sp,
                                    6),
                                XMargin(5.sp),
                                TextOf(
                                    switch (index) {
                                      0 => widget.filteredTopicPageArgument
                                                  .hoursDifference ==
                                              null
                                          ? "--No data--"
                                          : "Last ${widget.filteredTopicPageArgument.hoursDifference} hours",
                                      1 => widget.filteredTopicPageArgument
                                              .sectorOrParastatal ??
                                          "--No data--",
                                      2 => widget.filteredTopicPageArgument
                                              .division ??
                                          "--No data--",
                                      3 => widget.filteredTopicPageArgument
                                              .paperTypeValue ??
                                          "--No data--",
                                      _ => ""
                                    },
                                    14.sp,
                                    4),
                                index !=
                                        (ref.watch(switchUserProvider) ==
                                                UserTypes.researcher
                                            ? 3
                                            : 2)
                                    ? XMargin(20.sp)
                                    : const SizedBox.shrink()
                              ],
                            ))),
              ),
            ),
            widget.filteredTopicPageArgument.isResearcher != true
                ? const SizedBox.shrink()
                : AppDivider(),
            researcherSearchBody()[currentIndex].isEmpty
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ErrorPage(
                            showButton: false,
                            message: currentIndex == 0
                                ? "No topic available!"
                                : currentIndex == 1
                                    ? "No topic available for students"
                                    : "No topic available for professionals"),
                      ],
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      padding: appPadding(),
                      child: Column(
                        children: researcherSearchBody()[currentIndex],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
