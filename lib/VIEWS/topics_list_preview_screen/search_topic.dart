import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/WIDGETS/topic_display_items.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import "package:project_bist/CORE/app_objects.dart";
import 'package:project_bist/MODELS/topics_model/explore_topics_model.dart';

class SearchTopicPageArgument {
  final TopicsList topicModelList;
  bool? isResearcher;
  SearchTopicPageArgument(
      {required this.topicModelList, this.isResearcher = true});
}

// ignore: must_be_immutable
class SearchTopicPage extends StatefulWidget {
  static const String searchTopicPage = "searchTopicPage";
  final SearchTopicPageArgument searchTopicPageArgument;
  const SearchTopicPage({required this.searchTopicPageArgument, super.key});

  @override
  State<SearchTopicPage> createState() => _SearchTopicPageState();
}

class _SearchTopicPageState extends State<SearchTopicPage> {
  late TextEditingController searchFieldController;

  @override
  void initState() {
    setState(() {
      searchFieldController = TextEditingController();
      searchFieldController.text = "";
    });
    super.initState();
  }

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    List<List<Widget>> researcherSearchBody() {
      TopicsList topicList = widget.searchTopicPageArgument.topicModelList
          .where((e) => e.topic!
              .toLowerCase()
              .contains((searchFieldController.text).toLowerCase()))
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
                    .length ??
                0, (index) {
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: appPadding().copyWith(bottom: 5),
              child: Column(
                children: [
                  InputField(
                      hintText: "Search for anything...",
                      hintColor:
                          AppThemeNotifier.colorScheme(context).primary ==
                                  AppColors.white
                              ? AppColors.grey1
                              : AppColors.grey3,
                      fillColor: AppColors.brown1(context),
                      autofocus: true,
                      radius: 10.r,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
                      enabledBorderColor: AppColors.brown1(context),
                      focusedBorderColor: AppColors.brown1(context),
                      prefixIcon: IconOf(
                        Icons.search,
                        size: 23.sp,
                        color: AppThemeNotifier.colorScheme(context).primary ==
                                AppColors.white
                            ? AppColors.grey1
                            : AppColors.grey3,
                      ),
                      suffixIcon: searchFieldController.text.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                searchFieldController.clear();
                              },
                              child: const IconOf(Icons.close))
                          : const SizedBox.shrink(),
                      fieldController: searchFieldController),
                  widget.searchTopicPageArgument.isResearcher != true
                      ? const SizedBox.shrink()
                      : YMargin(10.sp),
                  widget.searchTopicPageArgument.isResearcher != true
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
            widget.searchTopicPageArgument.isResearcher != true
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
