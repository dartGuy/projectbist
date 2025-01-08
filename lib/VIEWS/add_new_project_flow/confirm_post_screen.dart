import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/job_model/job_model.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/add_new_project_flow/add_new_project_flow.dart';
import 'package:project_bist/VIEWS/add_new_project_flow/assistance_agreement.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmPostScreenArgument {
  String? projectTitle;
  final String jobName,
      projectDescription,
      resourcesText,
      estimationTechnique,
      scopeOfWork,
      proposedFixedBudget,
      proposedBudgetRangeOne,
      proposedBudgetRangeTwo,
      periodField,
      jobDurationNumber;
  bool transactionCompletedFlow, isFixedBudget;
  bool? isForJob;
  UserProfile? userProfile;
  ConfirmPostScreenArgument({
    required this.transactionCompletedFlow,
    required this.jobName,
    this.projectTitle,
    required this.projectDescription,
    required this.resourcesText,
    required this.estimationTechnique,
    required this.scopeOfWork,
    // required this.reservedDays,
    required this.isFixedBudget,
    required this.proposedFixedBudget,
    required this.proposedBudgetRangeOne,
    required this.proposedBudgetRangeTwo,
    required this.periodField,
    required this.jobDurationNumber,
    this.userProfile,
    this.isForJob,
  });
}

class ConfirmPostScreen extends ConsumerStatefulWidget {
  static const String confirmPostScreen = 'confirmPostScreen';
  final ConfirmPostScreenArgument confirmPostScreenArgument;
  const ConfirmPostScreen({required this.confirmPostScreenArgument, super.key});

  @override
  ConsumerState<ConfirmPostScreen> createState() => _ConfirmPostScreenState();
}

class _ConfirmPostScreenState extends ConsumerState<ConfirmPostScreen> {
  // bool hasBegunEditing = false;
  // late TextEditingController editProjectTitleController;

  // @override
  // void initState() {
  //   setState(() {
  //     editProjectTitleController = TextEditingController();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final ConfirmPostScreenArgument data = widget.confirmPostScreenArgument;
    // if (mounted) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     setState(() {});
    //   });
    // }
    // Widget cancelIcon() {
    //   if (editProjectTitleController.text.isNotEmpty) {
    //     return InkWell(
    //       onTap: () {
    //         editProjectTitleController.clear();
    //       },
    //       child: IconOf(
    //         Icons.close,
    //         color: AppThemeNotifier.colorScheme(context).primary,
    //       ),
    //     );
    //   } else {
    //     return const SizedBox.shrink();
    //   }
    // }

    // Widget doneButton() {
    //   List<String> words = editProjectTitleController.text.split(" ");
    //   words.removeWhere((element) => element == "" || element == " ");
    //   int wordLength = words.length;
    //   if (wordLength > 1) {
    //     return SmallButton(
    //       text: "Done",
    //       onTapped: () {
    //         setState(() {
    //           data.projectTitle = editProjectTitleController.text;
    //         });
    //       },
    //     );
    //   } else {
    //     return const SizedBox.shrink();
    //   }
    // }

    // InputField() {
    //   List<String> words = editProjectTitleController.text.split(" ");
    //   words.removeWhere((element) => element == "" || element == " ");
    //   int wordLength = words.length;
    //   return Column(
    //     children: [
    //       TextFormField(
    //         onChanged: (e) {},
    //         controller: editProjectTitleController,
    //         cursorColor: AppColors.primaryColor,
    //         onTap: () {},
    //         keyboardType: TextInputType.text,
    //         style: TextStyle(
    //             fontFamily: Fonts.nunito,
    //             fontSize: 16,
    //             fontWeight: FontWeight.w400,
    //             color: AppThemeNotifier.colorScheme(context).primary,
    //             decoration: TextDecoration.none,
    //             decorationColor: Colors.transparent),
    //         decoration: InputDecoration(
    //           fillColor:
    //               AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
    //           filled: true,
    //           contentPadding:
    //               EdgeInsets.symmetric(vertical: 6.sp, horizontal: 10.sp),
    //           hintText: "Type your project title...",
    //           hintStyle: TextStyle(
    //               fontFamily: Fonts.nunito,
    //               color: AppColors.grey3,
    //               fontWeight: FontWeight.w500,
    //               fontSize: 15.sp),
    //           suffix: Row(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisSize: MainAxisSize.min,
    //             children: [cancelIcon(), doneButton()],
    //           ),
    //           enabledBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(12.r),
    //               borderSide: BorderSide.none),
    //           focusedBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(12.r),
    //               borderSide: BorderSide.none),
    //         ),
    //       ),
    //       wordLength > 1
    //           ? const SizedBox.shrink()
    //           : Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 YMargin(4.sp),
    //                 Row(
    //                   children: [
    //                     TextOf("Enter at least two words", 10.sp, 4,
    //                         color: isDarkTheme(context)
    //                             ? AppColors.grey1
    //                             : AppColors.grey3)
    //                   ],
    //                 ),
    //               ],
    //             ),
    //     ],
    //   );
    // }

