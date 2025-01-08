// ignore_for_file: library_private_types_in_public_api, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_with_submission_paln_model.dart';
import 'package:project_bist/WIDGETS/error_page.dart' as errorPage;
import 'package:project_bist/core.dart';
import 'package:project_bist/main.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:project_bist/PROVIDERS/persist_data_provider/persist_data_provider.dart';

enum ActivityStatus {
  approved,
  declined,
  awaitingReview,
  awaitingResubmission,
  expectingSubmission
}

ActivityStatus determineActivityStatus(PlanStatus escrowStatus) {
  //print(escrowStatus.toString());
  return switch (escrowStatus) {
    PlanStatus(
      status: "ongoing",
      isPendingSubmission: false,
      fileIsNotEmpty: true
    ) =>
      ActivityStatus.awaitingReview,
    PlanStatus(
      status: "ongoing",
      isPendingSubmission: true,
      fileIsNotEmpty: true
    ) =>
      ActivityStatus.awaitingResubmission,
    PlanStatus(
      status: "ongoing",
      isPendingSubmission: true,
      fileIsNotEmpty: false
    ) =>
      ActivityStatus.expectingSubmission,

    /// [formally] awaitingResubmission
    PlanStatus(status: "approved") => ActivityStatus.approved,
    PlanStatus(status: "declined") => ActivityStatus.declined,
    _ => ActivityStatus.awaitingResubmission

    /// [formally] expectingSubmission
  };
}

class PlanStatus {
  final String status;
  bool? isPendingSubmission;
  bool? fileIsNotEmpty;

  PlanStatus(
      {required this.status, this.isPendingSubmission, this.fileIsNotEmpty});

  @override
  String toString() =>
      "PlanStatus(status: $status, isPendingSubmission: $isPendingSubmission, fileIsNotEmpty: $fileIsNotEmpty})";
}

class EscrowActivities extends Plan {
  String? subtitle;
  ActivityStatus activityStatus;

  EscrowActivities(this.activityStatus,
      {required super.id,
      required super.createdAt,
      required super.updatedAt,
      required super.name,
      required super.deliverable,
      required String deadline,
      required super.price,
      required super.attachment,
      required super.submissionDate,
      required String status,
      required super.isPendingSubmission,
      required super.extensionDuration,
      required super.extensionDurationType,
      required super.reviewCount,
      required super.escrow})
      : super(deadline: deadline, status: status) {
    subtitle = switch (determineActivityStatus(PlanStatus(
        status: status,
        isPendingSubmission: isPendingSubmission,
        fileIsNotEmpty: attachment.isNotEmpty))) {
      ActivityStatus.approved => "Approved",
      ActivityStatus.awaitingResubmission =>
        "Resubmission expected - ${timeago.format(DateTime.parse(deadline.split("/").reversed.join("-")))}",
      ActivityStatus.awaitingReview => "Submitted - Awaiting review",
      ActivityStatus.declined => "Declined",
      ActivityStatus.expectingSubmission => "Expecting submission"
    };
  }
}

/// [This screen to see "Add Submission" plan button & "Get Support" button]

class JobActivityPreview extends ConsumerStatefulWidget {
  static const String jobActivityPreview = "jobActivityPreview";
  EscrowWithSubmissionPlanModel escrowData;

  JobActivityPreview({super.key, required this.escrowData});

  @override
  _JobActivityPreviewState createState() => _JobActivityPreviewState();
}

class _JobActivityPreviewState extends ConsumerState<JobActivityPreview> {
  List<EscrowActivities> jobActivities = [];
  
 late TextEditingController rateResearcherController;

  int rateIndex = -1;


