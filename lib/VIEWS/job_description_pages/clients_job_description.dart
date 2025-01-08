// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:intl/intl.dart";
import 'package:project_bist/PROVIDERS/jobs_provider/jobs_provider.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/VIEWS/researchers_profile_screen/researchers_profile_screen.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/main.dart';

import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/MODELS/job_model/job_model.dart';

import "package:project_bist/MODELS/job_model/applicants_data.dart";
import "package:project_bist/MODELS/user_profile/user_profile.dart";

class ClientsJobDescription extends ConsumerStatefulWidget {
  static const String clientsJobDescription = "clientsJobDescription";
  final JobModel jobModel;
  const ClientsJobDescription({required this.jobModel, super.key});

  @override
  _ClientsJobDescriptionState createState() => _ClientsJobDescriptionState();
}

class _ClientsJobDescriptionState extends ConsumerState<ClientsJobDescription> {
  bool hasStoppedReceivingApplications = false, hasBegunEditing = false;
  String projectTitleSubtitleText = "";
  late TextEditingController editProjectTitleController;

  @override
  void initState() {
    setState(() {
      editProjectTitleController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    editProjectTitleController.dispose();
    super.dispose();
  }

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    JobModel jobModel = widget.jobModel;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
    return Scaffold(
      appBar: customAppBar(context,
          title: "Job", hasElevation: true, hasIcon: true),
      body: SafeArea(
          child: Padding(
        padding: appPadding(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            Card(
              elevation: isExpanded==true?0:6.r,
              surfaceTintColor: AppColors.brown1(context),
              color: AppColors.brown1(context),
              child: ExpansionTile(
                  childrenPadding: const EdgeInsets.all(0),
                  tilePadding: const EdgeInsets.all(0),
                  collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12.r),
                          topLeft: Radius.circular(12.r))),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  trailing: Icon(
                    !isExpanded ? Icons.expand_more : Icons.keyboard_arrow_up,
                    size: 33.sp,
                  ),
                  onExpansionChanged: (value) {
                    setState(() {
                      isExpanded = value;
                    });
                  },
                  title: Padding(
                    padding: EdgeInsets.only(left: 7.sp),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: TextOf(
                              jobModel.jobName!,
                              20.sp,
                              5,
                              align: TextAlign.left,
                            ))
                          ],
                        ),
                        YMargin(12.sp),
                        Row(
                          children: [
                            Expanded(
                                child: TextOf(
                              "Posted ${jobModel.createdAt}  •  ${ref.watch(switchUserProvider) == UserTypes.student ? "Student" : "Professional"}",
                              14,
                              4,
                              align: TextAlign.left,
                            ))
                          ],
                        ),
                        YMargin(12.sp),
                      ],
                    ),
                  ),
                  children: [
                    Container(
                        padding: EdgeInsets.all(12.sp),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.brown1(context),
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Column(children: [
                          /// [DON'T FORGET THIS>>>] subtitleBuilder(),
                          //     subtitleBuilder(),

                          // (jobModel.jobTitle ?? "--").isEmpty
                          //     ? Column(
                          //         children: [
                          //           subtitleBuilder(),
                          //           YMargin(16.sp)
                          //         ],
                          //       )
                          //     :
                          eachJobDescriptionItem(
                              title: "Project title",
                              subtitle: jobModel.jobTitle! == "--"
                                  ? "--No title added''--No title added"
                                  : ""),
                          eachJobDescriptionItem(
                              title: "Project description",
                              subtitle: jobModel.jobDescription!),
                          eachJobDescriptionItem(
                              title: "Estimation Technique",
                              subtitle: jobModel.estimationTechnique!),
                          eachJobDescriptionItem(
                              title: "Scope of Work",
                              subtitle: jobModel.jobScope!),
                          eachJobDescriptionItem(
                              title: "Work duration",
                              subtitle:
                                  "${jobModel.duration!} ${jobModel.durationType}"),
                        ])),
                  ]),
            ),

            /// [End of collapsable container: ExpansionTile]
            YMargin(16.sp),
            Row(
              children: [
                Expanded(
                    child: TextOf(
                  "Received Application (${(jobModel.researcherApplicantsData ?? []).length})",
                  14,
                  4,
                  align: TextAlign.left,
                  color: AppThemeNotifier.colorScheme(context).primary,
                ))
              ],
            ),
            YMargin(12.sp),
            (jobModel.researcherApplicantsData ?? []).isEmpty
                ? SizedBox(
                    width: 1.sw,
                    height: 0.1.sh,
                    child: Center(
                        child: TextOf(
                            "There are currently no applicants for this job!",
                            16.sp,
                            5)))
                : const SizedBox.shrink(),
            ...List.generate((jobModel.researcherApplicantsData ?? []).length,
                (index) {
              ResearcherData researcherData =
                  (jobModel.researcherApplicantsData ?? [])[index];
              Researcher researcher = researcherData.researcherId;
              return Column(children: [
                recentApplicationsItem(
                    researcherProfile: UserProfile(
                        id: researcher.id,
                        email: researcher.email,
                        fullName: researcher.fullName,
                        username: researcher.userName,
                        phoneNumber: researcher.phoneNumber,
                        avatar: researcher.avatar,
                        institutionName: researcher.institutionName,
                        institutionCategory: researcher.institutionCategory,
                        institutionOwnership: researcher.institutionOwnership,
                        faculty: researcher.faculty,
                        department: researcher.division,
                        division: researcher.division,
                        role: "researcher",
                        educationalLevel: researcher.educationLevel,
                        sector: researcher.sector,
                        experience: researcher.experience),
                    date: DateFormat.yMMMMd()
                        .format(researcherData.createdAt)
                        .toString()),
                index != (jobModel.numberOfApplications! - 1)
                    ? AppDivider()
                    : const SizedBox.shrink(),
                (index == jobModel.numberOfApplications! - 1)
                    ? YMargin(25.sp)
                    : const SizedBox.shrink()
              ]);
            }),
            (hasStoppedReceivingApplications == true ||
                    jobModel.openForApplication == false)
                ? Row(
                    children: [
                      Expanded(
                        child: TextOf(
                          "This job has stopped receiving applications from researchers",
                          16.sp,
                          6,
                          align: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : Button(
                    text: "Stop receiving Applications",
                    onPressed: () {
                      JobsProvider.clientDeactivateJobApplication(context, ref,
                              jobId: jobModel.id!)
                          .then((value) {
                        if (value.status == true) {
                          setState(() {
                            hasStoppedReceivingApplications = true;
                          });
                        }
                      });
                    },
                    buttonType: ButtonType.blueBg,
                  ),
            YMargin(25.sp),
          ]),
        ),
      )),
    );
  }

  recentApplicationsItem(
      {required UserProfile researcherProfile, required String date}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
            context, ResearchersProfileScreen.researchersProfileScreen,
            arguments: researcherProfile);
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextOf(
                      "${researcherProfile.fullName} applied for your job",
                      16,
                      5,
                      align: TextAlign.left))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconOf(
                Icons.arrow_forward_ios_rounded,
                size: 17.5,
                color: AppThemeNotifier.colorScheme(context).primary,
              )
            ],
          ),
          Row(
            children: [
              Expanded(child: TextOf(date, 12, 4, align: TextAlign.left))
            ],
          ),
        ],
      ),
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
