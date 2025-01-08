// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/job_model/reseracher_job_model.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/UTILS/profile_image.dart';
import 'package:project_bist/VIEWS/job_description_pages/job_description_page.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/WIDGETS/small_button.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class JobItem extends StatelessWidget {
  JobItem({
    required this.researcherJobModel,
    super.key,
    this.width,
  });
  double? width;
  final ResearcherJobModel researcherJobModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, JobDescriptionPage.jobDescriptionPage,
              arguments: JobDescriptionPageArgument(
                  researcherJobModel: researcherJobModel));
        },
        child: Card(
          elevation: 1,
          shadowColor: AppColors.grey1.withOpacity(0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          child: Container(
              height: 187.sp,
              width: width ?? 0.85.sw,
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                  color: AppColors.brown1(context),
                  borderRadius: BorderRadius.circular(10.r)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            buildProfileImage(
                                radius: 50.sp,
                                fontWeight: 5,
                                fontSize: 15.sp,
                                imageUrl: researcherJobModel.clientId.avatar,
                                fullNameTobSplit:
                                    researcherJobModel.clientId.fullName),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 10,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextOf(
                                      researcherJobModel.clientId.fullName,
                                      12.sp,
                                      7,
                                      align: TextAlign.left,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 0.275.sw,
                                          child: TextOf(
                                            researcherJobModel
                                                        .clientId.clientType ==
                                                    "professional"
                                                ? "${researcherJobModel.clientId.division}  "
                                                : "${researcherJobModel.clientId.department}  ",
                                            10.sp,
                                            4,
                                            align: TextAlign.left,
                                            textOverflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        TextOf(" ● ", 4, 4),
                                        Expanded(
                                          child: SizedBox(
                                            width: 0.4.sw,
                                            child: TextOf(
                                              researcherJobModel.clientId
                                                          .clientType ==
                                                      "professional"
                                                  ? "  ${researcherJobModel.clientId.sector}"
                                                  : "  ${researcherJobModel.clientId.institutionName}",
                                              10.sp,
                                              4,
                                              align: TextAlign.left,
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextOf("●", 4, 4),
                                    // TextOf(" ${researcherJobModel.createdAt}",
                                    //     10.sp, 4),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                  YMargin(7.5.sp),
                  Row(
                    children: [
                      Expanded(
                          child: researcherJobModel.jobTitle == '--'
                              ? const Text('"Client in need of a topic"')
                              : TextOf(researcherJobModel.jobTitle, 16.sp, 7,
                                  textOverflow: TextOverflow.ellipsis,
                                  align: TextAlign.left,
                                  maxLines: 2))
                    ],
                  ),
                  YMargin(9.sp),
                  Row(children: [
                    ImageIcon(AssetImage(ImageOf.copyIcon),
                        color: isDarkTheme(context)
                            ? AppColors.grey1
                            : AppColors.grey3,
                        size: 16.sp),
                    TextOf(" ${researcherJobModel.jobScope}", 12.sp, 4),
                    TextOf("  ●  ", 4, 4),
                    TextOf(" ${researcherJobModel.createdAt}", 12.sp, 4),
                  ]),
                  YMargin(6.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        TextOf("Budget:  ", 12.sp, 4),
                        TextOf(
                            "${AppConst.COUNTRY_CURRENCY} ${researcherJobModel.fixedBudget == 0 ? '${researcherJobModel.maxBudget} - ${researcherJobModel.minBudget}' : researcherJobModel.fixedBudget}",
                            12.sp,
                            6,
                            color:
                                AppThemeNotifier.colorScheme(context).primary),
                      ]),
                      const SmallButton(
                        text: "Apply for Job",
                      )
                    ],
                  )
                ],
              )),
        ));
  }
}