  @override
  void initState() {
    setState(() {
      rateResearcherController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    rateResearcherController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(PersistDataProvider.availableSubmissionPlans.notifier).setData(
          widget
              .escrowData.plans
              .map((e) => EscrowActivities(
                  determineActivityStatus(PlanStatus(
                      status: e.status,
                      isPendingSubmission: e.isPendingSubmission,
                      fileIsNotEmpty: e.attachment.isNotEmpty)),
                  id: e.id,
                  createdAt: e.createdAt,
                  updatedAt: e.updatedAt,
                  name: e.name,
                  deliverable: e.deliverable,
                  deadline: e.deadline,
                  price: e.price,
                  attachment: e.attachment,
                  submissionDate: e.submissionDate,
                  status: e.status,
                  isPendingSubmission: e.isPendingSubmission,
                  extensionDuration: e.extensionDuration,
                  extensionDurationType: e.extensionDurationType,
                  reviewCount: e.reviewCount,
                  escrow: e.escrow))
              .toList());
    });
    return Scaffold(
      appBar: customAppBar(context,
          title: "Activity", hasElevation: true, hasIcon: true),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox.expand(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: appPadding().copyWith(bottom: 20.sp),
              child: Column(
                children: [
                  ref
                          .watch(PersistDataProvider.availableSubmissionPlans)
                          .isNotEmpty
                      ? Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: TextOf(
                                "View batch information and submission.",
                                16.sp,
                                4,
                                align: TextAlign.left,
                              ))
                            ],
                          ),
                          24.sp.verticalSpace,
                          ...ref
                              .watch(
                                  PersistDataProvider.availableSubmissionPlans)
                              .map((e) => Container(
                                    margin: EdgeInsets.only(bottom: 16.sp),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: AppColors.brown1(context),
                                        border: Border.all(
                                            color: switch (
                                                determineActivityStatus(
                                                    PlanStatus(
                                                        status: e.status,
                                                        isPendingSubmission: e
                                                            .isPendingSubmission,
                                                        fileIsNotEmpty: e
                                                            .attachment
                                                            .isNotEmpty))) {
                                          ActivityStatus.approved =>
                                            AppColors.green,
                                          ActivityStatus.expectingSubmission =>
                                            AppColors.grey1,
                                          ActivityStatus.awaitingResubmission =>
                                            AppColors.yellow,
                                          ActivityStatus.awaitingReview =>
                                            AppColors.primaryColor,
                                          ActivityStatus.declined =>
                                            AppColors.red
                                        }),
                                        borderRadius:
                                            BorderRadius.circular(12.r)),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.sp),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context,
                                              ViewSingleActivity
                                                  .viewSingleActivity,
                                              arguments:
                                                  ViewSingleActivityArguments(
                                                      escrowActivity: e,
                                                      researcherId: widget
                                                          .escrowData
                                                          .researcherId));
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextOf(e.name, 16.sp, 6),
                                                    TextOf(
                                                      e.subtitle!,
                                                      12.sp,
                                                      4,
                                                      color: AppThemeNotifier
                                                              .colorScheme(
                                                                  context)
                                                          .onSecondary,
                                                    )
                                                  ],
                                                ),
                                                const IconOf(Icons
                                                    .arrow_forward_ios_rounded)
                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                        ])
                      : Column(children: [
                          YMargin(0.15.sh),
                          errorPage.ErrorPage(
                            message:
                                "No submission plan created for your job yet.\n\n${ref.watch(switchUserProvider) != UserTypes.researcher ?"Your researcher won’t be able to make any submission until you create your submission plan":"Your client is yet to create any sumbission plan for this escrow. You won't be able to submit your progress until they do. You can request them to do so."}",
                            showButton: false,
                          )
                        ]),
                      YMargin(120.sp)
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: appPadding().copyWith(bottom: 20.sp),
            decoration: BoxDecoration(color: AppThemeNotifier.themeColor(context).scaffoldBackgroundColor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (ref.watch(switchUserProvider) != UserTypes.researcher &&
                            widget.escrowData.status == "ongoing")
                        ? Button(
                            buttonType: ButtonType.whiteBg,
                            onPressed: () {
                              Navigator.pushNamed(context,
                                  SubscriptionPlanScreen.subscriptionPlanScreen,
                                  arguments: SubscriptionPlanScreenArgument(
                                      escrowData: widget.escrowData,
                                      totalPriceOfAvailableSubmissions: ref
                                          .watch(PersistDataProvider
                                              .availableSubmissionPlans)
                                          .map((e) => e.price)
                                          .reduce((a, b) => a + b)
                                          .toInt(),
                                      requiredStartDate:
                                          widget.escrowData.startDate,
                                      requiredEndDate:
                                          widget.escrowData.endDate));
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const IconOf(
                                    Icons.add,
                                    color: AppColors.primaryColor,
                                  ),
                                  XMargin(10.sp),
                                  TextOf(
                                    "Add Submission Plan",
                                    16,
                                    5,
                                    color: AppColors.primaryColor,
                                  )
                                ]),
                          )
                        : const SizedBox.shrink(),
                        switch(widget.escrowData.status){
                        "completed" => Padding(padding: EdgeInsets.only(top: 12.sp),child:
                        Column(children: [
                        ref.watch(switchUserProvider) != UserTypes.researcher ? Column(
                            children: [
                              Button(
                      text: "Review researcher",
                      buttonType: ButtonType.blueBg,
                      onPressed: () {
                        appBottomSheet(context, body:
                            StatefulBuilder(builder: (context, changeState) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) {
                            changeState(() {});
                            setState(() {});
                          });
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextOf(
                                        "Review and Rate Researcher", 20.sp, 6),
                                    InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: const IconOf(Icons.close))
                                  ],
                                ),
                                YMargin(24.sp),
                                Row(children: [
                                  Expanded(
                                      child: TextOf(
                                          "Kindly let us know your experience working with this researcher.",
                                          16.sp,
                                          4,
                                          align: TextAlign.left))
                                ]),
                                YMargin(24.sp),
                                InputField(
                                    hintText: "Write your Review",
                                    maxLines: 4,
                                    fieldController: rateResearcherController,
                                    onChanged: (_) {
                                      setState(() {});
                                      changeState(() {});
                                    }),
                                YMargin(24.sp),
                                Row(children: [
                                  Expanded(
                                      child: TextOf(
                                          "Rate the Researcher", 16.sp, 4,
                                          align: TextAlign.left))
                                ]),
                                YMargin(8.sp),
                                Row(
                                    children: List.generate(
                                        5,
                                        (index) => Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10.sp),
                                              child: StatefulBuilder(builder:
                                                  (context, changeSate) {
                                                return InkWell(
                                                  onTap: () {
                                                    changeState(() {
                                                      rateIndex = index;
                                                    });
                                                  },
                                                  child: Image.asset(
                                                      index <= rateIndex
                                                          ? ImageOf.ratedIcon
                                                          : ImageOf
                                                              .stariconoutlined,
                                                      height: 30.sp),
                                                );
                                              }),
                                            ))),
                                YMargin(24.sp),
                                Button(
                                  text: "Submit",
                                  buttonType: ((rateIndex + 1) > 0)
                                      ? ButtonType.blueBg
                                      : ButtonType.disabled,
                                  onPressed: () {
                                    EscrowProvider.clientReviewResearcher(
                                        context, ref,
                                        researcherId: widget.escrowData.researcherId,
                                        rating: (rateIndex + 1),
                                        review: rateResearcherController
                                                .text.isEmpty
                                            ? " "
                                            : rateResearcherController.text);
                                  },
                                )
                              ],
                            ),
                          );
                        }));
                      }),
                      YMargin(15.sp),
                            ]
                          ): const SizedBox.shrink(),
                      TextOf("This job is completed", 14.sp, 5)
                        ])
                        ),
                        _=> const SizedBox.shrink()
                        },
                        (ref.watch(switchUserProvider) != UserTypes.researcher &&
                    widget.escrowData.plans.every((e) => e.status =="approved" || e.status =="declined") && widget.escrowData.status == "ongoing")?
                Column(
                      children: [
                        YMargin(15.sp),
                        Button(
                              onPressed: () {
                                EscrowProvider.clientCompleteEscrowJob(
                                              context, ref,
                                              escrowId: widget.escrowData.id);
                              },
                              buttonType: ButtonType.blueBg,
                              text: "Mark As Completed"
                            ),
                      ],
                    ): const SizedBox.shrink()
                    //     (ref.watch(switchUserProvider) != UserTypes.researcher &&
                    // widget.escrowData.status == "ongoing")
                // ? Container(
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //         color: AppThemeNotifier.themeColor(context)
                //             .scaffoldBackgroundColor),
                //     padding: appPadding().copyWith(bottom: 15.sp),
                //     child: Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         widget.escrowData.status == "ongoing"
                //             ? const SizedBox.shrink()
                //             : Column(
                //                 mainAxisSize: MainAxisSize.min,
                //                 children: [
                //                   InkWell(
                //                     onTap: () {
                //                       EscrowProvider.clientCompleteEscrowJob(
                //                           context, ref,
                //                           escrowId: widget.escrowData.id);
                //                     },
                //                     child: TextOf("Mark as completed", 14.sp, 5,
                //                         color: AppColors.brown),
                //                   ),
                //                   YMargin(10.sp),
                //                 ],
                //               ),
                //         Button(
                //           onPressed: () {},
                //           buttonType: ButtonType.blueBg,
                //           child: Row(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Image.asset(
                //                 ImageOf.indeedJobIcon,
                //                 height: 40.sp,
                //               ),
                //               XMargin(10.sp),
                //               Expanded(
                //                   child: InkWell(
                //                 onTap: () {
                //                   Navigator.pushNamed(
                //                       context,
                //                       ClientRequestSupportOnProject
                //                           .clientRequestSupportOnProject,
                //                       arguments: widget.escrowData.jobId!.id);
                //                 },
                //                 child: Row(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceBetween,
                //                   children: [
                //                     Column(
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.start,
                //                       mainAxisAlignment: MainAxisAlignment.center,
                //                       children: [
                //                         TextOf(
                //                           "Get Support",
                //                           16.sp,
                //                           6,
                //                           color: AppColors.white,
                //                         ),
                //                         TextOf("Pause job, file for a refund",
                //                             12.sp, 4,
                //                             color: AppColors.white)
                //                       ],
                //                     ),
                //                     const IconOf(Icons.arrow_forward_ios_rounded,
                //                         color: AppColors.white)
                //                   ],
                //                 ),
                //               ))
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   )
                // : const SizedBox.shrink()
              ]
            ),
          )
          
        ],
      ),
    );
  }
}

