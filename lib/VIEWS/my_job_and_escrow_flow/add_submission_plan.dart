import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_with_submission_paln_model.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/widgets/texts.dart';
import 'package:project_bist/VIEWS/my_job_and_escrow_flow/fund_escrow_screen.dart';
import 'package:project_bist/UTILS/methods.dart';

import '../../UTILS/constants.dart';

class SubscriptionPlanScreenArgument {
  SubscriptionPlanScreenArgument(
      {required this.escrowData,
      required this.requiredStartDate,
      required this.requiredEndDate,
      required this.totalPriceOfAvailableSubmissions});

  final EscrowWithSubmissionPlanModel escrowData;
  final String requiredStartDate, requiredEndDate;
  final int totalPriceOfAvailableSubmissions;
}

class SubscriptionPlanScreen extends ConsumerStatefulWidget {
  const SubscriptionPlanScreen({super.key, required this.argument});

  static const String subscriptionPlanScreen = "subscriptionPlanScreen";

  final SubscriptionPlanScreenArgument argument;

  @override
  ConsumerState<SubscriptionPlanScreen> createState() =>
      _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState
    extends ConsumerState<SubscriptionPlanScreen> {
  late TextEditingController batchNameController,
      batchDeliverablesController,
      batchSubmissionPriceController;

  DateTime date1 = DateTime.now();
  int dayDifference = 0;
  bool isValidDate = false;
  //, date2 = DateTime.now();
  late TextEditingController tdDayController,
      tdMonthController,
      tdYearController,
      pdDayController,
      pdMonthController,
      pdYearController;

  DateTime selectedTargetDate = DateTime.now();

  @override
  void dispose() {
    batchNameController.dispose();
    batchDeliverablesController.dispose();
    tdDayController.dispose();
    tdMonthController.dispose();
    tdYearController.dispose();
    pdDayController.dispose();
    batchSubmissionPriceController.dispose();
    pdMonthController.dispose();
    pdYearController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      tdDayController = TextEditingController();
      tdMonthController = TextEditingController();
      tdYearController = TextEditingController();
      pdDayController = TextEditingController();
      pdMonthController = TextEditingController();
      pdYearController = TextEditingController();
      batchSubmissionPriceController = TextEditingController();
      batchNameController = TextEditingController();
      batchDeliverablesController = TextEditingController();
    });

