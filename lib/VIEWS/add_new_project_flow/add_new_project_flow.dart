// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/add_new_project_flow/confirm_post_screen.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/input_field_dialog.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewProjectFlowArgument {
  int index;
  bool transactionCompletedFlow;
  bool? isForJob;
  UserProfile? userProfile;
  AddNewProjectFlowArgument(
      {required this.index,
      required this.transactionCompletedFlow,
      this.isForJob,
      this.userProfile});
}

class AddNewProjectFlow extends ConsumerStatefulWidget {
  static const String addNewProjectFlow = "addNewProjectFlow";
  AddNewProjectFlowArgument? addNewProjectFlowArgument;
  static PageController pageController = PageController();
  AddNewProjectFlow({super.key, required this.addNewProjectFlowArgument});
  @override
  _AddNewProjectFlowState createState() => _AddNewProjectFlowState();
}

class _AddNewProjectFlowState extends ConsumerState<AddNewProjectFlow> {
  late TextEditingController studentHaveYouCompletedChapterController,
      attachFileController,
      jobNameController,
      professionalDoYouHaveATopicController,
      projectDescriptionController,
      estimationTechniqueController,
      jobDurationNumberController,
      periodFieldController,
      scopeOfWorkController,
      proposedBudgetController,
      proposedBudgetRangeOneController,
      proposedBudgetRangeTwoController,
      // reservedDaysController,
      projectTitleController;
  String? localUploadedFilePath;
  bool isFixedBudget = true;

