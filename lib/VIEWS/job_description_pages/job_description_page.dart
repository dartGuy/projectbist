// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:project_bist/MODELS/job_model/reseracher_job_model.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/UTILS/profile_image.dart';
import 'package:project_bist/VIEWS/clients_job_profile/clients_job_profile.dart';
import 'package:project_bist/WIDGETS/cupertino_widget.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import "package:project_bist/PROVIDERS/jobs_provider/jobs_provider.dart";

class JobDescriptionPageArgument {
  final ResearcherJobModel researcherJobModel;
  bool? hasApplied;
  JobDescriptionPageArgument(
      {required this.researcherJobModel, this.hasApplied = false});
}

class JobDescriptionPage extends ConsumerStatefulWidget {
  static const String jobDescriptionPage = "jobDescriptionPage";
  final JobDescriptionPageArgument jobDescriptionPageArgument;
  const JobDescriptionPage(
      {required this.jobDescriptionPageArgument, super.key});
  @override
  _JobDescriptionPageState createState() => _JobDescriptionPageState();
}

class _JobDescriptionPageState extends ConsumerState<JobDescriptionPage> {
  int receivedProgress = 0, totalProgress = 0;

  bool downloadBegun = false;

  String fileSize = "--";
  Future<String?> determineFileSize() async {
    final String url =
        widget.jobDescriptionPageArgument.researcherJobModel.resource.isEmpty
            ? widget.jobDescriptionPageArgument.researcherJobModel.chapters
                .replaceAll("http://", "https://")
            : widget.jobDescriptionPageArgument.researcherJobModel.resource
                .replaceAll("http://", "https://");
    http.Response r = await http.get(Uri(
      host: url,
    ));
    final fileSize = r.headers["content-length"];
    print("FILE SIZE: ${fileSize?.toString()}");
    return fileSize?.toString();
  }

