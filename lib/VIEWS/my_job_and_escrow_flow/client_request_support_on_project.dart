import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class ClientRequestSupportOnProject extends StatelessWidget {
  static const String clientRequestSupportOnProject =
      "clientRequestSupportOnProject";
  final String jobId;
  const ClientRequestSupportOnProject({required this.jobId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: "Get support", hasElevation: true, hasIcon: true),
      body: Padding(
        padding: appPadding(),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: TextOf(
                "Select from our personalized report options or write to us if none conforms to your situation.",
                16.sp,
                4,
                align: TextAlign.left,
              ))
            ],
          ),
          YMargin(24.sp),
          ...List.generate(
              2,
              (index) => Container(
                    margin: EdgeInsets.only(bottom: 16.sp),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.brown1(context),
                        border: Border.all(
                          color: AppColors.grey2,
                        ),
                        borderRadius: BorderRadius.circular(12.r)),
                    child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: InkWell(
                        // onTap: index == 1
                        //     ? null
                        //     : () {
                        //         Navigator.pushNamed(
                        //             context,
                        //             index == 0

                        //                 /// === [file for refund currently on hold]
                        //                 ? ClientPauseJob.clientPauseJob
                        //                 : ClientFileForRefund
                        //                     .clientFileForRefund,
                        //             arguments: index == 0 ? jobId : null);
                        //       },
                        child: Row(
                          children: [
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextOf(
                                        index == 0
                                            ? "Pause your Job (Beta)"
                                            : "File for a Refund (Beta)",
                                        16.sp,
                                        6,
                                        color: AppColors.grey2),
                                    TextOf(
                                      index == 0
                                          ? "Pause your job for not more than 3 months"
                                          : "This is currently on hold for future updates",
                                      //: "The researcher hasn't delivered any chapters yet",
                                      12.sp,
                                      4,
                                      color: AppColors.grey2,
                                    )
                                  ],
                                ),
                                const IconOf(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.grey2,
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                  ))
        ]),
      ),
    );
  }
}
