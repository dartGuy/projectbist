import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/escrow_model/escrow_with_submission_paln_model.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/escrow_item_card.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

class ClientSelectEscrowToFund extends StatefulWidget {
  static const String clientSelectEscrowToFund = "clientSelectEscrowToFund";
  const ClientSelectEscrowToFund({super.key});

  @override
  State<ClientSelectEscrowToFund> createState() =>
      _ClientSelectEscrowToFundState();
}

class _ClientSelectEscrowToFundState extends State<ClientSelectEscrowToFund> {

  EscrowWithSubmissionPlanList escrows = (getIt<AppModel>()
              .escrowWithSubmissionPlanList ??
          [])
      .where((e) => e.status.contains("ongoing") || e.status.contains("paused"))
      .toList();
  @override
  Widget build(BuildContext context) {
    // ref.watch(profileProvider.notifier).getRequest(
    //     context: context, url: Endpoints.GET_PROFILE, showLoading: false);
    // getIt<AppModel>().userProfile =
    //     UserProfile.fromJson(responseStatusOfProfile.data);
    return Scaffold(
        appBar: customAppBar(context,
            title: "Fund Escrow", hasIcon: true, hasElevation: true),
        body: switch (escrows.isNotEmpty) {
          true => SingleChildScrollView(
              padding: appPadding().copyWith(top: 10),
              physics: const BouncingScrollPhysics(),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: TextOf(
                      "Select escrow to fund from available list of escrows",
                      16.sp,
                      4,
                      align: TextAlign.left,
                    ))
                  ],
                ),
                YMargin(15.sp),
                ...List.generate(
                  escrows.length,
                  (index) {
                    EscrowWithSubmissionPlanModel escrowModel =
                        escrows.reversed.toList()[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.sp),
                      child: EscrowItemCard(toFundEscrowScreen: true, escrowDetails: escrowModel),
                    );
                  },
                )
              ]),
            ),
          false =>
            ErrorPage(message: "You currently do not have any running escrow", showButton: false )
        });
  }
}