    super.initState();
  }

  Future<void> _selectDate(
    BuildContext context,
  ) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedTargetDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedTargetDate) {
      tdDayController.clear();
      tdMonthController.clear();
      setState(() {
        date1 = picked;
        tdDayController.text = picked.day.toString();
        tdMonthController.text = picked.month.toString();
        tdYearController.text = picked.year.toString();
      });
      if (int.parse(tdDayController.text) < 10) {
        setState(() {
          tdDayController.text = "0${tdDayController.text}";
        });
      }
      if (int.parse(tdMonthController.text) < 10) {
        setState(() {
          tdMonthController.text = "0${tdMonthController.text}";
        });
      }
    }
    if (tdDayController.text.isNotEmpty) {
      setState(() {
        isValidDate = AppMethods.isDateInRange(
            inputDateStr:
                "${tdDayController.text}/${tdMonthController.text}/${tdYearController.text}",
            startDateStr: widget.argument.escrowData.startDate,
            endDateStr: widget.argument.escrowData.endDate);
      });
    }
    dayDifference = (date1.add(const Duration(days: 1)).difference(DateTime.now()).inDays);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
    return Scaffold(
      appBar: customAppBar(context,
          title: "Submission Plan", hasElevation: true, hasIcon: true),
      body: SingleChildScrollView(
        padding: appPadding(),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [TextOf("Setup your batch submission", 16.sp, 4)],
            ),
            YMargin(24.sp),
            InputField(
              fieldController: batchNameController,
              hintText: "e.g Submission A",
              fieldTitle: "Batch Name",
              onChanged: (_) {
                setState(() {});
              },
            ),
            YMargin(16.sp),
            InputField(
              fieldController: batchDeliverablesController,
              hintText: "e.g Chapter 2 & 3",
              fieldTitle: "Batch Deliverables ",
              onChanged: (_) {
                setState(() {});
              },
            ),
            YMargin(16.sp),
            Row(
              children: [TextOf("Deadline", 16.sp, 4)],
            ),
            YMargin(8.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: 0.2.sw,
                    child: InputField(
                      fieldController: tdDayController,
                      showCursor: false,
                      hintText: "dd",
                      onTap: () {
                        _selectDate(context);
                      },
                      readOnly: true,
                    )),
                XMargin(10.sp),
                SizedBox(
                    width: 0.2.sw,
                    child: InputField(
                      fieldController: tdMonthController,
                      showCursor: false,
                      readOnly: true,
                      hintText: "mm",
                      onTap: () {
                        _selectDate(context);
                      },
                    )),
                XMargin(10.sp),
                SizedBox(
                    width: 0.25.sw,
                    child: InputField(
                      fieldController: tdYearController,
                      hintText: "yyyy",
                      onTap: () {
                        _selectDate(context);
                      },
                      showCursor: false,
                      readOnly: true,
                    ))
              ],
            ),
            (isValidDate == false &&
                    tdYearController.text.isNotEmpty &&
                    tdMonthController.text.isNotEmpty &&
                    tdDayController.text.isNotEmpty)
                ? Column(
                    children: [
                      YMargin(10.sp),
                      Row(
                        children: [
                          Expanded(
                              child: TextOf(
                                  "Invalid date. Plan submission deadline must be within the escrow timeline",
                                  12.sp,
                                  4,
                                  align: TextAlign.left,
                                  color: AppColors.red))
                        ],
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            YMargin(16.sp),
            InputField(
              fieldController: batchSubmissionPriceController,
              hintText: "50,000",
              fieldTitle: "Price for Batch Submission",
              onChanged: (_) {
                setState(() {});
              },
            ),
            YMargin(24.sp),
            ((int.tryParse(batchSubmissionPriceController.text) ?? 0) +
                        widget.argument.totalPriceOfAvailableSubmissions) >
                    widget.argument.escrowData.escrowAmount
                ? RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color:
                                AppThemeNotifier.colorScheme(context).primary),
                        text: "Your ",
                        children: [
                        TextSpan(
                            text:
                                '${AppConst.COUNTRY_CURRENCY} ${AppMethods.moneyComma(widget.argument.escrowData.escrowAmount - widget.argument.totalPriceOfAvailableSubmissions)}',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppThemeNotifier.colorScheme(context)
                                    .primary),
                            children: [
                              TextSpan(
                                text: " escrow balance left for ",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppThemeNotifier.colorScheme(context)
                                        .primary),
                              ),
                              TextSpan(
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          AppThemeNotifier.colorScheme(context)
                                              .primary),
                                  text:
                                      widget.argument.escrowData.jobId!.jobName,
                                  children: [
                                    TextSpan(
                                        text:
                                            " is insufficient to pay for this batch.\n",
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppThemeNotifier.colorScheme(
                                                    context)
                                                .primary),
                                        children: [
                                          TextSpan(
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.primaryColor,
                                                  decoration:
                                                      TextDecoration.underline),
                                              text: "Fund escrow?",
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushNamed(
                                                      context, FundEscrow.fundEscrow,
                                                      arguments: FundEscrowArgument(
                                                          paymentFor: widget
                                                              .argument
                                                              .escrowData
                                                              .jobId!
                                                              .jobName,
                                                          paperTitle: widget
                                                              .argument
                                                              .escrowData
                                                              .jobId!
                                                              .jobTitle,
                                                          totalEscrowAmount: widget
                                                              .argument
                                                              .escrowData
                                                              .escrowAmount,
                                                          userProfile: UserProfile(
                                                              id: widget
                                                                  .argument
                                                                  .escrowData
                                                                  .researcherId,
                                                              avatar: "",
                                                              fullName: widget
                                                                  .argument
                                                                  .escrowData
                                                                  .researcherName),
                                                          escrowId:
                                                              widget.argument.escrowData.id));
                                                })
                                        ])
                                  ])
                            ]),
                      ]))
                : const SizedBox.shrink(),
            YMargin(24.sp),
            Row(
              children: [
                Expanded(
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppThemeNotifier.colorScheme(context)
                                  .primary),
                          text: dayDifference < 0
                              ? "Your total deadline date "
                              : "This batch deadline is in ",
                          children: [
                        TextSpan(
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            text: dayDifference < 0
                                ? "can't be before today"
                                : "\"$dayDifference day${dayDifference == 1 ? "" : "s"}\".",
                          )
                      ])),
                ),
              ],
            ),
            YMargin(48.sp),
            Button(
              text: "Create Submission Plan",
              onPressed: () {
                EscrowProvider.addSubmissionPlan(context, ref,
                    escrowId: widget.argument.escrowData.id,
                    name: batchNameController.text,
                    deliverables: batchDeliverablesController.text,
                    deadline:
                        "${tdDayController.text}/${tdMonthController.text}/${tdYearController.text}",
                    price:
                        int.tryParse(batchSubmissionPriceController.text) ?? 0);
              },
              buttonType: (isValidDate &&
                      batchNameController.text.isNotEmpty &&
                      batchDeliverablesController.text.isNotEmpty &&
                      batchSubmissionPriceController.text.isNotEmpty &&
                      ((int.tryParse(batchSubmissionPriceController.text) ?? 0) + widget.argument.totalPriceOfAvailableSubmissions) <
                      widget.argument.escrowData.escrowAmount)
                  ? ButtonType.blueBg
                  : ButtonType.disabled,
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project_bist/THEMES/app_themes.dart';
// import 'package:project_bist/WIDGETS/buttons.dart';
// import 'package:project_bist/WIDGETS/custom_appbar.dart';
// import 'package:project_bist/WIDGETS/input_field.dart';
// import 'package:project_bist/WIDGETS/spacing.dart';
// import 'package:project_bist/main.dart';
// import 'package:project_bist/THEMES/color_themes.dart';
// import 'package:project_bist/widgets/texts.dart';

// class SubscriptionPlanScreen extends StatefulWidget {
//   static const String subscriptionPlanScreen = "cubscriptionPlanScreen";
//   const SubscriptionPlanScreen({super.key});

//   @override
//   State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
// }

// class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
//   late TextEditingController batchNameController, batchDeliverablesController;

//   @override
//   void initState() {
//     setState(() {
//       tdDayController = TextEditingController();
//       tdMonthController = TextEditingController();
//       tdYearController = TextEditingController();
//       pdDayController = TextEditingController();
//       pdMonthController = TextEditingController();
//       pdYearController = TextEditingController();

//       batchNameController = TextEditingController();
//       batchDeliverablesController = TextEditingController();
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     batchNameController.dispose();
//     batchDeliverablesController.dispose();
//     tdDayController.dispose();
//     tdMonthController.dispose();
//     tdYearController.dispose();
//     pdDayController.dispose();
//     pdMonthController.dispose();
//     pdYearController.dispose();
//     super.dispose();
//   }

//   DateTime date1 = DateTime.now();
//   late TextEditingController tdDayController,
//       tdMonthController,
//       tdYearController,
//       pdDayController,
//       pdMonthController,
//       pdYearController;

//   DateTime selectedTargetDate =  DateTime.now().year + 1, DateTime.now().month, DateTime.now().day;
//   Future<void> _selectDate(
//     BuildContext context,
//   ) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: selectedTargetDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != selectedTargetDate) {
//       setState(() {
//         date1 = picked;
//         tdDayController.text = picked.day.toString();
//         tdMonthController.text = picked.month.toString();
//         tdYearController.text = picked.year.toString();
//       });
//     }
//   }

//   // DateTime selectedPreferedDate = DateTime(
//   //     DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
//   // Future<void> _selectDate2(
//   //   BuildContext context,
//   // ) async {
//   //   final DateTime? picked = await showDatePicker(
//   //       context: context,
//   //       initialDate: selectedPreferedDate,
//   //       firstDate: DateTime(2015, 8),
//   //       lastDate: DateTime(2101));
//   //   if (picked != null && picked != selectedPreferedDate) {
//   //     setState(() {
//   //       date2 = picked;
//   //       pdDayController.text = picked.day.toString();
//   //       pdMonthController.text = picked.month.toString();
//   //       pdYearController.text = picked.year.toString();
//   //     });
//   //   }
//   // }

//   int dayDifference = 0;
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       setState(() {
//         dayDifference = (date1.difference(DateTime.now()).inDays ~/ 7);
//       });
//     });
//     return Scaffold(
//       appBar: customAppBar(context,
//           title: "Submission Plan", hasElevation: true, hasIcon: true),
//       body: SingleChildScrollView(
//         padding: appPadding(),
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             Row(
//               children: [TextOf("Setup your batch submission", 16.sp, 4)],
//             ),
//             YMargin(24.sp),
//             InputField(
//               fieldController: batchNameController,
//               hintText: "e.g Submission A",
//               fieldTitle: "Batch Name",
//             ),
//             YMargin(16.sp),
//             InputField(
//               fieldController: batchDeliverablesController,
//               hintText: "e.g Chapter 2 & 3",
//               fieldTitle: "Batch Deliverables ",
//             ),
//             YMargin(16.sp),
//             Row(
//               children: [TextOf("Target Deadline", 16.sp, 4)],
//             ),
//             YMargin(8.sp),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                     width: 0.2.sw,
//                     child: InputField(
//                       fieldController: tdDayController,
//                       showCursor: false,
//                       hintText: "dd",
//                       onTap: () {
//                         _selectDate(context);
//                       },
//                       readOnly: true,
//                     )),
//                 XMargin(10.sp),
//                 SizedBox(
//                     width: 0.2.sw,
//                     child: InputField(
//                       fieldController: tdMonthController,
//                       showCursor: false,
//                       readOnly: true,
//                       hintText: "mm",
//                       onTap: () {
//                         _selectDate(context);
//                       },
//                     )),
//                 XMargin(10.sp),
//                 SizedBox(
//                     width: 0.25.sw,
//                     child: InputField(
//                       fieldController: tdYearController,
//                       hintText: "yyyy",
//                       onTap: () {
//                         _selectDate(context);
//                       },
//                       showCursor: false,
//                       readOnly: true,
//                     ))
//               ],
//             ),
//            // YMargin(16.sp),
//             // Row(
//             //   children: [TextOf("Preferred Deadline", 16.sp, 4)],
//             // ),
//             // YMargin(8.sp),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.start,
//             //   children: [
//             //     SizedBox(
//             //         width: 0.2.sw,
//             //         child: InputField(
//             //           fieldController: pdDayController,
//             //           showCursor: false,
//             //           hintText: "dd",
//             //           onTap: () {
//             //             _selectDate2(context);
//             //           },
//             //           readOnly: true,
//             //         )),
//             //     XMargin(10.sp),
//             //     SizedBox(
//             //         width: 0.2.sw,
//             //         child: InputField(
//             //           fieldController: pdMonthController,
//             //           showCursor: false,
//             //           readOnly: true,
//             //           hintText: "mm",
//             //           onTap: () {
//             //             _selectDate2(context);
//             //           },
//             //         )),
//             //     XMargin(10.sp),
//             //     SizedBox(
//             //         width: 0.25.sw,
//             //         child: InputField(
//             //           fieldController: pdYearController,
//             //           hintText: "yyyy",
//             //           onTap: () {
//             //             _selectDate2(context);
//             //           },
//             //           showCursor: false,
//             //           readOnly: true,
//             //         ))
//             //   ],
//             // ),
//             YMargin(24.sp),
//             RichText(
//                 text: TextSpan(
//                     style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w400,
//                         color: AppThemeNotifier.colorScheme(context).primary),
//                     text: "Your total target deadline is ",
//                     children: [
//                   TextSpan(
//                       style: const TextStyle(fontWeight: FontWeight.w500),
//                       text:
//                           "<${dayDifference.abs() == 52 ? 0 : dayDifference} week${dayDifference == 1 ? "s":""}/>, ",
//                       children: const [
//                         TextSpan(
//                             style: TextStyle(fontWeight: FontWeight.w400),
//                             text:
//                                 "which corresponds to the deadline set for totality of the batches of submissions.")
//                       ])
//                 ])),
//             YMargin(48.sp),
//             Button(
//               text: "Create Submission Plan",
//               onPressed: () {},
//               buttonType: ButtonType.blueBg,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }