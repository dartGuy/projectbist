import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/topic_providers/clients_provider.dart';
import "package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart";
import 'package:project_bist/MODELS/topics_model/explore_topics_model.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/topics_list_preview_screen/search_topic.dart';
import 'package:project_bist/VIEWS/topics_list_preview_screen/filtered_topic.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/components/app_bottom_sheet.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/drawer_contents.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/loading_indicator.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/topic_display_items.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import "package:project_bist/PROVIDERS/topic_providers/topic_providers.dart";
import '../../CORE/app_models.dart';
import "package:project_bist/SERVICES/endpoints.dart";

// ignore: must_be_immutable
class TopicsListPreviewScreen extends ConsumerStatefulWidget {
  bool? isExploreTopic;
  static const String topicsListPreviewScreen = "topicsListPreviewScreen";
  TopicsListPreviewScreen({this.isExploreTopic = false, super.key});

  @override
  ConsumerState<TopicsListPreviewScreen> createState() =>
      _TopicsListPreviewScreenState();
}

class _TopicsListPreviewScreenState
    extends ConsumerState<TopicsListPreviewScreen> {
  int? hoursDifference;
  String? sectorOrParastatalValiue, divisionValue, paperTypeValue;

  @override
  Widget build(BuildContext context) {
    ResponseStatus responseStatus = ref.watch(topicsProvider);
    List<dynamic>? topics = responseStatus.data;
    ref
        .watch(topicsProvider.notifier)
        .getRequest(
            context: context, url: Endpoints.FETCH_TOPICS, showLoading: false)
        .then((value) {
      topics = topics?.where((e) => e["researcherId"] != null).toList();
      getIt<AppModel>().topicsList =
          topics?.map((e) => ExploreTopicsModel.fromJson(e)).toList() ?? [];
    });

    if (responseStatus.responseState == ResponseState.DATA &&
        ref.watch(switchUserProvider) == UserTypes.student &&
        (getIt<AppModel>().topicsList ?? []).isNotEmpty) {
      if ((getIt<AppModel>().topicsList ?? [])
          .where((e) => e.type == "type")
          .toList()
          .isEmpty) {
        ref
            .read(studentsTopicProvider.notifier)
            .fetchStudentsExploreTopic(
                facultyName: getIt<AppModel>().userProfile!.faculty!,
                departmentName: getIt<AppModel>().userProfile!.department!)
            .then((value) => setState(() {}));
      }
      //all is not admin
    }

    // setState(() {
    //   getIt<AppModel>().topicsList = getIt<AppModel>().topicsList;
    // });
    return Scaffold(
        drawer: const DrawerContents(),
        appBar: customAppBar(
          context,
          scale: widget.isExploreTopic == true ? 1.25 : null,
          leading: widget.isExploreTopic == true
              ? Builder(
                  builder: (context) {
                    return InkWell(
                      onTap: () {

                        Scaffold.of(context).openDrawer();
                      },
                      child: const IconOf(
                        Icons.menu,
                        color: AppColors.primaryColor,
                      ),
                    );
                  },
                )
              : null,
          title: "${widget.isExploreTopic == true ? "Explore " : " "}Topics",
          hasIcon: true,
          hasElevation: true,
          actions: (responseStatus.responseState == ResponseState.DATA &&
                  (getIt<AppModel>().topicsList ?? []).isNotEmpty)
              ? [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, SearchTopicPage.searchTopicPage,
                          arguments: SearchTopicPageArgument(
                            topicModelList:
                                (getIt<AppModel>().topicsList ?? []),
                            isResearcher: ref.watch(switchUserProvider) ==
                                UserTypes.researcher,
                          ));
                    },
                    child: ImageIcon(
                      AssetImage(ImageOf.searchIcon),
                      size: 20.sp,
                      color: AppThemeNotifier.colorScheme(context).primary,
                    ),
                  ),
                  XMargin(15.sp),
                  InkWell(
                    onTap: () {
                      // ClientsTopicsProvider.fetchStudentsExploreTopic();
                      setState(() {
                        hoursDifference = null;
                        sectorOrParastatalValiue = null;
                        divisionValue = null;
                        paperTypeValue = null;
                      });
                      AppBottomSheet.filterTopic(context,
                          onSelectedDateItemClicked: (e) {
                        List date = e
                            .split(" ")
                            .where((e) => (int.tryParse(e) != null))
                            .toList();
                        setState(() {
                          hoursDifference = int.tryParse(
                              (date.isNotEmpty ? date : ["720"]).first);
                        });

                        print(hoursDifference);
                      }, onSelectedSectorOrFacultyItemClicked: (e) {
                        setState(() {
                          sectorOrParastatalValiue = e;
                        });
                      }, onSelectedDivisionItemClicked: (e) {
                        setState(() {
                          divisionValue = e;
                        });
                      }, onSelectedPaperTypeItemClicked: (e) {
                        setState(() {
                          paperTypeValue = e;
                        });
                      }, onTapFilter: () {
                        Navigator.pushNamed(
                            context, FilteredTopicPage.filteredTopicPage,
                            arguments: FilteredTopicPageArgument(
                                topicModelList:
                                    (getIt<AppModel>().topicsList ?? []),
                                isResearcher: ref.watch(switchUserProvider) ==
                                    UserTypes.researcher,
                                hoursDifference: hoursDifference,
                                sectorOrParastatal: sectorOrParastatalValiue,
                                division: divisionValue,
                                paperTypeValue: paperTypeValue));
                      });
                    },
                    child: ImageIcon(
                      AssetImage(ImageOf.filerIcon),
                      size: 20.sp,
                      color: AppThemeNotifier.colorScheme(context).primary,
                    ),
                  ),
                  XMargin(25.sp)
                ]
              : null,
        ),
        body: Builder(builder: (context) {
          return PopScope(
            canPop: true,

            // onPopInvoked: (value) =>
            //     // widget.isExploreTopic == true
            //     // ? Scaffold.of(context).openDrawer()
            //     // :
            //     Navigator.pop(context),
            child: switch (responseStatus.responseState!) {
              ResponseState.LOADING =>
                LoadingIndicator(message: "Fetching available topics..."),
              ResponseState.ERROR => ErrorPage(
                  message: responseStatus.message!,
                  onPressed: () {
                    ref.watch(topicsProvider.notifier).getRequest(
                        context: context,
                        url: Endpoints.FETCH_TOPICS,
                        showLoading: false,
                        inErrorCase: true);
                  },
                ),
              ResponseState.DATA => (getIt<AppModel>().topicsList ?? []).isEmpty
                  ? ErrorPage(
                      message: "Topics are currently not available!",
                      onPressed: () {
                        ref.watch(topicsProvider.notifier).getRequest(
                            context: context,
                            url: Endpoints.FETCH_TOPICS,
                            showLoading: false,
                            inErrorCase: true);
                      },
                    )
                  : ListView.separated(
                      padding: appPadding(),
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) =>
                          AppDivider(),
                      itemCount: (getIt<AppModel>().topicsList ?? []).length,
                      itemBuilder: (BuildContext context, int index) {
                        ExploreTopicsModel topic =
                            (getIt<AppModel>().topicsList ?? [])[index];
                        return TopicDisplayItem(
                          topicModel: topic,
                          isFromAdmin: topic.type == "type",
                          // isFromAdmin: index % 2 != 0,
                        );
                      },
                    ),
            },
          );
        }));
  }
}
