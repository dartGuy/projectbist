import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/escrow_details.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_with_submission_paln_model.dart';
import 'package:project_bist/MODELS/job_model/job_model.dart';
import 'package:project_bist/MODELS/job_model/reseracher_job_model.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/jobs_provider/jobs_provider.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/VIEWS/job_description_pages/clients_job_description.dart';
import 'package:project_bist/VIEWS/job_description_pages/job_description_page.dart';
import 'package:project_bist/WIDGETS/components/app_components.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/drawer_contents.dart';

import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/escrow_item_card.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/loading_indicator.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';

class MyJosbAndEscrowFlow extends ConsumerStatefulWidget {
  static const String myJosbAndEscrowFlow = "myJosbAndEscrowFlow";
  const MyJosbAndEscrowFlow({super.key});

  @override
  ConsumerState<MyJosbAndEscrowFlow> createState() =>
      _MyJosbAndEscrowFlowState();
}

class _MyJosbAndEscrowFlowState extends ConsumerState<MyJosbAndEscrowFlow> {
  int currentEscrowStatusIndex = 0;
  MyJobsList myJobsList = getIt<AppModel>().myJobsList ?? [];
  bool hasCalled = false;
  @override
  Widget build(BuildContext context) {
    ResponseStatus responseStatusOfEscrow = ref.watch(escrowsProvider);
    ResponseStatus responseStatusOfResearcherAppliedJobs =
        ref.watch(researcherAppliedJobsProvider);

    ref.read(escrowsProvider.notifier).getRequest(
        context: context,
        url: Endpoints.FETCH_ESCROWS(
            ref.watch(switchUserProvider) == UserTypes.researcher
                ? "researcher"
                : "client"),
        showLoading: false);

    if (ref.watch(switchUserProvider) == UserTypes.researcher &&
        responseStatusOfResearcherAppliedJobs.responseState ==
            ResponseState.LOADING) {
      ref.read(researcherAppliedJobsProvider.notifier).getRequest(
          context: context,
          url: Endpoints.RESEARCHER_APPLIED_JOBS,
          showLoading: false);
    }

      List<dynamic>? rawEscrowsList = responseStatusOfEscrow.data;
      getIt<AppModel>().escrowWithSubmissionPlanList = rawEscrowsList
        ?.map((e) => EscrowWithSubmissionPlanModel.fromJson(e))
        .toList()
        .where((e) => e.jobId != null)
        .toList();
    EscrowWithSubmissionPlanList escrowList =
        getIt<AppModel>().escrowWithSubmissionPlanList ?? [];

    List<dynamic>? rawResearcherAppliedJobsList =
        responseStatusOfResearcherAppliedJobs.data;
    getIt<AppModel>().researcherAppliedJobsList = rawResearcherAppliedJobsList
        ?.map((e) => ResearcherJobModel.fromJson(Map.from(e)))
        .toList();
    ResearcherAppliedJobsList researcherAppliedJobsList =
        getIt<AppModel>().researcherAppliedJobsList ?? [];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer:const DrawerContents(),
        appBar: customAppBar(
          context,
          title: "My Jobs",
          hasIcon: true,
          scale: 1.25.sp,
          leading: Builder(builder: (context) {
            return InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const IconOf(
                Icons.menu,
                color: AppColors.primaryColor,
              ),
            );
          }),
          tabBar: TabBar(
              physics: const ClampingScrollPhysics(),
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: const EdgeInsets.all(0),
              indicatorPadding: const EdgeInsets.all(0),
              labelColor: AppThemeNotifier.colorScheme(context).primary,
              labelStyle:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
              unselectedLabelColor:
                  AppThemeNotifier.colorScheme(context).primary,
              padding: const EdgeInsets.all(0),
              tabs: [
                "${ref.watch(switchUserProvider) == UserTypes.researcher ? "Applied" : "Posted"} Jobs",
                "Escrow",
              ]
                  .map((e) => Tab(
                        height: 30.sp,
                        text: e,
                      ))
                  .toList()),
        ),
        body: Builder(builder: (context) {
          return PopScope(
            canPop: false,
            onPopInvoked: (value) {
              Scaffold.of(context).openDrawer();
            },
            child: TabBarView(children: [
              SingleChildScrollView(
                padding: appPadding().copyWith(top: 10),
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  if (ref.watch(switchUserProvider) != UserTypes.researcher)
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
                            children: List.generate(myJobsList.length, (index) {
                              JobModel jobModel = myJobsList[index];
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context,
                                          ClientsJobDescription
                                              .clientsJobDescription,
                                          arguments: jobModel);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(20.sp),
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10.r)),
                                        width: double.infinity,
                                        child: Column(children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextOf(jobModel.jobName!, 16, 6,
                                                    color: AppColors.white),
                                                Tooltip(
                                                  message: 'Delete job',
                                                  preferBelow: false,
                                                  waitDuration: const Duration(
                                                      seconds: 4),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.sp,
                                                      vertical: 15.sp),
                                                  textStyle: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: AppThemeNotifier
                                                              .colorScheme(
                                                                  context)
                                                          .onPrimary,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  decoration: BoxDecoration(
                                                      boxShadow: <BoxShadow>[
                                                        BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    0, 1),
                                                            blurRadius: 2.r,
                                                            color: isDarkTheme(
                                                                    context)
                                                                ? AppColors
                                                                    .grey3
                                                                : AppColors
                                                                    .grey1,
                                                            spreadRadius:
                                                                0.1.sp)
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r),
                                                      color: AppThemeNotifier
                                                              .colorScheme(
                                                                  context)
                                                          .primary),
                                                  child: const IconOf(
                                                    Icons.more_vert_outlined,
                                                    color: AppColors.white,
                                                  ),
                                                )
                                              ]),
                                          YMargin(16.sp),
                                          Row(
                                            children: [
                                              TextOf(
                                                  "${jobModel.numberOfApplications} Applicant${jobModel.numberOfApplications == 1 ? "" : "s"} • ${jobModel.createdAt!}",
                                                  12.sp,
                                                  4,
                                                  color: AppColors.white),
                                            ],
                                          )
                                        ])),
                                  ),
                                  YMargin(index == (myJobsList.length - 1)
                                      ? 8.sp
                                      : 16.sp)
                                ],
                              );
                            }),
                          ),

                  if (ref.watch(switchUserProvider) == UserTypes.researcher)
                    switch (
                        responseStatusOfResearcherAppliedJobs.responseState) {
                      ResponseState.ERROR => ErrorPage(
                          message:
                              responseStatusOfResearcherAppliedJobs.message!),
                      ResponseState.LOADING => Column(children: [
                          YMargin(0.35.sh),
                          LoadingIndicator(
                              message: "Fetching your applied jobs..."),
                        ]),
                      ResponseState.DATA => researcherAppliedJobsList.isEmpty
                          ? Column(
                              children: [
                                YMargin(0.2.sh),
                                ErrorPage(
                                    message:
                                        "You haven't applied to any job yet!",
                                    showButton: false),
                              ],
                            )
                          : Column(
                              children: List.generate(
                                  researcherAppliedJobsList.length, (index) {
                                ResearcherJobModel jobModel =
                                    researcherAppliedJobsList[index];
                                return Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(20.sp),
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10.r)),
                                        width: double.infinity,
                                        child: Column(children: [
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                            JobDescriptionPage
                                                                .jobDescriptionPage,
                                                            arguments: JobDescriptionPageArgument(
                                                                hasApplied:
                                                                    true,
                                                                researcherJobModel:
                                                                    jobModel));
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextOf(
                                                              jobModel.jobName,
                                                              16,
                                                              6,
                                                              color: AppColors
                                                                  .white),
                                                          YMargin(16.sp),
                                                          Row(
                                                            children: [
                                                              TextOf(
                                                                  "${jobModel.numberOfApplications} Applicant${jobModel.numberOfApplications == 1 ? "" : "s"}  •  ${jobModel
                                                                          .createdAt}",
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
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        if (ref.watch(
                                                                switchUserProvider) ==
                                                            UserTypes
                                                                .researcher) {
                                                          JobsProvider
                                                              .researcherWithdrawApplication(
                                                                  context, ref,
                                                                  jobId:
                                                                      jobModel
                                                                          .id);
                                                        } else {
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
                                                                  AppColors.red,
                                                              onPrimaryDeletePressed:
                                                                  () {
                                                            JobsProvider
                                                                .clientDeleteJob(
                                                                    context,
                                                                    ref,
                                                                    jobId:
                                                                        jobModel
                                                                            .id);
                                                          },
                                                              deletionDescriptionText:
                                                                  "Clicking the delete button will remove this job from your list and the this can't be undone. So please, proceed with caution");
                                                        }
                                                      },
                                                      child: const IconOf(
                                                        Icons
                                                            .more_vert_outlined,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                              ]),
                                        ])),
                                    YMargin(index == (myJobsList.length - 1)
                                        ? 8.sp
                                        : 16.sp)
                                  ],
                                );
                              }),
                            ),
                      _ => Container()
                    }
                  // if (ref.watch(switchUserProvider) == UserTypes.researcher)
                  //   ...List.generate(
                  //       2,
                  //       (index) => Column(
                  //             children: [
                  //               InkWell(
                  //                 onTap: () {
                  //                   Navigator.pushNamed(
                  //                       context,
                  //                       ref.watch(switchUserProvider) ==
                  //                               UserTypes.researcher
                  //                           ? JobDescriptionPage.jobDescriptionPage
                  //                           : ClientsJobDescription
                  //                               .clientsJobDescription,
                  //                       arguments: ref.watch(switchUserProvider) ==
                  //                               UserTypes.researcher
                  //                           ? null
                  //                           : null);
                  //                 },
                  //                 child: Container(
                  //                     padding: EdgeInsets.all(20.sp),
                  //                     decoration: BoxDecoration(
                  //                         color: AppColors.primaryColor,
                  //                         borderRadius:
                  //                             BorderRadius.circular(10.r)),
                  //                     width: double.infinity,
                  //                     child: Column(children: [
                  //                       Row(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.spaceBetween,
                  //                           children: [
                  //                             TextOf(
                  //                                 index == 0
                  //                                     ? "Final Year Project A"
                  //                                     : "My Thesis",
                  //                                 16,
                  //                                 6,
                  //                                 color: AppColors.white),
                  //                             Tooltip(
                  //                               message: 'Delete job',
                  //                               preferBelow: false,
                  //                               waitDuration:
                  //                                   const Duration(seconds: 4),
                  //                               padding: EdgeInsets.symmetric(
                  //                                   horizontal: 20.sp,
                  //                                   vertical: 15.sp),
                  //                               textStyle: TextStyle(
                  //                                   fontSize: 16.sp,
                  //                                   color: AppThemeNotifier
                  //                                           .colorScheme(context)
                  //                                       .primary,
                  //                                   fontWeight: FontWeight.w400),
                  //                               decoration: BoxDecoration(
                  //                                   boxShadow: <BoxShadow>[
                  //                                     BoxShadow(
                  //                                         offset:
                  //                                             const Offset(0, 1),
                  //                                         blurRadius: 2.r,
                  //                                         color: AppColors.white,
                  //                                         spreadRadius: 0.1.sp)
                  //                                   ],
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(10.r),
                  //                                   color: AppThemeNotifier
                  //                                           .themeColor(context)
                  //                                       .scaffoldBackgroundColor),
                  //                               child: const IconOf(
                  //                                 Icons.more_vert_outlined,
                  //                                 color: AppColors.white,
                  //                               ),
                  //                             )
                  //                           ]),
                  //                       YMargin(16.sp),
                  //                       Row(
                  //                         children: [
                  //                           TextOf("3 Applicants", 12, 4,
                  //                               color: AppColors.white),
                  //                         ],
                  //                       )
                  //                     ])),
                  //               ),
                  //               YMargin(index == 1 ? 8.sp : 16.sp)
                  //             ],
                  //           )),
                ]),
              ),
              switch (responseStatusOfEscrow.responseState) {
                ResponseState.LOADING =>
                  LoadingIndicator(message: "Fetching your escrows..."),
                ResponseState.ERROR => ErrorPage(
                    message: responseStatusOfEscrow.message ?? "Error occurred",
                    onPressed: () {
                      ref.read(escrowsProvider.notifier).getRequest(
                          context: context,
                          url: Endpoints.FETCH_ESCROWS(
                              ref.watch(switchUserProvider) ==
                                      UserTypes.researcher
                                  ? "researcher"
                                  : "client"),
                          showLoading: false,
                          inErrorCase: true);
                    },
                  ),
                _ => clientEscrowPage(escrowList: escrowList)
              }
            ]),
          );
        }),
      ),
    );
  }

  String whatStatusContains = "";

  clientEscrowPage({required EscrowWithSubmissionPlanList escrowList}) {
    EscrowWithSubmissionPlanList escrows =
        escrowList.where((e) => e.status.contains(whatStatusContains)).toList();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(children: [
        Column(
          children: [
            Padding(
              padding: appPadding().copyWith(top: 10.sp, bottom: 5.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    4,
                    (index) => InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            currentEscrowStatusIndex = index;
                            whatStatusContains = switch (index) {
                              0 => "",
                              1 => "completed",
                              2 => "ongoing",
                              3 => "paused",
                              _ => ""
                            };
                          });
                        },
                        child: Container(
                          height: 31.sp,
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: currentEscrowStatusIndex == index
                                      ? AppColors.primaryColor
                                      : AppColors.grey1),
                              borderRadius: BorderRadius.circular(20.r),
                              color: currentEscrowStatusIndex == index
                                  ? AppColors.primaryColor
                                  : AppThemeNotifier.themeColor(context)
                                      .scaffoldBackgroundColor),
                          child: Center(
                            child: TextOf(
                              ["All", "Completed", "Ongoing", "Paused"][index],
                              12.sp,
                              4,
                              color: currentEscrowStatusIndex == index
                                  ? AppColors.white
                                  : AppThemeNotifier.colorScheme(context)
                                              .primary ==
                                          AppColors.white
                                      ? AppColors.grey1
                                      : AppColors.grey3,
                            ),
                          ),
                        ))),
              ),
            ),
            // AppDivider()
          ],
        ),
        YMargin(10.sp),
        if (escrows.isEmpty)
          Column(
            children: [
              YMargin(0.15.sh),
              ErrorPage(
                  message: switch (currentEscrowStatusIndex) {
                    0 => "You currently don't have any escrow",
                    _ =>
                      "You currently don't have any ${switch (currentEscrowStatusIndex) {
                        1 => "completed",
                        2 => "ongoing",
                        3 => "paused",
                        _ => ""
                      }} escrow"
                  },
                  showButton: false),
            ],
          ),
        if (escrows.isNotEmpty)
          ...List.generate(escrows.length, (index) {
            EscrowWithSubmissionPlanModel escrowModel =
                escrows.reversed.toList()[index];
            return Padding(
              padding: appPadding().copyWith(top: 0),
              child: EscrowItemCard(escrowDetails: escrowModel),
            );
          }),
      ]),
    );
  }
}

EscrowStatus escrowStatus(String status) {
  return switch (status) {
    "completed" => EscrowStatus.completed,
    "ongoing" => EscrowStatus.ongoing,
    "paused" => EscrowStatus.paused,
    _ => EscrowStatus.ongoing
  };
}
