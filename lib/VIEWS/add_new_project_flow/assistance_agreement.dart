// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/job_model/job_model.dart';
import 'package:project_bist/PROVIDERS/cloudinary_upload/cloudinary_upload.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';
import 'package:project_bist/PROVIDERS/jobs_provider/jobs_provider.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';

class AssistanceAgreementFlowArgument {
  final JobModel jobModel;
  final bool isFixedBudget;
  bool? isForJobOrNot;
  UserProfile? userProfile;
  AssistanceAgreementFlowArgument(
      {required this.isFixedBudget,
      required this.jobModel,
      this.userProfile,
      this.isForJobOrNot = true});
}

class AssistanceAgreementFlow extends ConsumerStatefulWidget {
  static const String assistanceAgreementFlow = "assistanceAgreementFlow";
  final AssistanceAgreementFlowArgument assistanceAgreementFlowArgument;
  const AssistanceAgreementFlow({
    required this.assistanceAgreementFlowArgument,
    super.key,
  });
  @override
  _AssistanceAgreementFlowState createState() =>
      _AssistanceAgreementFlowState();
}

class _AssistanceAgreementFlowState
    extends ConsumerState<AssistanceAgreementFlow> {
  int initialIndex = 0;
  late PageController pageController;
  UserTypes? userType;
  @override
  void initState() {
    setState(() {
      pageController = PageController();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        userType = ref.watch(switchUserProvider);
      });
    });
    return Scaffold(
        appBar: customAppBar(context,
            title:
                "${ref.watch(switchUserProvider) == UserTypes.student ? "Assistance" : "Job"} Agreement",
            hasIcon: true,
            hasElevation: true),
        body: Padding(
            padding: appPadding().copyWith(bottom: 20.sp),
            child: Column(children: [
              Row(children: [
                Expanded(
                  child: TextOf(
                    "Please read the agreement conditions below and acknowledge that you agree to submit your request.",
                    14.sp,
                    5,
                    align: TextAlign.left,
                    color: AppColors.brown,
                  ),
                )
              ]),
              YMargin(5.sp),
              SizedBox(
                height: 0.7.sh,
                child: PageView.builder(
                    itemCount: 6,
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        initialIndex = value;
                      });
                    },
                    itemBuilder: (context, index) => Column(
                          children: [
                            Row(children: [
                              Expanded(
                                child: TextOf(
                                  switch (index) {
                                    0 =>
                                      "I agree to research Assistance, confidentiality and non-disclosure.",
                                    1 =>
                                      "I agree to researcher recognition and ethical use.",
                                    2 =>
                                      "I agree to payment, compensation and research ownership.",
                                    3 =>
                                      "I agree to academic honesty and respect for deadlines.",
                                    4 =>
                                      "I agree with platform integrity and legal consequences.",
                                    5 => "Acknowledgment and Agreement",
                                    _ => ""
                                  },
                                  16.sp,
                                  5,
                                  align: TextAlign.left,
                                ),
                              )
                            ]),
                            YMargin(16.sp),
                            Row(
                              children: [
                                Expanded(
                                    child: TextOf(
                                        switch (index) {
                                          0 =>
                                            "1. Research Assistance: - ProjectBist is designed to connect students with Researchers to assist in academic research projects. - You may request services such as literature reviews, data analysis, and guidance in accordance with academic integrity standards.\n\n2. Confidentiality and Nondisclosure: - You understand that all information shared during your research collaboration is confidential. You agree not to disclose or misuse any Confidential Information shared by Researchers.",
                                          1 =>
                                            "3. Researcher Recognition: - You recognise and agree to acknowledge the contributions of the Researchers in your research work, including but not limited to the acknowledgment section or any relevant part of your research paper.\n\n4. Ethical Use: - You agree to use the research assistance for academic and ethical purposes only. You will not engage in plagiarism or any form of academic dishonesty.",
                                          2 =>
                                            "5. Payment and Compensation: - You will pay Researchers for their services as agreed upon, based on the scope of work and complexity of the research project.\n\n6. Research Ownership: - You retain ownership of your research project and the final work        product. Researchers provide assistance and guidance but do not claim ownership of your work.",
                                          3 =>
                                            "7. No Academic Dishonesty: - You acknowledge that using the platform to engage in academic dishonesty, such as submitting work as your own without proper attribution, is strictly prohibited.\n\n8. Respect for Deadlines: - You agree to set realistic deadlines for Researchers and respect the agreed-upon timeline for the completion of your research project.",
                                          4 =>
                                            "9. Platform Integrity: - You will use the platform for its intended purpose and not engage in any fraudulent or harmful activities that may compromise the integrity of ProjectBist.\n\n10. Legal Consequences: - You understand that any breach of this agreement may result in legal consequences and may lead to your suspension or removal from ProjectBist.",
                                          5 =>
                                            "By using ProjectBist, you acknowledge your commitment to ethical research practices, respect for Researchers; contributions, and adherence to the terms outlined in this agreement.",
                                          _ => ""
                                        },
                                        18.sp,
                                        4,
                                        align: TextAlign.left))
                              ],
                            )
                          ],
                        )),
              ),
              Expanded(
                  child: initialIndex == 5
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Button(
                              text: "Continue",
                              buttonType: ButtonType.blueBg,
                              onPressed: () {
                                setState(() {
                                  widget.assistanceAgreementFlowArgument
                                          .jobModel.fileName =
                                      widget.assistanceAgreementFlowArgument
                                          .jobModel.resource!
                                          .split("/")
                                          .last;
                                });
                                if (((widget.assistanceAgreementFlowArgument
                                                .jobModel.resource ??
                                            "")
                                        .replaceAll("--", "")
                                        .isNotEmpty) &&
                                    !(widget.assistanceAgreementFlowArgument
                                                .jobModel.resource ??
                                            "")
                                        .contains("http://")) {
                                  UploadToCloudinaryProvider.uploadDocument(
                                          context,
                                          loadingMessage:
                                              "Handling uploaded document...",
                                          localFilePath: widget
                                              .assistanceAgreementFlowArgument
                                              .jobModel
                                              .resource!)
                                      .then((value) {
                                    setState(() {
                                      widget.assistanceAgreementFlowArgument
                                          .jobModel.resource = value;
                                      widget.assistanceAgreementFlowArgument
                                          .jobModel.chapters = value;
                                    });
                                    print(widget.assistanceAgreementFlowArgument
                                        .jobModel.chapters);

                                    if (value.isNotEmpty &&
                                        widget.assistanceAgreementFlowArgument
                                                .isForJobOrNot ==
                                            true) {
                                      JobsProvider.clientPostJob(context, ref,
                                          jobModel: widget
                                              .assistanceAgreementFlowArgument
                                              .jobModel,
                                          isFixedBudget: widget
                                              .assistanceAgreementFlowArgument
                                              .isFixedBudget);
                                    }
                                  });
                                } else if (widget
                                        .assistanceAgreementFlowArgument
                                        .isForJobOrNot ==
                                    true) {
                                  JobsProvider.clientPostJob(context, ref,
                                      jobModel: widget
                                          .assistanceAgreementFlowArgument
                                          .jobModel,
                                      isFixedBudget: widget
                                          .assistanceAgreementFlowArgument
                                          .isFixedBudget);
                                } else {
                                  if ((widget.assistanceAgreementFlowArgument
                                              .jobModel.jobTitle ??
                                          "")
                                      .isEmpty) {
                                    widget.assistanceAgreementFlowArgument
                                        .jobModel.jobTitle = "--";
                                  }
                                  EscrowProvider.createEscrowAsYouGoo(context,
                                      ref: ref,
                                      researcherId: widget
                                          .assistanceAgreementFlowArgument
                                          .userProfile!
                                          .id!,
                                      jobModel: widget
                                          .assistanceAgreementFlowArgument
                                          .jobModel,
                                      isFixedBudget: widget
                                          .assistanceAgreementFlowArgument
                                          .isFixedBudget,
                                      userProfile: widget
                                          .assistanceAgreementFlowArgument
                                          .userProfile!);
                                }
                              },
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    pageController.animateToPage(
                                        initialIndex + 1,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconOf(
                                          Icons
                                              .check_box_outline_blank_outlined,
                                          color: AppThemeNotifier.colorScheme(
                                                  context)
                                              .primary),
                                      XMargin(5.sp),
                                      TextOf("I agree", 16.sp, 4)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            YMargin(15.sp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                  6,
                                  (index) => Container(
                                        height: 4,
                                        width: 0.14.sw,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            color: initialIndex >= index
                                                ? AppColors.primaryColor
                                                : AppColors.secondaryColor),
                                      )),
                            )
                          ],
                        ))
            ])));
  }
}
