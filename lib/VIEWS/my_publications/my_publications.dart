// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/MODELS/publication_models/publication_draft.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/publications_providers/publications_providers.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/VIEWS/publication_detail/view_publication_to_download.dart';
import 'package:project_bist/VIEWS/researcher_publish_paper_page/researcher_publish_paper_page.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/drawer_contents.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/loading_indicator.dart';
import 'package:project_bist/WIDGETS/publication_item.dart';
import 'package:project_bist/WIDGETS/publication_three_item.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';

bool hasCalledResearcherPublicationEndpoint = false;

class MyPublicationsScreen extends ConsumerStatefulWidget {
  bool? allowExit;
  MyPublicationsScreen({this.allowExit, super.key});

  static const String myPublicationsScreen = "myPublicationsScreen";

  @override
  ConsumerState<MyPublicationsScreen> createState() =>
      _MyPublicationsScreenState();
}

class _MyPublicationsScreenState extends ConsumerState<MyPublicationsScreen>
    with SingleTickerProviderStateMixin {
  bool hasDone = false;
  late TabController tabController;
  List<String> tabList = ["Posted", "In review", "Drafts", "Bought"];

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  List<Widget> publicationsTabList(
      {required PublicationsList postedPublicationList,
      required PublicationsList boughtPublicationList,
      required ResponseStatus responseStatus,
      required ResponseStatus boughtResponseStatus}) {
    PublicationsList postedPublications =
        postedPublicationList.where((e) => e.status == "posted").toList();

    PublicationsList inReviewPublications =
        postedPublicationList.where((e) => e.status != "posted").toList();
    return [
      ///====================== [POSTED PUBLICATIONS]=================
      switch (responseStatus.responseState!) {
        ResponseState.LOADING =>
          LoadingIndicator(message: "Fetching posted publications..."),
        ResponseState.ERROR => ErrorPage(
            message: responseStatus.message!,
            onPressed: () {
              if (hasCalledResearcherPublicationEndpoint == false &&
                  ref.watch(switchUserProvider) == UserTypes.researcher) {
                ref
                    .watch(publicationsProvider.notifier)
                    .getRequest(
                        context: context,
                        url: Endpoints.RESEARCHERS_PUBLICATIONS,
                        showLoading: false)
                    .then((_) => setState(() {
                          hasCalledResearcherPublicationEndpoint = true;
                        }));
              }
            }),
        ResponseState.DATA => postedPublications.isEmpty
            ? ErrorPage(
                message: "You currently don't have any publication posted!",
                showButton: false,
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: appPadding(),
                child: Column(
                  children: List.generate(postedPublications.length, (index) {
                    PublicationModel postedPublicationItem =
                        postedPublications[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15.sp),
                      child: PublicationItem(
                          width: double.infinity,
                          publicationModel: postedPublicationItem,
                          routeName: ViewPublicationToDownload
                              .viewPublicationToDownload,
                          argument: postedPublicationItem),
                    );
                  }),
                ),
              ),
      },
// SingleChild PublicationThreeItem
      ///=================================== [IN REVIEW PUBLICATIONS] ==================
      switch (responseStatus.responseState!) {
        ResponseState.LOADING =>
          LoadingIndicator(message: "Fetching publications in review..."),
        ResponseState.ERROR => ErrorPage(message: responseStatus.message!),
        ResponseState.DATA => inReviewPublications.isEmpty
            ? ErrorPage(
                message: "You currently don't have any publication in review!",
                showButton: false,
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: appPadding(),
                child: Column(
                  children: List.generate(inReviewPublications.toList().length,
                      (index) {
                    PublicationModel postedPublicationItem =
                        inReviewPublications[index];
                    bool inReview = postedPublicationItem.status == "in-review";
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15.sp),
                      child: PublicationThreeItem(
                          ref: ref,
                          index: index,
                          publicationId: postedPublicationItem.id,
                          routeName: ResearchPublishPaperScreen
                              .researchPublishPaperScreen,
                          arguments: PublicationDraft(
                            type: postedPublicationItem.type,
                            currency: postedPublicationItem.currency,
                            title: postedPublicationItem.title,
                            abstractText: postedPublicationItem.abstractText,
                            numOfRef: postedPublicationItem.numOfRef,
                            price: postedPublicationItem.price,
                            tags: postedPublicationItem.tags ?? [],
                            owners: postedPublicationItem.owners ?? [],
                            attachmentFile:
                                "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
                            doYouHaveCoWorkers:
                                (postedPublicationItem.owners ?? []).isNotEmpty
                                    ? "Yes"
                                    : "No",
                          ),
                          width: double.infinity,
                          title: postedPublicationItem.title,
                          subtitle: Row(
                            children: [
                              TextOf("${postedPublicationItem.type} | ", 12, 4,
                                  color: AppColors.white),
                              Expanded(
                                child: TextOf(
                                    inReview
                                        ? 'Pending Approval'
                                        : "${postedPublicationItem.uniquenessScore}% unique. Failed to meet uniqueness standards",
                                    12,
                                    4,
                                    color: inReview
                                        ? AppColors.yellow
                                        : AppColors.red,
                                    align: TextAlign.left,
                                    textOverflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          backgroundColor: AppColors.primaryColor,
                          titleColor: AppColors.white),
                    );
                  }),
                ),
              ),
      },

      ///===========================[IN DRAFT PUBLICATIONS] ============
      ValueListenableBuilder(
          valueListenable:
              Hive.box<PublicationDraft>(AppConst.PUBLICATION_DRAFT_KEY)
                  .listenable(),
          builder: (context, Box<PublicationDraft> box, _) {
            return box.isEmpty
                ? ErrorPage(
                    message: "No publication saved to draft yet!",
                    showButton: false,
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: appPadding(),
                    child: Column(
                        children: List.generate(box.length, (index) {
                      PublicationDraft publicationDraft =
                          box.values.toList().reversed.toList()[index];
                      return Padding(
                          padding: EdgeInsets.only(bottom: 15.sp),
                          child: PublicationThreeItem(
                            ref: ref,
                            index: index,
                            publicationId: "",
                            backgroundColor: AppColors.brown,
                            title: publicationDraft.title,
                            onTriggered: () {
                              box.deleteAt(index);
                            },
                            routeName: ResearchPublishPaperScreen
                                .researchPublishPaperScreen,
                            arguments: publicationDraft,
                            subtitle: Row(
                              children: [
                                TextOf(publicationDraft.type, 12, 4,
                                    color: AppColors.white),
                              ],
                            ),
                          ));
                      // fnnfk jk gfkj g jgj g
                    })));
          }),

      /// ======================= [BOUGHT PUBLICATIONS]
      switch (boughtResponseStatus.responseState!) {
        ResponseState.LOADING =>
          LoadingIndicator(message: "Fetching bought publications..."),
        ResponseState.ERROR =>
          ErrorPage(message: boughtResponseStatus.message!),
        ResponseState.DATA => boughtPublicationList.isEmpty
            ? ErrorPage(
                message: "You haven't bought any publication yet!",
                showButton: false,
                onPressed: () {
                  ref.watch(buyPublicationsProvider.notifier).getRequest(
                      context: context,
                      url: ref.watch(switchUserProvider) == UserTypes.researcher
                          ? Endpoints.RESEARCHER_BOUGHT_PUBLICATIONS
                          : Endpoints.CLIENTS_BOUGHT_PUBLICATIONS,
                      showLoading: false,
                      inErrorCase: true);
                },
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: appPadding(),
                child: Column(
                  children:
                      List.generate(boughtPublicationList.length, (index) {
                    PublicationModel boughtPublicationItem =
                        boughtPublicationList[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15.sp),
                      child: PublicationItem(
                        width: double.infinity,
                        publicationModel: boughtPublicationItem,
                        routeName:
                            ViewPublicationToDownload.viewPublicationToDownload,
                      ),
                    );
                  }),
                )),
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    ResponseStatus responseStatus = ref.watch(publicationsProvider);
    ResponseStatus responseStatus2 = ref.watch(buyPublicationsProvider);
    ref.watch(buyPublicationsProvider.notifier).getRequest(
        context: context,
        url: ref.watch(switchUserProvider) == UserTypes.researcher
            ? Endpoints.RESEARCHER_BOUGHT_PUBLICATIONS
            : Endpoints.CLIENTS_BOUGHT_PUBLICATIONS,
        showLoading: false);
    if (hasCalledResearcherPublicationEndpoint == false &&
        ref.watch(switchUserProvider) == UserTypes.researcher) {
      ref
          .watch(publicationsProvider.notifier)
          .getRequest(
              context: context,
              url: Endpoints.RESEARCHERS_PUBLICATIONS,
              showLoading: false)
          .then((_) => setState(() {
                hasCalledResearcherPublicationEndpoint = true;
              }));
    }

    List<dynamic>? publicationsList = responseStatus.data;
    getIt<AppModel>().postedPublicationList =
        publicationsList?.map((e) => PublicationModel.fromJson(e)).toList();
    PublicationsList postedPublicationList =
        getIt<AppModel>().postedPublicationList ?? [];

    List<dynamic>? publicationList2 = responseStatus2.data;
    getIt<AppModel>().boughtPublicationList =
        publicationList2?.map((e) => PublicationModel.fromJson(e)).toList();
    PublicationsList boughtPublicationsList =
        getIt<AppModel>().boughtPublicationList ?? [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    return Scaffold(
        drawer: const DrawerContents(),
        appBar: customAppBar(context,
            hasIcon: true,
            hasElevation: true,
            scale: 1.25.sp,
            title: "My Publications", leading: Builder(builder: (context) {
          return InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const IconOf(Icons.menu, color: AppColors.primaryColor),
          );
        }),
            tabBar: ref.watch(switchUserProvider) != UserTypes.researcher
                ? null
                : TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: const BoxDecoration(),
                    physics: const ClampingScrollPhysics(),
                    indicatorPadding: EdgeInsets.only(bottom: 5.sp),
                    labelPadding: EdgeInsets.symmetric(horizontal: 5.sp),
                    dividerHeight: 0,
                    padding: EdgeInsets.symmetric(horizontal: 10.sp)
                        .copyWith(bottom: 0),
                    controller: tabController,
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.grey3,
                    tabs: tabList
                        .map((e) => Tab(
                              child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 5.sp),
                                  decoration: BoxDecoration(
                                      color: tabController.index ==
                                              tabList.indexOf(e)
                                          ? AppColors.primaryColor
                                          : AppThemeNotifier.themeColor(context)
                                              .scaffoldBackgroundColor,
                                      border: Border.all(
                                          color: tabController.index ==
                                                  tabList.indexOf(e)
                                              ? AppColors.primaryColor
                                              : AppColors.grey3),
                                      borderRadius:
                                          BorderRadius.circular(20.sp)),
                                  // padding:
                                  //     EdgeInsets.symmetric(horizontal: 20.sp),
                                  child: TextOf(
                                    e,
                                    12.sp,
                                    4,
                                    color: tabController.index ==
                                            tabList.indexOf(e)
                                        ? AppColors.white
                                        : AppThemeNotifier.colorScheme(context)
                                            .primary,
                                  )),
                            ))
                        .toList())),
        body: Builder(builder: (context) {
          return PopScope(
            canPop: widget.allowExit ?? false,
            onPopInvoked: (widget.allowExit ?? false) == false
                ? (value) {
                    Scaffold.of(context).openDrawer();
                  }
                : null,
            child: ref.watch(switchUserProvider) != UserTypes.researcher
                ? switch (responseStatus2.responseState!) {
                    ResponseState.LOADING => LoadingIndicator(
                        message: "Fetching bought publications..."),
                    ResponseState.ERROR =>
                      ErrorPage(message: responseStatus2.message!),
                    ResponseState.DATA => boughtPublicationsList.isEmpty
                        ? ErrorPage(
                            message: "You haven't bought any publication yet!",
                            showButton: false,
                            onPressed: () {
                              ref
                                  .watch(buyPublicationsProvider.notifier)
                                  .getRequest(
                                      context: context,
                                      url: ref.watch(switchUserProvider) ==
                                              UserTypes.researcher
                                          ? Endpoints
                                              .RESEARCHER_BOUGHT_PUBLICATIONS
                                          : Endpoints
                                              .CLIENTS_BOUGHT_PUBLICATIONS,
                                      showLoading: false,
                                      inErrorCase: true);
                            },
                          )
                        : SingleChildScrollView(
                            padding: appPadding(),
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: List.generate(
                                  boughtPublicationsList.length, (index) {
                                PublicationModel publicationModel =
                                    boughtPublicationsList[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 15.sp),
                                  child: PublicationItem(
                                    width: double.infinity,
                                    publicationModel: publicationModel,
                                    argument: publicationModel,
                                    routeName: ViewPublicationToDownload
                                        .viewPublicationToDownload,
                                  ),
                                );
                              }),
                            ),
                          )
                  }
                : TabBarView(
                    physics: const ClampingScrollPhysics(),
                    controller: tabController,
                    children: publicationsTabList(
                        postedPublicationList: postedPublicationList,
                        boughtPublicationList: boughtPublicationsList,
                        boughtResponseStatus: responseStatus2,
                        responseStatus: responseStatus)),
          );
        }));
  }
}