  @override
  void initState() {
    setState(() {
      AddNewProjectFlow.pageController = PageController();
      studentHaveYouCompletedChapterController = TextEditingController();
      jobNameController = TextEditingController();
      attachFileController = TextEditingController();
      professionalDoYouHaveATopicController = TextEditingController();
      projectDescriptionController = TextEditingController();
      estimationTechniqueController = TextEditingController();
      jobDurationNumberController = TextEditingController();
      periodFieldController = TextEditingController();
      scopeOfWorkController = TextEditingController();
      proposedBudgetController = TextEditingController();
      // reservedDaysController = TextEditingController();
      projectTitleController = TextEditingController();
      proposedBudgetRangeOneController = TextEditingController();
      proposedBudgetRangeTwoController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    AddNewProjectFlow.pageController.dispose();
    studentHaveYouCompletedChapterController.dispose();
    jobNameController.dispose();
    attachFileController.dispose();
    professionalDoYouHaveATopicController.dispose();
    projectDescriptionController.dispose();
    estimationTechniqueController.dispose();
    jobDurationNumberController.dispose();
    periodFieldController.dispose();
    scopeOfWorkController.dispose();
    proposedBudgetController.dispose();
    //reservedDaysController.dispose();
    projectTitleController.dispose();
    proposedBudgetRangeOneController.dispose();
    proposedBudgetRangeTwoController.dispose();

    super.dispose();
  }

  Widget firstSlide() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Row(children: [
            TextOf(
              "Job name",
              16,
              5,
              align: TextAlign.left,
            )
          ]),
          Row(children: [
            TextOf(
              "(Unique Name for your Project)",
              12,
              4,
              align: TextAlign.left,
            )
          ]),
          YMargin(8.sp),
          InputField(
              hintText: "Type job name",
              maxLength: 15,
              showWordCount: true,
              fieldController: jobNameController),
          YMargin(16.sp),
          ref.watch(switchUserProvider) == UserTypes.student
              ? InputFieldDialog(
                  optionList: const ["Yes", "No"],
                  hintText: "Select a response",
                  fieldTitle: "Have you completed chapters 1-2?",
                  fieldController: studentHaveYouCompletedChapterController,
                )
              : const SizedBox.shrink(),
          YMargin(16.sp),
          studentHaveYouCompletedChapterController.text.isNotEmpty
              ? hasCompletedChaptersMessage(
                  studentHaveYouCompletedChapterController.text)
              : Column(children: [
                  YMargin(10.sp),
                  Row(
                    children: [
                      TextOf("Job name Examples", 16.sp, 5),
                    ],
                  ),
                  YMargin(16.sp),
                  ...[
                    "Project 209",
                    "Final Project",
                    "Energy Assignment",
                    "XYZ Group work"
                  ]
                      .map((e) => Column(
                            children: [
                              Row(
                                children: [
                                  TextOf("• $e", 16.sp, 4),
                                ],
                              ),
                              YMargin(4.sp)
                            ],
                          ))
                      
                ])
        ],
      ),
    );
  }

  Widget secondSlide() {
    File? upload;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(children: [
        ref.watch(switchUserProvider) == UserTypes.professional
            ? Column(
                children: [
                  InputFieldDialog(
                    optionList: const ["Yes", "No"],
                    hintText: "Select a response",
                    fieldTitle: "Do you have a topic?",
                    fieldController: professionalDoYouHaveATopicController,
                    onChanged: (value) {
                      if (professionalDoYouHaveATopicController.text
                              .toLowerCase() ==
                          "no") {
                        projectTitleController.clear();
                      }
                    },
                  ),
                ],
              )
            : const SizedBox.shrink(),
        ref.watch(switchUserProvider) == UserTypes.student
            ? InputField(
                fieldTitle: "Attach paper file",
                readOnly: true,
                onTap: () {
                  getIt<AppModel>().uploadFile(context, allowedExtensions: [
                    "docx",
                    "pdf",
                    "txt",
                    "pptx",
                    "jpg"
                  ]).then((value) {
                    setState(() {
                      upload = value;
                      localUploadedFilePath = upload!.path;
                      attachFileController.text = upload!.path.split("/").last;
                    });
                  }).then((value) {
                    setState(() {});
                  });
                },
                onChanged: (value) {},
                hintText: "Attach a file here",
                inputType: TextInputType.none,
                showCursor: false,
                suffixIcon: Image.asset(
                  ImageOf.fileAttachmnentIcon,
                  height: 20.sp,
                ),
                fieldController: attachFileController)
            : const SizedBox.shrink(),
        YMargin(16.sp),
        professionalDoYouHaveATopicController.text.toLowerCase() == "no"
            ? const SizedBox.shrink()
            : InputField(
                hintText: "Type job title",
                fieldTitle: "Project title",
                fieldController: projectTitleController),
        YMargin(16.sp),
        InputField(
          hintText: "Type project description",
          fieldTitle: "Project description",
          maxLines: 4,
          fieldController: projectDescriptionController,
        ),
        YMargin(16.sp),
        ref.watch(switchUserProvider) == UserTypes.professional
            ? InputField(
                fieldTitle: "Upload resources",
                isOptional: true,
                readOnly: true,
                onTap: () {
                  getIt<AppModel>().uploadFile(context, allowedExtensions: [
                    "docx",
                    "pdf",
                    "txt",
                    "pptx",
                  ]).then((value) {
                    setState(() {
                      upload = value;
                      localUploadedFilePath = upload!.path;
                      attachFileController.text = upload!.path.split("/").last;
                    });
                  });
                },
                onChanged: (value) {},
                hintText: "Click to upload file", //UploadToCloudinaryProvider
                inputType: TextInputType.none,
                showCursor: false,
                suffixIcon: Image.asset(
                  ImageOf.fileAttachmnentIcon,
                  height: 20.sp,
                ),
                fieldController: attachFileController)
            : const SizedBox.shrink(),
        YMargin(24.sp),
        TextOf(
          "Your project description could be a brief summary of direction of research or an additional insight to provide more information for the researcher.",
          14.sp,
          5,
          align: TextAlign.left,
        )
      ]),
    );
  }

  Widget thirdSlide() {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            YMargin(14.sp),
            InputField(
              fieldTitle: "Estimation Technique",
              hintText: "e.g. Descriptive Analysis",
              inputType: TextInputType.text,
              fieldController: estimationTechniqueController,
            ),

            YMargin(16.sp),

            InputField(
              fieldTitle: "Scope of work",
              hintText: "e.g. Chapter 4, Feasibility Study",
              inputType: TextInputType.text,
              fieldController: scopeOfWorkController,
            ),
            // InputFieldDialog(
            //     fieldTitle: "Scope of work",
            //     fieldController: scopeOfWorkController,
            //     hintText: "Select an option",
            //     optionList: const [
            //       "Chapter 1-3",
            //       "Chapter 3-5",
            //       "Chapter 5-7",
            //     ]),
            YMargin(16.sp),
            Row(
              children: [
                TextOf(
                  "Job duration",
                  16,
                  5,
                  align: TextAlign.left,
                  color: AppThemeNotifier.colorScheme(context).primary,
                ),
              ],
            ),
            YMargin(8.sp),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: InputField(
                    fieldController: jobDurationNumberController,
                    hintText: "1",
                    inputType: TextInputType.number,
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox.shrink()),
                Expanded(
                  flex: 24,
                  child: InputFieldDialog(
                      fieldController: periodFieldController,
                      hintText: "Period",
                      optionList: [
                        "days",
                        "weeks",
                        "months",
                        "years",
                      ]
                          .map((e) =>
                              e.toUpperCase()[0] + e.toLowerCase().substring(1))
                          .toList()),
                )
              ],
            ),
            YMargin(16.sp),
            // InputFieldDialog(
            //     fieldController: reservedDaysController,
            //     hintText: "Select an option",
            //     fieldTitle: "Reserved days",
            //     titleIcon: ElTooltip(
            //         color: AppThemeNotifier.themeColor(context)
            //             .scaffoldBackgroundColor,
            //         position: ElTooltipPosition.rightEnd,
            //         showArrow: false,
            //         content: TextOf(
            //             "This shows the number of days you\nwill like to reserve within the job\nduration for any contingencies",
            //             10.sp,
            //             4),
            //         child: IconOf(Icons.info_outline, size: 15.sp)),
            //     optionList: const ["3 days", "5 days", "7 days", "10 days"]),
            YMargin(16.sp),
            proposedBudget(isFixedBudget: isFixedBudget),
            YMargin(8.sp),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isFixedBudget = !isFixedBudget;
                    });
                  },
                  child: IconOf(isFixedBudget == false
                      ? Icons.check_box_outline_blank
                      : Icons.check_box_rounded),
                ),
                XMargin(3.sp),
                TextOf("Fixed Budget", 16.sp, 4)
              ],
            ),
            // InputField(
            //     fieldTitle: "Proposed budget",
            //     inputType: TextInputType.number,
            //     prefixIcon: TextOf(AppConst.COUNTRY_CURRENCY, 16,
            //         proposedBudgetController.text.isEmpty ? 4 : 5),
            //     fieldController: proposedBudgetController),
            YMargin(0.1.sh),
          ],
        ));
  }

  bool whenItsStudent() {
    if (ref.watch(switchUserProvider) == UserTypes.student) {
      if (widget.addNewProjectFlowArgument!.index == 0) {
        return (jobNameController.text.isNotEmpty &&
            studentHaveYouCompletedChapterController.text.toLowerCase() ==
                "yes");
      } else if (widget.addNewProjectFlowArgument!.index == 1) {
        return (attachFileController.text.isNotEmpty &&
                projectTitleController.text.isNotEmpty
            // &&
            // projectDescriptionController.text.isNotEmpty
            );
      } else if (widget.addNewProjectFlowArgument!.index == 2) {
        return (
            // scopeOfWorkController.text.isNotEmpty
            // &&
            jobDurationNumberController.text.isNotEmpty &&
                periodFieldController.text.isNotEmpty &&
                // reservedDaysController.text.isNotEmpty &&
                (isFixedBudget == false
                    ? (proposedBudgetRangeOneController.text.isNotEmpty &&
                        proposedBudgetRangeTwoController.text.isNotEmpty)
                    : proposedBudgetController.text.isNotEmpty));
      }
    }
    return false;
  }

  bool whenItsProfessional() {
    if (ref.watch(switchUserProvider) == UserTypes.professional) {
      if (widget.addNewProjectFlowArgument!.index == 0) {
        return (jobNameController.text.isNotEmpty);
      } else if (widget.addNewProjectFlowArgument!.index == 1) {
        return (professionalDoYouHaveATopicController.text.isNotEmpty);
      } else if (widget.addNewProjectFlowArgument!.index == 2) {
        return (
            // scopeOfWorkController.text.isNotEmpty &&
            jobDurationNumberController.text.isNotEmpty &&
                periodFieldController.text.isNotEmpty &&
                // reservedDaysController.text.isNotEmpty &&
                (isFixedBudget == false
                    ? (proposedBudgetRangeOneController.text.isNotEmpty &&
                        proposedBudgetRangeTwoController.text.isNotEmpty)
                    : proposedBudgetController.text.isNotEmpty));
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    return Scaffold(
        appBar: customAppBar(
          context,
          title:
              "${ref.watch(switchUserProvider) == UserTypes.student ? "Request" : "Job"} Details",
          hasIcon: true,
          hasElevation: true,
          onTap: () {
            widget.addNewProjectFlowArgument!.index == 0
                ? Navigator.pop(context)
                : AddNewProjectFlow.pageController.animateToPage(
                    widget.addNewProjectFlowArgument!.index - 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
          },
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.sp),
              child: TextOf(
                  "${widget.addNewProjectFlowArgument!.index + 1} of 3 Pages",
                  14,
                  4),
            ),
          ],
        ),
        body: Padding(
          padding: appPadding().add(EdgeInsets.only(bottom: 15.sp)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextOf(
                    "Kindly fill this information to submit your request.",
                    16,
                    5,
                    align: TextAlign.left,
                  ))
                ],
              ),
              YMargin(10.sp),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox.expand(
                      child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: AddNewProjectFlow.pageController,
                          onPageChanged: (index) {
                            setState(() {
                              widget.addNewProjectFlowArgument!.index = index;
                            });
                          },
                          children: [
                            firstSlide(),
                            secondSlide(),
                            thirdSlide()
                          ]),
                    ),
                    Button(
                      text: 'Next',
                      buttonType: whenItsStudent() || whenItsProfessional()
                          ? ButtonType.blueBg
                          : ButtonType.disabled,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (professionalDoYouHaveATopicController.text
                                .toLowerCase() ==
                            "no") {
                          projectTitleController.clear();
                        }
                        widget.addNewProjectFlowArgument!.index == 2
                            ? Navigator.pushNamed(
                                context,
                                ConfirmPostScreen.confirmPostScreen,
                                arguments: ConfirmPostScreenArgument(
                                  isForJob: widget.addNewProjectFlowArgument!
                                          .isForJob ??
                                      true,
                                  userProfile: widget
                                      .addNewProjectFlowArgument!.userProfile,
                                  transactionCompletedFlow: widget
                                      .addNewProjectFlowArgument!
                                      .transactionCompletedFlow,
                                  jobName: jobNameController.text,
                                  projectTitle: projectTitleController.text,
                                  projectDescription:
                                      projectDescriptionController
                                              .text.isNotEmpty
                                          ? projectDescriptionController.text
                                          : 'N/A',
                                  resourcesText: localUploadedFilePath ?? "--",
                                  estimationTechnique:
                                      estimationTechniqueController
                                              .text.isNotEmpty
                                          ? estimationTechniqueController.text
                                          : 'N/A',
                                  scopeOfWork:
                                      scopeOfWorkController.text.isNotEmpty
                                          ? scopeOfWorkController.text
                                          : 'N/A',
                                  jobDurationNumber:
                                      jobDurationNumberController.text,
                                  periodField: periodFieldController.text,
                                  isFixedBudget: isFixedBudget,
                                  proposedFixedBudget:
                                      proposedBudgetController.text,
                                  proposedBudgetRangeOne:
                                      proposedBudgetRangeOneController.text,
                                  proposedBudgetRangeTwo:
                                      proposedBudgetRangeTwoController.text,
                                ),
                              )
                            : AddNewProjectFlow.pageController.animateToPage(
                                widget.addNewProjectFlowArgument!.index + 1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget hasCompletedChaptersMessage(String option) {
    String text = option.toLowerCase();
    return Column(children: [
      YMargin(10.sp),
      TextOf(
          text == "no"
              ? "Request Prerequisite Not Met!"
              : "Please upload your chapters 1-2 in the next section.",
          16,
          5,
          color: text == "no" ? AppColors.red : null),
      YMargin(10.sp),
      text == "no"
          ? RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppThemeNotifier.colorScheme(context).primary,
                    fontSize: 16.sp),
                children: [
                  const TextSpan(
                    text:
                        "Completion of chapters (1-2) is prerequisite to submit an assistance request\n\n",
                  ),
                  const TextSpan(
                    text: "Refer to relevant materials under",
                  ),
                  TextSpan(
                      text: " “Menu > Research Note”",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16.sp)),
                  const TextSpan(
                    text: " or explore and purchase publications for reference",
                  ),
                ],
              ),
            )
          : TextOf(
              "This will allow researchers to review your work and provide you with the most effective assistance.",
              14,
              4,
              align: TextAlign.center,
            )
    ]);
  }

  Widget proposedBudget({required bool isFixedBudget}) {
    if (isFixedBudget == true) {
      return InputField(
          fieldTitle: "Proposed budget",
          inputType: TextInputType.number,
          prefixIcon: TextOf(AppConst.COUNTRY_CURRENCY, 16,
              proposedBudgetController.text.isEmpty ? 4 : 5),
          fieldController: proposedBudgetController);
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            TextOf(
              "Proposed budget",
              16,
              5,
              align: TextAlign.left,
              color: AppThemeNotifier.colorScheme(context).primary,
            )
          ]),
          YMargin(8.sp),
          Row(
            children: [
              Expanded(
                  flex: 6,
                  child: InputField(
                      inputType: TextInputType.number,
                      prefixIcon: TextOf(AppConst.COUNTRY_CURRENCY, 16,
                          proposedBudgetController.text.isEmpty ? 4 : 5),
                      fieldController: proposedBudgetRangeOneController)),
              Expanded(flex: 1, child: TextOf("to", 16.sp, 4)),
              Expanded(
                  flex: 6,
                  child: InputField(
                      inputType: TextInputType.number,
                      prefixIcon: TextOf(AppConst.COUNTRY_CURRENCY, 16,
                          proposedBudgetController.text.isEmpty ? 4 : 5),
                      fieldController: proposedBudgetRangeTwoController))
            ],
          )
        ],
      );
    }
  }
}