  @override
  Widget build(BuildContext context) {
    determineFileSize().then((value) {
      setState(() {
        fileSize = value ?? "**";
      });
    });
    return Scaffold(
      appBar: customAppBar(context,
          title: "Job Description", hasElevation: true, hasIcon: true),
      body: SafeArea(
          child: Padding(
        padding: appPadding(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                    child: TextOf(
                  widget.jobDescriptionPageArgument.researcherJobModel
                              .jobTitle ==
                          '--'
                      ? '"Client in need of a topic"'
                      : widget.jobDescriptionPageArgument.researcherJobModel
                          .jobTitle,
                  20.sp,
                  5,
                  align: TextAlign.left,
                  color: widget.jobDescriptionPageArgument.researcherJobModel
                              .jobTitle ==
                          '--'
                      ? AppColors.brown
                      : null,
                ))
              ],
            ),
            YMargin(16.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildProfileImage(
                    radius: 50.sp,
                    fontWeight: 5,
                    fontSize: 15.sp,
                    imageUrl: widget.jobDescriptionPageArgument
                        .researcherJobModel.clientId.avatar,
                    fullNameTobSplit: widget.jobDescriptionPageArgument
                        .researcherJobModel.clientId.fullName),
                XMargin(10.sp),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, ClientsJobProfile.clientsJobProfile,
                              arguments: UserProfile(
                                  clientType: widget.jobDescriptionPageArgument
                                      .researcherJobModel.clientId.clientType,
                                  avatar: widget.jobDescriptionPageArgument
                                      .researcherJobModel.clientId.avatar,
                                  fullName: widget.jobDescriptionPageArgument
                                      .researcherJobModel.clientId.fullName,
                                  division: widget.jobDescriptionPageArgument
                                      .researcherJobModel.clientId.division,
                                  sector: widget.jobDescriptionPageArgument
                                      .researcherJobModel.clientId.sector,
                                  username: widget.jobDescriptionPageArgument
                                      .researcherJobModel.clientId.userName,
                                  department: widget.jobDescriptionPageArgument
                                      .researcherJobModel.clientId.department,
                                  faculty: widget.jobDescriptionPageArgument
                                      .researcherJobModel.clientId.faculty,
                                  institutionName: widget
                                      .jobDescriptionPageArgument
                                      .researcherJobModel
                                      .clientId
                                      .institutionName));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextOf(
                                  widget.jobDescriptionPageArgument
                                      .researcherJobModel.clientId.fullName,
                                  16,
                                  5,
                                  align: TextAlign.left,
                                ),
                                YMargin(2.5.sp),
                                TextOf(
                                  AppMethods.toTitleCase(widget
                                      .jobDescriptionPageArgument
                                      .researcherJobModel
                                      .clientId
                                      .clientType),
                                  12,
                                  4,
                                  align: TextAlign.left,
                                  color: AppThemeNotifier.colorScheme(context)
                                      .onSecondary,
                                ),
                              ],
                            ),
                            IconOf(Icons.arrow_forward_ios_rounded, size: 17.sp)
                          ],
                        )))
              ],
            ),
            YMargin(16.sp),
            Container(
                padding: EdgeInsets.all(12.sp),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.brown1(context),
                    borderRadius: BorderRadius.circular(12.r)),
                child: Column(children: [
                  eachJobDescriptionItem(
                      title: "Project description",
                      subtitle: widget.jobDescriptionPageArgument
                          .researcherJobModel.jobDescription),
                  eachJobDescriptionItem(
                      title: "Project Name",
                      subtitle: widget.jobDescriptionPageArgument
                          .researcherJobModel.jobName),
                  eachJobDescriptionItem(
                      title: "Duration",
                      subtitle:
                          "${widget.jobDescriptionPageArgument.researcherJobModel.duration} ${widget.jobDescriptionPageArgument.researcherJobModel.durationType}"),
                  eachJobDescriptionItem(
                      title: "Scope of Work",
                      subtitle: widget.jobDescriptionPageArgument
                          .researcherJobModel.jobScope),
                  eachJobDescriptionItem(
                      title: "Budget",
                      subtitle:
                          "${AppConst.COUNTRY_CURRENCY} ${widget.jobDescriptionPageArgument.researcherJobModel.fixedBudget == 0 ? '${widget.jobDescriptionPageArgument.researcherJobModel.maxBudget} - ${widget.jobDescriptionPageArgument.researcherJobModel.minBudget}' : widget.jobDescriptionPageArgument.researcherJobModel.fixedBudget}"),
                  eachJobDescriptionItem(
                      title: "Number of Applicants",
                      subtitle: widget.jobDescriptionPageArgument
                          .researcherJobModel.numberOfApplications
                          .toString()),
                  widget.jobDescriptionPageArgument.researcherJobModel
                              .fileName !=
                          "--"
                      ? Column(
                          children: [
                            Row(
                              children: [
                                TextOf("Completed Chapters", 16.sp, 4),
                              ],
                            ),
                            YMargin(8.sp),
                            Row(children: [
                              Image.asset(ImageOf.pdfFile, height: 40.sp),
                              XMargin(7.sp),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 0.65.sw,
                                    child: Row(
                                      //mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: TextOf(
                                            widget.jobDescriptionPageArgument
                                                .researcherJobModel.fileName,
                                            16.sp,
                                            6, align: TextAlign.start, textOverflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  YMargin(2.5.sp),
                                  TextOf("12 MB", 12.sp, 4),
                                ],
                              ),
                              Expanded(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                    CupertinoWidget(
                                      child: InkWell(
                                          child: downloadBegun == true
                                              ? CupertinoActivityIndicator(
                                                  radius: 15.sp,
                                                  animating: true,
                                                  color: AppThemeNotifier
                                                          .colorScheme(context)
                                                      .primary,
                                                )
                                              : ImageIcon(
                                                  AssetImage(
                                                      ImageOf.downloadIcon),
                                                  color: AppThemeNotifier
                                                          .colorScheme(context)
                                                      .primary,
                                                  size: 24.sp),
                                          onTap: () {
                                            print(
                                                "Resource: ${widget.jobDescriptionPageArgument.researcherJobModel.resource}");
                                            print(
                                                "Chapters: ${widget.jobDescriptionPageArgument.researcherJobModel.chapters}");
                                            AppMethods.downloadFile(
                                                url: widget
                                                        .jobDescriptionPageArgument
                                                        .researcherJobModel
                                                        .resource
                                                        .isEmpty
                                                    ? widget
                                                        .jobDescriptionPageArgument
                                                        .researcherJobModel
                                                        .chapters
                                                        .replaceAll("http://",
                                                            "https://")
                                                    : widget
                                                        .jobDescriptionPageArgument
                                                        .researcherJobModel
                                                        .resource
                                                        .replaceAll("http://",
                                                            "https://"),
                                                fileName: widget
                                                    .jobDescriptionPageArgument
                                                    .researcherJobModel
                                                    .fileName,
                                                onProgress: (_, value) {
                                                  setState(() {
                                                    downloadBegun = true;
                                                  });
                                                },
                                                onDownloadCompleted: (_) {
                                                  setState(() {
                                                    downloadBegun = false;
                                                  });
                                                },
                                                onDownloadError: (e) {
                                                  setState(() {
                                                    downloadBegun = false;
                                                  });
                                                  print("Download Error: $e");
                                                });
                                          }),
                                    )
                                  ]))
                            ]),
                          ],
                        )
                      : const Row(children: [
                          Text("--No completed chapter file attached--")
                        ])
                ])),
            YMargin(16.sp),
            Row(
              children: [
                Expanded(
                  child: RichText(
                      text: TextSpan(
                          text: "Note: ",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppThemeNotifier.colorScheme(context)
                                  .primary),
                          children: [
                        TextSpan(
                            text:
                                "Your portfolio will be shared with the client when you apply, if you meet their criteria, you will be sent a message.",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400))
                      ])),
                ),
              ],
            ),
            YMargin(16.sp),
            Row(
              children: [
                Expanded(
                  child: RichText(
                      text: TextSpan(
                          text: "Tip: ",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppThemeNotifier.colorScheme(context)
                                  .primary),
                          children: [
                        TextSpan(
                            text:
                                "Keep your portfolio updated and competitive.",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400))
                      ])),
                ),
              ],
            ),
            YMargin(widget.jobDescriptionPageArgument.hasApplied == true
                ? 40.sp
                : 20.sp),
            widget.jobDescriptionPageArgument.hasApplied == true
                ? InkWell(
                    onTap: () {
                      JobsProvider.researcherWithdrawApplication(context, ref,
                          jobId: widget.jobDescriptionPageArgument
                              .researcherJobModel.id);
                    },
                    child: TextOf(
                      "Withdraw Application",
                      16.sp,
                      5,
                      color: AppColors.red,
                    ),
                  )
                : Button(
                    text: "Apply",
                    onPressed: () {
                      JobsProvider.researcherApplyForJob(context, ref,
                          jobId: widget.jobDescriptionPageArgument
                              .researcherJobModel.id);
                      //     .then((value) {
                      //   if (value.status == true) {
                      //     setState(() {
                      //       widget.jobDescriptionPageArgument.hasApplied = true;
                      //     });
                      //   }
                      // });
                    },
                    buttonType: ButtonType.blueBg,
                  ),
            YMargin(16.sp),
          ]),
        ),
      )),
    );
  }

  Column eachJobDescriptionItem(
      {required String title, required String subtitle}) {
    return Column(
      children: [
        Row(
          children: [
            TextOf(title, 16.sp, 4),
          ],
        ),
        YMargin(8.sp),
        Row(
          children: [
            Expanded(
              child: TextOf(
                subtitle,
                16.sp,
                6,
                align: TextAlign.left,
              ),
            ),
          ],
        ),
        YMargin(16.sp),
      ],
    );
  }
}
