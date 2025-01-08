// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/UTILS/profile_image.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/widgets/texts.dart';
import 'package:project_bist/VIEWS/add_new_project_flow/add_new_project_flow.dart';
import '../../MODELS/escrow_model/jobs_applied_by_researcher.dart';

class FundEscrowArgument {
  final String paymentFor, paperTitle, escrowId;
  final int totalEscrowAmount;
  final UserProfile userProfile;

  FundEscrowArgument({required this.paymentFor, required this.paperTitle, required this.userProfile, required this.escrowId, required this.totalEscrowAmount});
}

class FundEscrow extends ConsumerStatefulWidget {
  static const String fundEscrow = "fundEscrow";
  final FundEscrowArgument fundEscrowArgument;

  const FundEscrow({super.key, required this.fundEscrowArgument});

  @override
  _FundEscrowState createState() => _FundEscrowState();
}

class _FundEscrowState extends ConsumerState<FundEscrow> {
  late TextEditingController amountToFundEscrowController;
  String selectedJobId = "";

  @override
  void initState() {
    setState(() {
      isDone = false;
      amountToFundEscrowController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    amountToFundEscrowController.dispose();
    super.dispose();
  }

  List<JobsAppliedByResearcher>? appliedJobsByResearcher;
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });

    return Scaffold(
      appBar: customAppBar(context, title: "Fund Escrow", hasIcon: true, hasElevation: true),
      body: Padding(
        padding: appPadding().add(const EdgeInsets.symmetric(horizontal: -5).copyWith(bottom: 15.sp)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox.expand(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Column(children: [TextOf("Total escrow amount", 16.sp, 4), TextOf("NGN ${AppMethods.moneyComma(widget.fundEscrowArgument.totalEscrowAmount)}", 20.sp, 7)])
                    ]),
                    YMargin(20.sp),
                    Row(children: [
                      TextOf(
                        "Researcher",
                        16.sp,
                        4,
                        align: TextAlign.left,
                      )
                    ]),
                    YMargin(10.sp),
                    Row(
                      children: [buildProfileImage(radius: 36.sp, imageUrl: widget.fundEscrowArgument.userProfile.avatar!, fontSize: 15.sp, fontWeight: 6, fullNameTobSplit: widget.fundEscrowArgument.userProfile.fullName!), XMargin(15.sp), TextOf(widget.fundEscrowArgument.userProfile.fullName!, 16.sp, 7)],
                    ),
                    YMargin(24.sp),
                    ...List.generate(
                        2,
                        (index) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        TextOf(index == 0 ? "Payment for" : "Paper title", 16.sp, 4),
                                      ],
                                    ),
                                    YMargin(8.sp),
                                    TextOf(index == 0 ? widget.fundEscrowArgument.paymentFor : widget.fundEscrowArgument.paperTitle, 16.sp, 6)
                                  ],
                                ),
                                YMargin(16.sp),
                              ],
                            )),
                    const YMargin(20),
                    InputField(
                      fieldController: amountToFundEscrowController,
                      hintText: "Enter an amount",
                      inputType: TextInputType.number,
                      fieldTitle: "Enter the amount to fund your escrow",
                    )
                  ],
                ),
              ),
            ),
            Button(
              text: "Continue",
              onPressed: () {
                EscrowProvider.fundEscrow(context, ref, escrowId: widget.fundEscrowArgument.escrowId, amount: int.parse(amountToFundEscrowController.text));
              },
              buttonType: (amountToFundEscrowController.text.isNotEmpty) ? ButtonType.blueBg : null,
            )
          ],
        ),
      ),
    );
  }

  void openDialog(BuildContext context, {required List<JobsAppliedByResearcher> applications}) {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: Container(
                margin: EdgeInsets.all(15.sp),
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
                decoration: BoxDecoration(color: AppThemeNotifier.themeColor(context).scaffoldBackgroundColor),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  ...applications.map((e) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    amountToFundEscrowController.text = e.jobName;
                                    selectedJobId = e.id;
                                  });
                                  Navigator.pop(context);
                                },
                                child: TextOf(
                                  e.jobName,
                                  16,
                                  5,
                                ),
                              ),
                            ],
                          ),
                          const YMargin(2.5),
                          AppDivider(),
                          const YMargin(2.5),
                        ],
                      )),
                  Button(
                    buttonType: ButtonType.whiteBg,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, AddNewProjectFlow.addNewProjectFlow, arguments: AddNewProjectFlowArgument(userProfile: widget.fundEscrowArgument.userProfile, isForJob: false, index: 0, transactionCompletedFlow: false));
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const IconOf(
                        Icons.add,
                        color: AppColors.primaryColor,
                      ),
                      XMargin(10.sp),
                      TextOf(
                        "Add New Project",
                        16.sp,
                        5,
                        color: AppColors.primaryColor,
                      )
                    ]),
                  )
                ]),
              ),
            ));
  }
}
