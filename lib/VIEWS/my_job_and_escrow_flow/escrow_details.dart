// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_with_submission_paln_model.dart';
import 'package:project_bist/core.dart';
import 'package:project_bist/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class EscrowDetailScreen extends ConsumerStatefulWidget {
  static const String escrowDetailScreen = "escrowDetailScreen";
  EscrowDetailScreen({required this.escrowDetails, super.key});
  EscrowWithSubmissionPlanModel? escrowDetails;
  @override
  ConsumerState<EscrowDetailScreen> createState() => _EscrowDetailScreenState();
}

class _EscrowDetailScreenState extends ConsumerState<EscrowDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: "Escrow",
          hasIcon: true,
          hasElevation: true,
          actions: [
            Container(
              margin: EdgeInsets.all(10.sp),
              width: 100.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: switch (escrowStatus(widget.escrowDetails!.status)) {
                  EscrowStatus.completed => AppColors.green2,
                  EscrowStatus.ongoing => AppColors.brown,
                  EscrowStatus.paused => Colors.orange,
                },
              ),
              child: Center(
                child: TextOf(
                  switch (escrowStatus(widget.escrowDetails!.status)) {
                    EscrowStatus.completed => "Completed",
                    EscrowStatus.ongoing => "Ongoing",
                    EscrowStatus.paused => "Paused",
                  },
                  14.sp,
                  4,
                  color: AppColors.white,
                ),
              ),
            )
          ]),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: appPadding(),
        child: Column(
          children: [
            YMargin(10.sp),
            Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextOf(
                            "NGN ${AppMethods.moneyComma(widget.escrowDetails!.escrowAmount)}",
                            24.sp,
                            7,
                            align: TextAlign.left,
                          ),
                        ],
                      ),
            Row(
                        children: [
                          Expanded(
                              child: TextOf(
                            "Total Escrow Amount",
                            14.sp,
                            4,
                            align: TextAlign.left,
                            color: isDarkTheme(context)
                                ? AppColors.grey1
                                : AppColors.grey3,
                          )),
                        ],
                      ),
                      YMargin(15.sp),
Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextOf(
                            "NGN ${AppMethods.moneyComma(widget.escrowDetails!.releasedAmount)}",
                            24.sp,
                            7,
                            align: TextAlign.left,
                          ),
                        ],
                      ),
            Row(
                        children: [
                          Expanded(
                              child: TextOf(
                        ref.watch(switchUserProvider) != UserTypes.researcher?"Total Released":  "Amount Withdrawable",
                            14.sp,

                            4,
                            align: TextAlign.left,
                            color: isDarkTheme(context)
                                ? AppColors.grey1
                                : AppColors.grey3,
                          )),
                        ],
                      ),
            YMargin(30.sp),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.brown1(context),
                  borderRadius: BorderRadius.circular(12.r)),
              padding: EdgeInsets.symmetric(vertical: 12.sp),
              width: double.infinity,
              child: Column(children: [
                eachEscrowDetail(context,
                    left: "Job type",
                    right: AppMethods.toTitleCase(
                        widget.escrowDetails!.jobId!.jobType)),
                eachEscrowDetail(context,
                    left: "Payment for",
                    right: widget.escrowDetails!.jobId!.jobName),
                eachEscrowDetail(context,
                    left: "Researcher’s name",
                    right: widget.escrowDetails!.researcherName),
                eachEscrowDetail(context,
                    left: "Estimation technique",
                    right: widget.escrowDetails!.jobId!.estimationTechnique),
                eachEscrowDetail(context,
                    left: "Scope of project",
                    right: widget.escrowDetails!.jobId!.jobScope),
                eachEscrowDetail(context,
                    left: "Estimated work duration",
                    right:
                        "${widget.escrowDetails!.jobId!.duration} ${widget.escrowDetails!.jobId!.durationType}"),
                eachEscrowDetail(context,
                    left: "Work timeline",
                    right:
                        "${widget.escrowDetails!.startDate} - ${widget.escrowDetails!.endDate}",
                    bottonPadding: 10.sp),
                AppDivider(
                  color: AppColors.grey3,
                ),
                YMargin(15.sp),
                eachJobDescriptionItem(context,
                    title: "Paper title",
                    subtitle: widget.escrowDetails!.jobId!.jobTitle),
                eachJobDescriptionItem(context,
                    title: "Paper description",
                    subtitle: widget.escrowDetails!.jobId!.jobDescription),
              ]),
            ),
            YMargin(15.sp),
            actOnEscrowDetailButton(context, route: JobActivityPreview.jobActivityPreview, iconName: ImageOf.indeedJobIcon, title: "Job Activities", subtitle: "View, review submitted chapters and timeline"),
            // YMargin(15.sp),
            // actOnEscrowDetailButton(context, iconName: ImageOf.editWorkIcon, title: "Edit Work Timeline", subtitle: "Review the duration of your Job"),
            YMargin(50.sp),
            (ref.watch(switchUserProvider) != UserTypes.researcher &&
                    escrowStatus(widget.escrowDetails!.status) ==
                        EscrowStatus.completed)
                ? InkWell(
                    onTap: () {
                      Alerts.optionalDialog(context,
                          text: "Are you sure you want to delete this escrow?", onTapLeft: (){
                            Navigator.pop(context);
                            EscrowProvider.deleteEscrow(context, ref, escrowId: widget.escrowDetails!.id);
                          });
                    },
                    child:
                        TextOf("Delete Escrow", 16.sp, 5, color: AppColors.red))
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Container actOnEscrowDetailButton(BuildContext context, {String route = "", required String iconName, required String title, required String subtitle}) {
    return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.brown1(context),
                border: Border.all(color: AppColors.brown),
                borderRadius: BorderRadius.circular(12.r)),
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: InkWell(
                onTap: route.isEmpty?null: () {
                  Navigator.pushNamed(
                      context, route,
                      arguments: widget.escrowDetails!);
                },
                child: Row(
                  children: [
                    Image.asset(
                    iconName,
                      height: 40.sp,
                    ),
                    XMargin(10.sp),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextOf(title, 16.sp, 6),
                            TextOf(
                              subtitle,
                              12.sp,
                              4,
                              color: AppThemeNotifier.colorScheme(context)
                                  .onSecondary,
                            )
                          ],
                        ),
                        IconOf(
                          Icons.arrow_forward_ios_rounded,
                          color:
                              AppThemeNotifier.colorScheme(context).primary,
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
  }
}

Padding eachEscrowDetail(BuildContext context,
    {required String left, required String right, double? bottonPadding}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.sp)
        .copyWith(bottom: bottonPadding ?? 24.sp),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      TextOf(
        left,
        16.sp,
        4,
        color: AppThemeNotifier.colorScheme(context).onSecondary,
      ),
      TextOf(
        right,
        16.sp,
        6,
        color: AppThemeNotifier.colorScheme(context).primary,
      )
    ]),
  );
}


eachJobDescriptionItem(BuildContext context,
    {required String title, required String subtitle}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.sp),
    child: Column(
      children: [
        Row(
          children: [
            TextOf(title, 16.sp, 4,
                color: AppThemeNotifier.colorScheme(context).onSecondary),
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