class ViewSingleActivityArguments {
  EscrowActivities escrowActivity;
  String? researcherId;

  ViewSingleActivityArguments(
      {required this.escrowActivity, this.researcherId});
}

class ViewSingleActivity extends ConsumerStatefulWidget {
  static const String viewSingleActivity = "viewSingleActivity";
  final ViewSingleActivityArguments viewSingleActivityArgument;

  const ViewSingleActivity(
      {required this.viewSingleActivityArgument, super.key});

  @override
  ConsumerState<ViewSingleActivity> createState() => _ViewSingleActivityState();
}

class _ViewSingleActivityState extends ConsumerState<ViewSingleActivity> {

  bool isDownloading = false;
  double downloadProgress = 0;



  String attachmentFileFromCloudinary = "_", attachmentFile = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(
          context,
          title: "Activity",
          hasIcon: true,
          hasElevation: true,
        ),
        body: Padding(
          padding: appPadding(),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: TextOf(
                  "View batch information and submission.",
                  16.sp,
                  4,
                  align: TextAlign.left,
                ))
              ],
            ),
            24.sp.verticalSpace,
            // approved,
            // declined,
            // expectingSubmission

            (widget.viewSingleActivityArgument.escrowActivity.activityStatus ==
                        ActivityStatus.expectingSubmission ||
                    (widget.viewSingleActivityArgument.escrowActivity
                                .activityStatus ==
                            ActivityStatus.awaitingResubmission &&
                        ref.watch(switchUserProvider) == UserTypes.researcher))
                ? Column(
                    children: [
                      awaitingOrExpecting(
                          widget.viewSingleActivityArgument.escrowActivity),
                      (ref.watch(switchUserProvider) == UserTypes.researcher &&
                              (widget.viewSingleActivityArgument.escrowActivity
                                          .activityStatus ==
                                      ActivityStatus.awaitingResubmission ||
                                  widget.viewSingleActivityArgument
                                          .escrowActivity.activityStatus ==
                                      ActivityStatus.expectingSubmission))
                          ? InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                getIt<AppModel>()
                                    .uploadFile(context, allowedExtensions: [
                                  // "docx",
                                  "pdf",
                                  // "txt",
                                  // "pptx",
                                  // "jpg"
                                ]).then((value) {
                                  setState(() {
                                    //upload = value;
                                    attachmentFile = value!.path;
                                    // attachFileController.text =
                                    //     attachmentFile.split("/").last;
                                  });
                                  if (!attachmentFileFromCloudinary
                                          .contains("http") &&
                                      attachmentFileFromCloudinary.isNotEmpty) {
                                    UploadToCloudinaryProvider.uploadDocument(
                                            context,
                                            localFilePath: attachmentFile,
                                            loadingMessage:
                                                "Processing uploaded document...")
                                        .then((value) {
                                      setState(() {
                                        attachmentFileFromCloudinary = value;
                                      });
                                      EscrowProvider
                                          .researcherSubmitDocumentForSubmissionPlan(
                                              context,
                                              ref,
                                              planId: widget
                                                  .viewSingleActivityArgument
                                                  .escrowActivity
                                                  .id,
                                              attachment:
                                                  attachmentFileFromCloudinary,
                                              batchName: widget
                                                  .viewSingleActivityArgument
                                                  .escrowActivity
                                                  .name);
                                    });
                                  } else {
                                    EscrowProvider
                                        .researcherSubmitDocumentForSubmissionPlan(
                                            context, ref,
                                            planId: widget
                                                .viewSingleActivityArgument
                                                .escrowActivity
                                                .id,
                                            attachment:
                                                attachmentFileFromCloudinary,
                                            batchName: widget
                                                .viewSingleActivityArgument
                                                .escrowActivity
                                                .name);
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ImageIcon(
                                    AssetImage(
                                      ImageOf.fileAttachmnentIcon,
                                    ),
                                    color: AppColors.brown,
                                    size: 21.sp,
                                  ),
                                  XMargin(10.sp),
                                  TextOf(
                                      widget
                                                  .viewSingleActivityArgument
                                                  .escrowActivity
                                                  .activityStatus ==
                                              ActivityStatus
                                                  .awaitingResubmission
                                          ? "Attach file to re-submit"
                                          : "Attach file to submit",
                                      20.sp,
                                      4,
                                      color: AppColors.brown)
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  )
                :

                // awaitingResubmission,
                // awaitingReview,

                // (widget.viewSingleActivityArgument.escrowActivity.activityStatus ==
                //             ActivityStatus.approved ||
                //         widget.viewSingleActivityArgument.escrowActivity.activityStatus ==
                //             ActivityStatus.awaitingReview
                /// ========================= [AWAITING RESUBMISSION OR IN-REVIEW (EXPECTING REVIEW)]
                approvedOrAwaitingReview(
                    context,
                    widget.viewSingleActivityArgument.escrowActivity
                        .activityStatus)
          ]),
        ));
  }

  Widget awaitingOrExpecting(EscrowActivities escrowActivity) {
    return Column(children: [
      awaitingOrExpectingItem("Batch name", escrowActivity.name),
      awaitingOrExpectingItem("Deliverables", escrowActivity.deliverable),
      awaitingOrExpectingItem("Deadline", escrowActivity.deadline),
      awaitingOrExpectingItem("Price for Batch Submission",
          "${AppConst.COUNTRY_CURRENCY} ${AppMethods.moneyComma(escrowActivity.price)}"),
    ref.watch(switchUserProvider) != UserTypes.researcher?const SizedBox.shrink(): awaitingOrExpectingItem("Commission",
          "${AppConst.COUNTRY_CURRENCY} ${AppMethods.moneyComma((escrowActivity.price * 0.1).toInt())}"),
      YMargin(24.sp),
    ]);
  }

  int selectedDay = 0;

  Widget approvedOrAwaitingReview(BuildContext context, ActivityStatus status) {
    return Column(children: [
      Image.asset(
        ImageOf.pdfFile,
        height: 110.sp,
      ),
      YMargin(20.sp),
      awaitingOrExpecting(widget.viewSingleActivityArgument.escrowActivity),
      YMargin(16.sp),
      isDownloading == false
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIcon(AssetImage(ImageOf.downloadIcon),
                    color: AppColors.primaryColor, size: 21.sp),
                XMargin(10.sp),
                InkWell(
                    onTap: () {
                      AppMethods.downloadFile(
                          url: widget.viewSingleActivityArgument.escrowActivity
                              .attachment,
                          fileName: widget
                              .viewSingleActivityArgument.escrowActivity.name,
                          onProgress: (_, progress) {
                            setState(() {
                              isDownloading = true;
                              downloadProgress = progress;
                            });
                          },
                          onDownloadCompleted: (_) {
                            setState(() {
                              isDownloading = false;
                            });
                          },
                          onDownloadError: (_) {
                            setState(() {
                              isDownloading = false;
                            });
                          });
                    },
                    child: TextOf("Download file", 16.sp, 5,
                        color: AppColors.primaryColor))
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CupertinoWidget(child: CupertinoActivityIndicator()),
                XMargin(10.sp),
                TextOf(
                    "Downloading attachment... (${(downloadProgress * 100).round()}%)",
                    13.sp,
                    4)
              ],
            ),
      YMargin(32.sp),
      (ref.watch(switchUserProvider) == UserTypes.researcher)
          ? TextOf(
              switch (status) {
                ActivityStatus.approved => "Approved",
                ActivityStatus.expectingSubmission => "Expecting submission",
                ActivityStatus.awaitingResubmission => "Expecting resubmission",
                ActivityStatus.awaitingReview => "Submitted, Pending Approval",
                ActivityStatus.declined => "Declined"
              },
              //"Approved ",
              20.sp,
              5,
              color: switch (status) {
                ActivityStatus.approved => AppColors.green,
                ActivityStatus.expectingSubmission => AppColors.brown,
                ActivityStatus.awaitingResubmission => AppColors.yellow,
                ActivityStatus.awaitingReview => AppColors.primaryColor,
                ActivityStatus.declined => AppColors.red
              },
              fontStyle: FontStyle.italic,
            )
          : (ref.watch(switchUserProvider) != UserTypes.researcher &&
                  (status == ActivityStatus.awaitingResubmission ||
                      status == ActivityStatus.awaitingReview))
              ? Column(
                  children: [
                    widget.viewSingleActivityArgument.escrowActivity
                                .reviewCount <
                            4
                        ? RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppThemeNotifier.colorScheme(context)
                                        .primary),
                                text: "Click on \n",
                                children: const [
                                TextSpan(
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                    text: "“Approve Submission” ",
                                    children: [
                                      TextSpan(
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400),
                                          text: "to approve submission, ",
                                          children: [
                                            TextSpan(
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                                text: "“Request for Review” ",
                                                children: [
                                                  TextSpan(
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    text:
                                                        "to get a reviewed submission ",
                                                  )
                                                ])
                                          ])
                                    ])
                              ]))
                        : const SizedBox.shrink(),
                    YMargin(24.sp),
                    Button(
                      text: "Approve submission",
                      onPressed: () {
                        EscrowProvider.approveSubmissionPlan(context, ref,
                                batchTitle: widget.viewSingleActivityArgument
                                    .escrowActivity.name,
                                planId: widget.viewSingleActivityArgument
                                    .escrowActivity.id)
                            .then((value) {
                          // if (value == 4) {
                          //   appBottomSheet(context, body: StatefulBuilder(
                          //       builder: (context, changeState) {
                          //     WidgetsBinding.instance
                          //         .addPostFrameCallback((timeStamp) {
                          //       changeState(() {});
                          //       setState(() {});
                          //     });
                          //     return Padding(
                          //       padding: MediaQuery.of(context).viewInsets,
                          //       child: Column(
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               TextOf("Review and Rate Researcher",
                          //                   20.sp, 6),
                          //               InkWell(
                          //                   onTap: () {
                          //                     Navigator.pop(context);
                          //                   },
                          //                   child: const IconOf(Icons.close))
                          //             ],
                          //           ),
                          //           YMargin(24.sp),
                          //           Row(children: [
                          //             Expanded(
                          //                 child: TextOf(
                          //                     "Kindly let us know your experience working with this researcher.",
                          //                     16.sp,
                          //                     4,
                          //                     align: TextAlign.left))
                          //           ]),
                          //           YMargin(24.sp),
                          //           InputField(
                          //               hintText: "Write your Review",
                          //               maxLines: 4,
                          //               fieldController:
                          //                   rateResearcherController,
                          //               onChanged: (_) {
                          //                 setState(() {});
                          //                 changeState(() {});
                          //               }),
                          //           YMargin(24.sp),
                          //           Row(children: [
                          //             Expanded(
                          //                 child: TextOf(
                          //                     "Rate the Researcher", 16.sp, 4,
                          //                     align: TextAlign.left))
                          //           ]),
                          //           YMargin(8.sp),
                          //           Row(
                          //               children: List.generate(
                          //                   5,
                          //                   (index) => Padding(
                          //                         padding: EdgeInsets.only(
                          //                             right: 10.sp),
                          //                         child: StatefulBuilder(
                          //                             builder: (context,
                          //                                 changeSate) {
                          //                           return InkWell(
                          //                             onTap: () {
                          //                               changeState(() {
                          //                                 rateIndex = index;
                          //                               });
                          //                             },
                          //                             child: Image.asset(
                          //                                 index <= rateIndex
                          //                                     ? ImageOf
                          //                                         .ratedIcon
                          //                                     : ImageOf
                          //                                         .stariconoutlined,
                          //                                 height: 30.sp),
                          //                           );
                          //                         }),
                          //                       ))),
                          //           YMargin(24.sp),
                          //           Button(
                          //             text: "Submit",
                          //             buttonType: ((rateIndex + 1) > 0)
                          //                 ? ButtonType.blueBg
                          //                 : ButtonType.disabled,
                          //             onPressed: () {
                          //               EscrowProvider.clientReviewResearcher(
                          //                   context, ref,
                          //                   researcherId: widget
                          //                       .viewSingleActivityArgument
                          //                       .researcherId!,
                          //                   rating: (rateIndex + 1),
                          //                   review: rateResearcherController
                          //                           .text.isEmpty
                          //                       ? " "
                          //                       : rateResearcherController
                          //                           .text);
                          //             },
                          //           )
                          //         ],
                          //       ),
                          //     );
                          //   }));
                          // }
                        });
                      },
                      buttonType: ButtonType.blueBg,
                    ),
                    YMargin(16.sp),
                    widget.viewSingleActivityArgument.escrowActivity
                                .reviewCount <
                            5
                        ? Button(
                            text: "Request for Review",
                            onPressed: () {
                              // print(widget.viewSingleActivityArgument
                              //     .escrowActivity.reviewCount);
                              appBottomSheet(context,
                                  body: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextOf(
                                              "Request for Review", 20.sp, 6),
                                          InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: const IconOf(Icons.close))
                                        ],
                                      ),
                                      YMargin(24.sp),
                                      Row(
                                        children: [
                                          TextOf(
                                              "Period of Extension", 16.sp, 4)
                                        ],
                                      ),
                                      YMargin(8.sp),
                                      StatefulBuilder(
                                          builder: (context, changeState) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              flex: 6,
                                              child: Container(
                                                height: 55.sp,
                                                decoration: BoxDecoration(
                                                    color: isDarkTheme(context)
                                                        ? AppColors.black
                                                        : AppColors.blue1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.sp),
                                                    border: Border.all(
                                                        color:
                                                            AppColors.grey4)),
                                                child: DropdownButton(
                                                    isExpanded: true,
                                                    value: selectedDay,
                                                    hint: TextOf("0", 16.sp, 4),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4.sp,
                                                            horizontal: 10.sp),
                                                    underline:
                                                        const SizedBox.shrink(),
                                                    icon: IconOf(
                                                        Icons
                                                            .expand_more_rounded,
                                                        size: 20.sp),
                                                    items: List.generate(
                                                        widget
                                                                    .viewSingleActivityArgument
                                                                    .escrowActivity
                                                                    .reviewCount ==
                                                                0
                                                            ? 14
                                                            : 7,
                                                        (index) =>
                                                            DropdownMenuItem(
                                                                onTap: () {
                                                                  WidgetsBinding
                                                                      .instance
                                                                      .addPostFrameCallback(
                                                                          (timeStamp) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                                value: index,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    TextOf(
                                                                        (index +
                                                                                1)
                                                                            .toString(),
                                                                        16.sp,
                                                                        4),
                                                                  ],
                                                                ))),
                                                    onChanged: (value) {
                                                      changeState(() {
                                                        selectedDay = (value!);
                                                      });
                                                    }),
                                              ),
                                            ),
                                            const Expanded(
                                                flex: 1,
                                                child: SizedBox.shrink()),
                                            Expanded(
                                              flex: 18,
                                              child: InputField(
                                                fieldController:
                                                    TextEditingController(
                                                  text:
                                                      "Day${selectedDay == 0 ? "" : "s"}",
                                                ),
                                                readOnly: true,
                                                showCursor: false,
                                              ),
                                            )
                                          ],
                                        );
                                      }),
                                      YMargin(24.sp),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: TextOf(
                                                  "You can only extend by 14 days for first review and 7 days maximum for subsequent reviews.",
                                                  16.sp,
                                                  4,
                                                  align: TextAlign.left))
                                        ],
                                      ),
                                      YMargin(24.sp),
                                      Button(
                                        text: "Request for review",
                                        buttonType: ButtonType.blueBg,
                                        onPressed: () {
                                          EscrowProvider
                                                  .requestForReviewOfSubmissionPlan(
                                                      context,
                                                      ref,
                                                      planId: widget
                                                          .viewSingleActivityArgument
                                                          .escrowActivity
                                                          .id,
                                                      duration: selectedDay + 1,
                                                      durationType: "days")
                                              .then((status) {});
                                        },
                                      )
                                    ],
                                  ));
                            },
                            color: AppColors.brown,
                            buttonType: ButtonType.blueBg,
                          )
                        : const SizedBox.shrink(),
                    YMargin(16.sp),
                    widget.viewSingleActivityArgument.escrowActivity
                                .reviewCount >
                            0
                        ? Column(
                            children: [
                              YMargin(16.sp),
                              InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context,
                                        ClientDeclineProject
                                            .clientDeclineProject,
                                        arguments: widget
                                            .viewSingleActivityArgument
                                            .escrowActivity
                                            .id);
                                  },
                                  child: TextOf("Decline", 16.sp, 4,
                                      color: AppColors.red)),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                )
              : const SizedBox.shrink(),
      switch(ref.watch(switchUserProvider)){
        UserTypes.researcher => switch (status) {
        ActivityStatus.awaitingReview => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  getIt<AppModel>().uploadFile(context, allowedExtensions: [
                    "pdf",
                  ]).then((value) {
                    setState(() {
                      attachmentFile = value!.path;
                    });
                    if (!attachmentFileFromCloudinary.contains("http") &&
                        attachmentFileFromCloudinary.isNotEmpty) {
                      UploadToCloudinaryProvider.uploadDocument(context,
                              localFilePath: attachmentFile,
                              loadingMessage: "Processing uploaded document...")
                          .then((value) {
                        setState(() {
                          attachmentFileFromCloudinary = value;
                        });
                        EscrowProvider
                            .researcherSubmitDocumentForSubmissionPlan(
                                context, ref,
                                planId: widget.viewSingleActivityArgument
                                    .escrowActivity.id,
                                attachment: attachmentFileFromCloudinary,
                                batchName: widget.viewSingleActivityArgument
                                    .escrowActivity.name);
                      });
                    } else {
                      EscrowProvider.researcherSubmitDocumentForSubmissionPlan(
                          context, ref,
                          planId: widget
                              .viewSingleActivityArgument.escrowActivity.id,
                          attachment: attachmentFileFromCloudinary,
                          batchName: widget
                              .viewSingleActivityArgument.escrowActivity.name);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage(
                        ImageOf.fileAttachmnentIcon,
                      ),
                      color: AppColors.brown,
                      size: 21.sp,
                    ),
                    XMargin(10.sp),
                    TextOf("Attach file to re-submit", 20.sp, 4,
                        color: AppColors.brown)
                  ],
                ),
              ),
            ],
          ),
        _ => const SizedBox.shrink()
      }
    ,
        _=> const SizedBox.shrink()
      }
    ]);
  }

  Widget awaitingOrExpectingItem(String left, String right) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        TextOf(left, 16.sp, 4,
            color: AppThemeNotifier.colorScheme(context).onSecondary),
        TextOf(right, 16.sp, 5),
      ]),
      YMargin(16.sp)
    ]);
  }
}



