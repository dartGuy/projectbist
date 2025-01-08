// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_with_submission_paln_model.dart';
import 'package:project_bist/MODELS/job_model/job_model.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/MODELS/topics_model/explore_topics_model.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';
import 'package:project_bist/PROVIDERS/jobs_provider/jobs_provider.dart';
import 'package:project_bist/PROVIDERS/profile_provider/profile_provider.dart';
import 'package:project_bist/PROVIDERS/publications_providers/publications_providers.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/PROVIDERS/topic_providers/clients_provider.dart';
import 'package:project_bist/PROVIDERS/topic_providers/topic_providers.dart';
import 'package:project_bist/PROVIDERS/transaction_providers/transaction_providers/transaction_providers.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/VIEWS/add_new_project_flow/add_new_project_flow.dart';
import 'package:project_bist/VIEWS/job_description_pages/clients_job_description.dart';
import 'package:project_bist/VIEWS/topics_list_preview_screen/topics_list_preview_screen.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/components/app_components.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/topic_display_items.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/loading_indicator.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import "package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart";
import "package:el_tooltip/el_tooltip.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../PROVIDERS/_base_provider/response_status.dart';

class ClientHomePage extends ConsumerStatefulWidget {
  static const String clientHomePage = "clientHomePage";
  ClientHomePage({required this.callback, super.key});
  @override
  ConsumerState<ClientHomePage> createState() => _ClientHomePageState();

  VoidCallback callback;
}

