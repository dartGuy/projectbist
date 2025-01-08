// ignore_for_file: must_be_immutable

import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_with_submission_paln_model.dart';
import 'package:project_bist/core.dart';

class EscrowItemCard extends ConsumerStatefulWidget {
  EscrowItemCard({
    this.toFundEscrowScreen = false,
    super.key,
    required this.escrowDetails,
    this.width,
  });
  double? width;
  bool? toFundEscrowScreen;
  final EscrowWithSubmissionPlanModel escrowDetails;

  @override
  ConsumerState<EscrowItemCard> createState() => _EscrowItemCardState();
}

class _EscrowItemCardState extends ConsumerState<EscrowItemCard> {
  late ElTooltipController elTooltipController;

  @override
  void initState() {
    elTooltipController = ElTooltipController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
            context,
            switch (widget.toFundEscrowScreen) {
              true => FundEscrow.fundEscrow,
              _ => EscrowDetailScreen.escrowDetailScreen
            },
            arguments: switch (widget.toFundEscrowScreen) {
              true => FundEscrowArgument(
                  paymentFor: widget.escrowDetails.jobId!.jobName,
                  paperTitle: widget.escrowDetails.jobId!.jobTitle,
                  totalEscrowAmount: widget.escrowDetails.escrowAmount,
                  userProfile: UserProfile(
                      id: widget.escrowDetails.researcherId,
                      avatar: "",
                      fullName: widget.escrowDetails.researcherName),
                  escrowId: widget.escrowDetails.id),
              _ => widget.escrowDetails
            });
      },
      child: Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10.r)),
          width: double.infinity,
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextOf(widget.escrowDetails.jobId!.jobName, 16.sp, 6,
                  color: AppColors.white),
              widget.toFundEscrowScreen == true
                  ? const SizedBox.shrink()
                  : ElTooltip(
                      controller: elTooltipController,
                      color: AppThemeNotifier.themeColor(context)
                          .scaffoldBackgroundColor,
                      position: ElTooltipPosition.bottomCenter,
                      showArrow: true,
                      content: InkWell(
                        child: TextOf("Delete job", 10.sp, 4),
                        onTap: () {
                          elTooltipController.hide();
                          EscrowProvider.deleteEscrow(context, ref,
                              escrowId: widget.escrowDetails.id);
                        },
                      ),
                      child: const IconOf(
                        Icons.more_vert_outlined,
                        color: AppColors.white,
                      ),
                    ),
            ]),
            YMargin(16.sp),
            Row(
              children: [
                TextOf(AppMethods.toTitleCase(widget.escrowDetails.status),
                    12.sp, 8,
                    color: escrowStatus(widget.escrowDetails.status) ==
                            EscrowStatus.completed
                        ? AppColors.green1
                        : escrowStatus(widget.escrowDetails.status) ==
                                EscrowStatus.ongoing
                            ? AppColors.brown
                            : escrowStatus(widget.escrowDetails.status) ==
                                    EscrowStatus.paused
                                ? AppColors.yellow3
                                : AppColors.white),
              ],
            )
          ])),
    );
  }
}