    // Widget subtitleBuilder() {
    //   if ((data.projectTitle ?? "").isNotEmpty) {
    //     return Row(
    //       mainAxisSize: MainAxisSize.min,
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Expanded(
    //           flex: 15,
    //           child: eachJobDescriptionItem(
    //               title: "Project title", subtitle: data.projectTitle!),
    //         ),
    //         Expanded(
    //           flex: 1,
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             children: [
    //               InkWell(
    //                   onTap: () {
    //                     setState(() {
    //                       hasBegunEditing = true;
    //                       editProjectTitleController.text = data.projectTitle!;
    //                       //data.projectTitle = "";
    //                     });
    //                   },
    //                   child: Image.asset(ImageOf.editIconn, height: 19.sp)),
    //             ],
    //           ),
    //         )
    //         //projectTitleSubtitleText
    //       ],
    //     );
    //   } else if (hasBegunEditing == true) {
    //     return InputField();
    //   } else {
    //     return Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    // TextOf(
    //   "You do not have a topic yet!",
    //   16,
    //   6,
    //   color: AppColors.brown,
    // ),
    // InkWell(
    //     onTap: () {
    //       setState(() {
    //         hasBegunEditing = true;
    //       });
    //             },
    //             child: Image.asset(ImageOf.editIconn, height: 19.sp))
    //       ],
    //     );
    //   }
    // }

    return Scaffold(
        appBar: customAppBar(context,
            title: "Confirm", hasElevation: true, hasIcon: true),
        body: Padding(
          padding: appPadding(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20.sp),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.brown1(context),
                      borderRadius: BorderRadius.circular(12.r)),
                  child: Column(children: [
                    eachJobDescriptionItem(
                        title: "Job name", subtitle: data.jobName),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                          onTap: () {
                            //
                            // setState(() => AddNewProjectFlow.index = 0);
                            Navigator.pop(context);
                            AddNewProjectFlow.pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.sp),
                            child:
                                Image.asset(ImageOf.editIconn, height: 19.sp),
                          ))
                    ]),
                    AppDivider(
                      color: AppColors.grey2,
                    ),
                    (data.projectTitle ?? "").isEmpty
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextOf(
                                    "You do not have a topic yet!",
                                    16,
                                    6,
                                    color: AppColors.brown,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        AddNewProjectFlow.pageController
                                            .animateToPage(1,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeInOut);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.sp),
                                        child: Image.asset(ImageOf.editIconn,
                                            height: 19.sp),
                                      ))
                                ],
                              ),
                              YMargin(16.sp)
                            ],
                          )
                        : eachJobDescriptionItem(
                            title: "Project title",
                            subtitle: data.projectTitle!),
                    eachJobDescriptionItem(
                        title: "Project description",
                        subtitle: data.projectDescription),
                    eachJobDescriptionItem(
                        title:
                            ref.watch(switchUserProvider) == UserTypes.student
                                ? "Completed chapters file"
                                : "Resources",
                        subtitle: data.resourcesText.split("/").last),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            AddNewProjectFlow.pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.sp),
                            child:
                                Image.asset(ImageOf.editIconn, height: 19.sp),
                          ))
                    ]),
                    AppDivider(
                      color: AppColors.grey2,
                    ),
                    eachJobDescriptionItem(
                        title: "Estimation Technique",
                        subtitle: data.estimationTechnique),
                    eachJobDescriptionItem(
                        title: "Scope of work", subtitle: data.scopeOfWork),
                    // eachJobDescriptionItem(
                    //     title: "Work duration",
                    //     subtitle: "${data.jobName} ${data.periodField}"),
                    // eachJobDescriptionItem(
                    //     title: "Reserved Days", subtitle: data.reservedDays),
                    eachJobDescriptionItem(
                        title: "Work duration",
                        subtitle:
                            "${data.jobDurationNumber} ${data.periodField}"),
                    eachJobDescriptionItem(
                        title: "Proposed budget",
                        subtitle: data.isFixedBudget
                            ? "${AppConst.COUNTRY_CURRENCY} ${data.proposedFixedBudget}"
                            : "${AppConst.COUNTRY_CURRENCY} ${data.proposedBudgetRangeOne} - ${AppConst.COUNTRY_CURRENCY} ${data.proposedBudgetRangeTwo}"),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            AddNewProjectFlow.pageController.animateToPage(2,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.sp),
                            child:
                                Image.asset(ImageOf.editIconn, height: 19.sp),
                          ))
                    ]),
                  ]),
                ),
                YMargin(40.sp),
                Button(
                  text: "Submit",
                  buttonType: ButtonType.blueBg,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AssistanceAgreementFlow.assistanceAgreementFlow,
                      arguments: AssistanceAgreementFlowArgument(
                        userProfile: data.userProfile,
                        isForJobOrNot: data.isForJob ?? true,
                        isFixedBudget: data.isFixedBudget,
                        jobModel: JobModel(
                          jobName: data.jobName,
                          jobTitle: data.projectTitle,
                          jobDescription: data.projectDescription,
                          resource: data.resourcesText,
                          chapters: data.resourcesText,
                          estimationTechnique: data.estimationTechnique,
                          jobScope: data.scopeOfWork,
                          fixedBudget: data.isFixedBudget == false
                              ? null
                              : int.tryParse(data.proposedFixedBudget),
                          durationType: data.periodField.toLowerCase(),
                          duration: int.tryParse(data.jobDurationNumber),
                          minBudget: data.isFixedBudget == false
                              ? int.tryParse(data.proposedBudgetRangeOne)
                              : null,
                          maxBudget: data.isFixedBudget == false
                              ? int.tryParse(data.proposedBudgetRangeTwo)
                              : null,
//       required this.reservedDays,
//       required this.isFixedBudget,
//'
//       required this.proposedBudgetRangeTwo,
                        ),
                      ),
                    );
                  },
                ),
                YMargin(20.sp),
              ],
            ),
          ),
        ));
  }

  Widget eachJobDescriptionItem(
      {required String title, required String subtitle}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.sp),
      child: Column(
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
      ),
    );
  }
}