class _ClientHomePageState extends ConsumerState<ClientHomePage> {
  bool hasDone = false;
  bool isTrue = true;
  @override
  Widget build(BuildContext context) {
    ResponseStatus responseStatusOfPublication =
            ref.watch(generalPublicationsProvider),
        responseStatusTopic = ref.watch(topicsProvider),
        responseStatusOfProfile = ref.watch(profileProvider),
        responseMyJobsList = ref.watch(userJobsProvider),
        responseStatusOfWalletTransactions = ref.watch(transactionProvider);

    /// ===============================[ESCROW HANDLER]=====================
    /// ===============================[ESCROW HANDLER]=====================

    ref.read(escrowsProvider.notifier).getRequest(
        context: context,
        url: Endpoints.FETCH_ESCROWS("client"),
        showLoading: false);
    ResponseStatus responseStatusOfEscrow = ref.watch(escrowsProvider);
    List<dynamic>? rawEscrowsList = responseStatusOfEscrow.data;
    getIt<AppModel>().escrowWithSubmissionPlanList = rawEscrowsList
        ?.map((e) => EscrowWithSubmissionPlanModel.fromJson(e))
        .toList()
        .where((e) => e.jobId != null)
        .toList();
    ref.watch(generalPublicationsProvider.notifier).getRequest(
        context: context,
        url: Endpoints.GENERAL_PUBLICATIONS_LIST,
        showLoading: false);
    ref.watch(userJobsProvider.notifier).getRequest(
        context: context,
        url: Endpoints.CLIENTS_POSTED_JOBS_FETCH,
        showLoading: false);
    ref.watch(profileProvider.notifier).getRequest(
        context: context, url: Endpoints.GET_PROFILE, showLoading: false);
    // print(getIt<AppModel>().topicsList?.length);
    getIt<AppModel>().userProfile =
        UserProfile.fromJson(responseStatusOfProfile.data);
    ref
        .watch(topicsProvider.notifier)
        .getRequest(
            context: context, url: Endpoints.FETCH_TOPICS, showLoading: false)
        .then((value) {});

    if (getIt<AppModel>().userProfile!.identityVerified == true) {
      ref.read(transactionProvider.notifier).getRequest(
          context: context, url: Endpoints.FETCH_WALLET, showLoading: false);
    }

    List<dynamic>? publicationsList = responseStatusOfPublication.data;
    getIt<AppModel>().generalPublicationList =
        publicationsList?.map((e) => PublicationModel.fromJson(e)).toList();
    PublicationsList generalPublicationList = getIt<AppModel>()
            .generalPublicationList
            ?.where((e) => e.status != "posted")
            .toList() ??
        [];

    getIt<AppModel>().appCacheBox!.put(AppConst.USER_WALLET_BALANCE,
        responseStatusOfWalletTransactions.data?["amount"]);

    List<dynamic>? topics = responseStatusTopic.data;
    topics = topics?.where((e) => e["researcherId"] != null).toList();
    getIt<AppModel>().topicsList =
        topics?.map((e) => ExploreTopicsModel.fromJson(e)).toList() ?? [];
    String errorMessage = "";

    if (responseStatusOfPublication.message != null) {
      errorMessage +=
          "Publications Error: ${responseStatusOfPublication.message}\n";
    }
    if (responseStatusOfEscrow.message != null) {
      errorMessage += "Escrow Error: ${responseStatusOfEscrow.message}\n";
    }
    if (responseStatusOfProfile.message != null) {
      errorMessage += "Profile Error: ${responseStatusOfProfile.message}\n";
    }

    if (responseMyJobsList.message != null) {
      errorMessage += "Jobs Error: ${responseMyJobsList.message}\n";
    }

    if (responseStatusTopic.message != null) {
      errorMessage += "Topic Error: ${responseStatusTopic.message}\n";
    }

    if (responseStatusOfWalletTransactions.message != null) {
      errorMessage +=
          "Wallet Error: ${responseStatusOfWalletTransactions.message}\n";
    }

    if (responseStatusTopic.responseState == ResponseState.DATA &&
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
    }

    UserProfile userProfile = getIt<AppModel>().userProfile!;
    getIt<AppModel>().appCacheBox!.put(AppConst.BACKEND_VERIFIED_USER,
        getIt<AppModel>().userProfile!.identityVerified ?? false);
    List<dynamic>? rawClientsJobList = responseMyJobsList.data;
    getIt<AppModel>().myJobsList =
        rawClientsJobList?.map((e) => JobModel.fromJson(e)).toList();
    MyJobsList myJobsList = getIt<AppModel>().myJobsList ?? [];

if(responseStatusTopic.responseState == ResponseState.DATA &&
                    responseStatusOfPublication.responseState ==
                        ResponseState.DATA &&
                    responseStatusOfProfile.responseState ==
                        ResponseState.DATA &&
                   responseStatusOfWalletTransactions.responseState ==
                            ResponseState.DATA &&
                    responseMyJobsList.responseState == ResponseState.DATA &&
                    responseStatusOfEscrow.responseState! ==
                        ResponseState.DATA){
                      AppConst.HOME_PAGE_LOADED = true;
widget.callback();
} else{
  AppConst.HOME_PAGE_LOADED = false;
}
    return Scaffold(
        body: (responseStatusTopic.responseState == ResponseState.ERROR ||
                responseStatusOfPublication.responseState ==
                    ResponseState.ERROR ||
                responseStatusOfEscrow.responseState! ==
                    ResponseState.ERROR ||
                responseStatusOfProfile.responseState == ResponseState.ERROR ||
                responseMyJobsList.responseState == ResponseState.ERROR ||
                (getIt<AppModel>().userProfile!.identityVerified == true
                    ? responseStatusOfWalletTransactions.responseState ==
                        ResponseState.ERROR
                    : isTrue == false))
            ? ErrorPage(
                message: errorMessage,
                onPressed: () {
                  if (ref.watch(generalPublicationsProvider).responseState ==
                      ResponseState.ERROR) {
                    ref.watch(generalPublicationsProvider.notifier).getRequest(
                        context: context,
                        url: Endpoints.GENERAL_PUBLICATIONS_LIST,
                        showLoading: false,
                        inErrorCase: true);
                  }

                  if (ref.watch(topicsProvider).responseState ==
                      ResponseState.ERROR) {
                    ref.watch(topicsProvider.notifier).getRequest(
                        context: context,
                        url: Endpoints.FETCH_TOPICS,
                        showLoading: false,
                        inErrorCase: true);
                  }
                  if (ref.watch(profileProvider).responseState ==
                      ResponseState.ERROR) {
                    ref.watch(profileProvider.notifier).getRequest(
                        context: context,
                        url: Endpoints.GET_PROFILE,
                        showLoading: false,
                        inErrorCase: true);
                  }

                  if (ref.watch(userJobsProvider).responseState ==
                      ResponseState.ERROR) {
                    ref.watch(userJobsProvider.notifier).getRequest(
                        context: context,
                        url: Endpoints.CLIENTS_POSTED_JOBS_FETCH,
                        showLoading: false,
                        inErrorCase: true);
                  }

                  if (ref.read(transactionProvider).responseState ==
                      ResponseState.ERROR) {
                    ref.read(transactionProvider.notifier).getRequest(
                        context: context,
                        url: Endpoints.FETCH_WALLET,
                        showLoading: false,
                        inErrorCase: true) ;
                  }
                  if(ref.read(escrowsProvider).responseState ==
                      ResponseState.ERROR){
ref.read(escrowsProvider.notifier).getRequest(
        context: context,
        url: Endpoints.FETCH_ESCROWS("client"),
        showLoading: false,
                        inErrorCase: true);
                      }
                })

            // responseMyJobsList = ref.watch(userJobsProvider),
            : (responseStatusTopic.responseState == ResponseState.LOADING ||
                    responseStatusOfPublication.responseState ==
                        ResponseState.LOADING ||
                    responseStatusOfProfile.responseState ==
                        ResponseState.LOADING ||
                    (getIt<AppModel>().userProfile!.identityVerified == true
                        ? responseStatusOfWalletTransactions.responseState ==
                            ResponseState.LOADING
                        : isTrue == false) ||
                    responseMyJobsList.responseState == ResponseState.LOADING ||
                    responseStatusOfEscrow.responseState! ==
                        ResponseState.LOADING)
                ? LoadingIndicator(message: "Please wait a moment...")
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: appPadding(),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: TextOf(
                                    "Hello, ${userProfile.username}!",
                                    24.sp,
                                    6,
                                    align: TextAlign.left,
                                  )),
                                ],
                              ),
                              YMargin(12.sp),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: ref.watch(switchUserProvider) ==
                                            UserTypes.student
                                        ? 10
                                        : 7,
                                    child: SizedBox(
                                      height: 48.sp,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          backgroundColor: AppColors.brown,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            TopicsListPreviewScreen
                                                .topicsListPreviewScreen,
                                            arguments: false,
                                          );
                                        },
                                        child: TextOf(
                                          "Explore",
                                          16,
                                          5,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1, child: SizedBox.shrink()),
                                  Expanded(
                                    flex: 10,
                                    child: SizedBox(
                                        height: 48.sp,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              backgroundColor:
                                                  AppColors.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                AddNewProjectFlow
                                                    .addNewProjectFlow,
                                                arguments:
                                                    AddNewProjectFlowArgument(
                                                  index: 0,
                                                  transactionCompletedFlow:
                                                      true,
                                                ),
                                              );
                                            },
                                            child: ref.watch(
                                                        switchUserProvider) ==
                                                    UserTypes.professional
                                                ? TextOf("Post Job", 16, 5,
                                                    color: AppColors.white)
                                                : SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextOf("Get Assistance",
                                                            16, 5,
                                                            color: AppColors
                                                                .white),
                                                        XMargin(5.sp),
                                                        ElTooltip(
                                                          color: AppThemeNotifier
                                                                  .themeColor(
                                                                      context)
                                                              .scaffoldBackgroundColor,
                                                          position:
                                                              ElTooltipPosition
                                                                  .bottomEnd,
                                                          content: TextOf(
                                                            "Get assistance with the remaining of your research project that is needed to be done from a researcher.",
                                                            10,
                                                            4,
                                                            align:
                                                                TextAlign.left,
                                                          ),
                                                          child: const IconOf(
                                                            Icons
                                                                .info_outline_rounded,
                                                            color:
                                                                AppColors.white,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ))),
                                  )
                                ],
                              ),
                              // YMargin(16.sp),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 0.4,
                          color: AppColors.grey4,
                        ),
                        Container(
                          padding: appPadding().copyWith(top: 1, bottom: 0),
                          child: Column(children: [
                            Row(children: [
                              TextOf(
                                  "Posted Jobs (${myJobsList.length})", 14, 4)
                            ]),
                            YMargin(ref.watch(switchUserProvider) ==
                                    UserTypes.student
                                ? 10.sp
                                : 14),
                            myJobsList.isEmpty
                                ? Row(
                                    children: [
                                      Expanded(
                                          child: TextOf(
                                              "You don’t have any jobs posted yet!",
                                              18.sp,
                                              4,
                                              align: TextAlign.left)),
                                    ],
                                  )
                                : Column(
                                    children: List.generate(myJobsList.length,
                                        (index) {
                                      JobModel jobModel = myJobsList[index];
                                      return Column(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(20.sp),
                                              decoration: BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r)),
                                              width: double.infinity,
                                              child: Column(children: [
                                                Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          flex: 8,
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  ClientsJobDescription
                                                                      .clientsJobDescription,
                                                                  arguments:
                                                                      jobModel);
                                                            },
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                TextOf(
                                                                    jobModel
                                                                        .jobName!,
                                                                    16,
                                                                    6,
                                                                    color: AppColors
                                                                        .white),
                                                                YMargin(16.sp),
                                                                Row(
                                                                  children: [
                                                                    TextOf(
                                                                        "${(jobModel.researcherApplicantsData ?? []).length} Applicant${(jobModel.researcherApplicantsData ?? []).length == 1 ? "" : "s"}  •  ${jobModel.createdAt!}",
                                                                        12.sp,
                                                                        4,
                                                                        color: AppColors
                                                                            .white),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                      Expanded(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              AppComponents.confirmDeleteInListPopup(
                                                                  context,
                                                                  index,
                                                                  ref,
                                                                  popupTitle:
                                                                      "Delete job",
                                                                  deletionButtonText:
                                                                      "Delete This Job",
                                                                  textColor:
                                                                      AppColors
                                                                          .white,
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .red,
                                                                  onPrimaryDeletePressed:
                                                                      () {
                                                                JobsProvider
                                                                    .clientDeleteJob(
                                                                        context,
                                                                        ref,
                                                                        jobId: jobModel
                                                                            .id!);
                                                              },
                                                                  deletionDescriptionText:
                                                                      "Clicking the delete button will remove this job from your list and the this can't be undone. So please, proceed with caution");
                                                            },
                                                            child: const IconOf(
                                                              Icons
                                                                  .more_vert_outlined,
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                    ]),
                                              ])),

                                          // InkWell(
                                          //   onTap: () {
                                          //     Navigator.pushNamed(
                                          //         context,
                                          //         ClientsJobDescription
                                          //             .clientsJobDescription,
                                          //         arguments: jobModel);
                                          //   },
                                          //   child: Container(
                                          //       padding: EdgeInsets.all(20.sp),
                                          //       decoration: BoxDecoration(
                                          //           color:
                                          //               AppColors.primaryColor,
                                          //           borderRadius:
                                          //               BorderRadius.circular(
                                          //                   10.r)),
                                          //       width: double.infinity,
                                          //       child: Column(children: [
                                          //         Row(
                                          //             mainAxisAlignment:
                                          //                 MainAxisAlignment
                                          //                     .spaceBetween,
                                          //             children: [
                                          //               TextOf(
                                          //                   jobModel.jobName!,
                                          //                   16,
                                          //                   6,
                                          //                   color: AppColors
                                          //                       .white),
                                          //               Tooltip(
                                          //                 message: 'Delete job',
                                          //                 preferBelow: false,
                                          //                 waitDuration:
                                          //                     const Duration(
                                          //                         seconds: 4),
                                          //                 padding: EdgeInsets
                                          //                     .symmetric(
                                          //                         horizontal:
                                          //                             20.sp,
                                          //                         vertical:
                                          //                             15.sp),
                                          //                 textStyle: TextStyle(
                                          //                     fontSize: 16.sp,
                                          //                     color: AppThemeNotifier
                                          //                             .colorScheme(
                                          //                                 context)
                                          //                         .onPrimary,
                                          //                     fontWeight:
                                          //                         FontWeight
                                          //                             .w400),
                                          //                 decoration: BoxDecoration(
                                          //                     boxShadow: <BoxShadow>[
                                          //                       BoxShadow(
                                          //                           offset:
                                          //                               const Offset(
                                          //                                   0,
                                          //                                   1),
                                          //                           blurRadius:
                                          //                               2.r,
                                          //                           color: isDarkTheme(
                                          //                                   context)
                                          //                               ? AppColors
                                          //                                   .grey3
                                          //                               : AppColors
                                          //                                   .grey1,
                                          //                           spreadRadius:
                                          //                               0.1.sp)
                                          //                     ],
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 10.r),
                                          //                     color: AppThemeNotifier
                                          //                             .colorScheme(
                                          //                                 context)
                                          //                         .primary),
                                          //                 child: const IconOf(
                                          //                   Icons
                                          //                       .more_vert_outlined,
                                          //                   color:
                                          //                       AppColors.white,
                                          //                 ),
                                          //               )
                                          //             ]),
                                          //         YMargin(16.sp),
                                          //         Row(
                                          //           children: [
                                          //             TextOf(
                                          //                 "${jobModel.numberOfApplications} Applicant${jobModel.numberOfApplications == 1 ? "" : "s"}" +
                                          //                     "  •  " +
                                          //                     jobModel
                                          //                         .createdAt!,
                                          //                 12.sp,
                                          //                 4,
                                          //                 color:
                                          //                     AppColors.white),
                                          //           ],
                                          //         )
                                          //       ])),
                                          // ),

                                          YMargin(
                                              index == (myJobsList.length - 1)
                                                  ? 8.sp
                                                  : 16.sp)
                                        ],
                                      );
                                    }),
                                  )
                          ]),
                        ),
                        Column(
                          children: [
                            AppDivider(),
                            // AppComponents.topicsListSections(
                            //     context, getIt<AppModel>().topicsList ?? []),
                            Padding(
                              padding: appPadding()
                                  .copyWith(top: 8.sp, bottom: 8.sp),
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextOf("Topics", 14.sp, 4),
                                        Expanded(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          TopicsListPreviewScreen
                                                              .topicsListPreviewScreen);
                                                    },
                                                    child: TextOf(
                                                      "View all",
                                                      12,
                                                      4,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: AppColors.brown,
                                                    ),
                                                  ),
                                                  XMargin(5.sp),
                                                  IconOf(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      color: AppColors.brown,
                                                      size: 15.sp)
                                                ],
                                              )
                                            ]))
                                      ]),
                                  YMargin(16.sp),
                                  ...List.generate(
                                      (getIt<AppModel>().topicsList ?? [])
                                                  .length >
                                              2
                                          ? 2
                                          : (getIt<AppModel>().topicsList ?? [])
                                              .length,
                                      (index) => TopicDisplayItem(
                                            hasDivider: true,
                                            isFromAdmin:
                                                (getIt<AppModel>().topicsList ??
                                                            [])[index]
                                                        .type ==
                                                    "admin",
                                            topicModel:
                                                (getIt<AppModel>().topicsList ??
                                                    [])[index],
                                          ))
                                ],
                              ),
                            ),
                            AppComponents.publicationsListSections(context,
                                publicationList: generalPublicationList),
                          ],
                        )
                      ],
                    ),
                  ));
  }
}

class ResponseTopicAndPublicationStatus {
  final ResponseStatus topicResponseStatus, publicationResponseStatus;
  ResponseTopicAndPublicationStatus(
      {required this.topicResponseStatus,
      required this.publicationResponseStatus});
}
