// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/profile_image.dart';
import 'package:project_bist/VIEWS/client_generate_payment/select_wallet_to_pay.dart';
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
import "package:project_bist/SERVICES/endpoints.dart";

import '../../MODELS/escrow_model/jobs_applied_by_researcher.dart';
import '../../WIDGETS/loading_indicator.dart';
import "package:project_bist/WIDGETS/error_page.dart";

class ClientGeneratePayment extends ConsumerStatefulWidget {
  static const String clientGeneratePayment = "clientGeneratePayment";
  final UserProfile userProfile;
  const ClientGeneratePayment({super.key, required this.userProfile});
  @override
  _ClientGeneratePaymentState createState() => _ClientGeneratePaymentState();
}

class _ClientGeneratePaymentState extends ConsumerState<ClientGeneratePayment> {
  late TextEditingController _paymentToMakeController, _projectFeeController;
  String selectedJobId = "";
  @override
  void initState() {
    setState(() {
      isDone = false;
      _paymentToMakeController = TextEditingController();
      _projectFeeController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    _paymentToMakeController.dispose();
    _projectFeeController.dispose();
    super.dispose();
  }

  List<JobsAppliedByResearcher>? appliedJobsByResearcher;
  bool isDone = false;
  @override
  Widget build(BuildContext context) {
    ResponseStatus jobsAppliedByResearcherProviderResponseStatus =
        ref.watch(escrowsJobsAppliedByResearcherProvider);
    if (isDone == false &&
        jobsAppliedByResearcherProviderResponseStatus.responseState !=
            ResponseState.DATA) {
      setState(() {
        isDone = true;
      });
      ref.watch(escrowsJobsAppliedByResearcherProvider.notifier).getRequest(
          context: context,
          showLoading: false,
          url: Endpoints.JOBS_APPLIED_BY_RESEARCHER(widget.userProfile.id!));
    }

    List<dynamic>? jobsApplied =
        jobsAppliedByResearcherProviderResponseStatus.data;

    appliedJobsByResearcher = jobsApplied
        ?.map((e) => JobsAppliedByResearcher.fromJson(json: e))
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });

    return Scaffold(
      appBar: customAppBar(context,
          title: "Generate Payment", hasIcon: true, hasElevation: true),
      body: jobsAppliedByResearcherProviderResponseStatus.responseState ==
              ResponseState.LOADING
          ? LoadingIndicator(
              message: 'Please wait...',
            )
          : jobsAppliedByResearcherProviderResponseStatus.responseState ==
                  ResponseState.ERROR
              ? ErrorPage(
                  message:
                      jobsAppliedByResearcherProviderResponseStatus.message!,
                  onPressed: () {
                    ref
                        .watch(escrowsJobsAppliedByResearcherProvider.notifier)
                        .getRequest(
                            context: context,
                            showLoading: false,
                            url: Endpoints.JOBS_APPLIED_BY_RESEARCHER(
                                widget.userProfile.id!),
                            inErrorCase: true);
                  })
              : Padding(
                  padding: appPadding().add(
                      const EdgeInsets.symmetric(horizontal: -5)
                          .copyWith(bottom: 15.sp)),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox.expand(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              Row(children: [
                                TextOf(
                                  "My researcher",
                                  16.sp,
                                  4,
                                  align: TextAlign.left,
                                )
                              ]),
                              YMargin(10.sp),
                              Row(
                                children: [
                                  buildProfileImage(
                                      radius: 36.sp,
                                      imageUrl: widget.userProfile.avatar!,
                                      fontSize: 15.sp,
                                      fontWeight: 6,
                                      fullNameTobSplit:
                                          widget.userProfile.fullName!),
                                  XMargin(15.sp),
                                  TextOf(widget.userProfile.fullName!, 16.sp, 7)
                                ],
                              ),
                              YMargin(24.sp),
                              Row(
                                children: [
                                  Expanded(
                                      child: TextOf(
                                    "Kindly fill this information to generate payment",
                                    16.sp,
                                    4,
                                    align: TextAlign.left,
                                  ))
                                ],
                              ),
                              YMargin(16.sp),
                              InputField(
                                  hintText: "Select a response",
                                  onChanged: (e) => e,
                                  fieldTitle: "Payment for",
                                  showCursor: false,
                                  inputType: TextInputType.none,
                                  readOnly: true,
                                  suffixIcon:
                                      const IconOf(Icons.expand_more_outlined),
                                  onTap: () {
                                    openDialog(context,
                                        applications:
                                            appliedJobsByResearcher ?? []);
                                  },
                                  fieldController: _paymentToMakeController),
                              YMargin(16.sp),
                              InputField(
                                  fieldTitle: "Project fee",
                                  inputType: TextInputType.number,
                                  onChanged: (e) {
                                    _projectFeeController.text =
                                        _projectFeeController.text
                                            .replaceAll("-", "");
                                  },
                                  prefixIcon: TextOf(
                                      AppConst.COUNTRY_CURRENCY,
                                      16,
                                      _projectFeeController.text.isEmpty
                                          ? 4
                                          : 5),
                                  fieldController: _projectFeeController),
                              YMargin(16.sp),
                              Row(children: [
                                Expanded(
                                    child: TextOf(
                                  "The project fee is the total amount you agreed with the researcher for your project",
                                  17.sp,
                                  4,
                                  align: TextAlign.left,
                                ))
                              ])
                            ],
                          ),
                        ),
                      ),
                      Button(
                        text: "Continue",
                        onPressed: () {
                          Navigator.pushNamed(context,
                              SelectWalletToPayScreen.selectWalletToPayScreen,
                              arguments: SelectWalletToPayScreenArgument(
                                  paymentDetail: PaymentDetail(
                                    paymentForText:
                                        _paymentToMakeController.text,
                                    paymentObjectId: selectedJobId,
                                    amountToPay: int.tryParse(
                                        _projectFeeController.text)!,
                                    receiverOfPaymentId: widget.userProfile.id!,
                                    paymentFor: PaymentFor.job,
                                  ),
                                  userProfile: widget.userProfile));
                        },
                        buttonType: (_paymentToMakeController.text.isNotEmpty &&
                                _projectFeeController.text.isNotEmpty)
                            ? ButtonType.blueBg
                            : null,
                      )
                    ],
                  ),
                ),
    );
  }

  void openDialog(BuildContext context,
      {required List<JobsAppliedByResearcher> applications}) {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: Container(
                margin: EdgeInsets.all(15.sp),
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
                decoration: BoxDecoration(
                    color: AppThemeNotifier.themeColor(context)
                        .scaffoldBackgroundColor),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  ...applications.map((e) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _paymentToMakeController.text = e.jobName;
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
                  YMargin(15.sp),
                  Button(
                    buttonType: ButtonType.whiteBg,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                          context, AddNewProjectFlow.addNewProjectFlow,
                          arguments: AddNewProjectFlowArgument(
                              userProfile: widget.userProfile,
                              isForJob: false,
                              index: 0,
                              transactionCompletedFlow: false));
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
