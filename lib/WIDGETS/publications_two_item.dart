import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/publication_detail/publication_detail_from_dashboard.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import "package:timeago/timeago.dart" as timeago;

// ignore: must_be_immutable
class PublicationsTwoItem extends StatelessWidget {
  PublicationsTwoItem(
      {this.publication,
      this.publicationList,
      this.hasDivider = false,
      super.key});
  bool? hasDivider;
  PublicationModel? publication;
  PublicationsList? publicationList;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 1.sp),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context,
                  PublicationDetailFromDashboard.publicationDetailFromDashboard,
                  arguments: PublicationDetailFromDashboardArgument(
                      publication: publication!,
                      publicationList: publicationList!));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextOf(
                              publication!.title,
                              16.sp,
                              7,
                              textOverflow: TextOverflow.ellipsis,
                              align: TextAlign.left,
                              color:
                                  AppThemeNotifier.colorScheme(context).primary,
                            ),
                          ),
                        ],
                      ),
                      YMargin(10.sp),
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.sp),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.r),
                                  color: AppColors.brown),
                              height: 29.sp,
                              // width: 96.sp,
                              child: Center(
                                  child: TextOf(
                                "${AppConst.COUNTRY_CURRENCY} ${publication!.price.toInt().toString()}",
                                15,
                                5,
                                color: AppColors.white,
                              ))),
                          XMargin(10.sp),
                          ImageIcon(
                            AssetImage(ImageOf.mergeIcon),
                            color:
                                AppThemeNotifier.colorScheme(context).primary,
                            size: 18.sp,
                          ),
                          TextOf(
                            " ${(publication!.uniquenessScore * 100).toInt()}% Unique",
                            14,
                            5,
                            color:
                                AppThemeNotifier.colorScheme(context).primary,
                          ),
                        ],
                      ),
                      YMargin(12.sp),
                      Row(
                        children: [
                          TextOf(
                              timeago
                                      .format(publication!.createdAt)[0]
                                      .toUpperCase() +
                                  timeago
                                      .format(publication!.createdAt)
                                      .substring(
                                          1,
                                          timeago
                                              .format(publication!.createdAt)
                                              .length),
                              12,
                              4),
                          XMargin(7.sp),
                          TextOf(
                            "●",
                            5,
                            5,
                            color:
                                AppThemeNotifier.colorScheme(context).primary,
                          ),
                          XMargin(7.sp),
                          IconOf(
                            Icons.visibility,
                            size: 15,
                            color:
                                AppThemeNotifier.colorScheme(context).primary,
                          ),
                          XMargin(3.sp),
                          TextOf(publication!.views.toString(), 12, 4),
                          XMargin(7.sp),
                          TextOf(
                            "●",
                            5,
                            5,
                            color:
                                AppThemeNotifier.colorScheme(context).primary,
                          ),
                          XMargin(7.sp),
                          IconOf(
                            Icons.thumb_up_outlined,
                            size: 12,
                            color:
                                AppThemeNotifier.colorScheme(context).primary,
                          ),
                          XMargin(3.sp),
                          TextOf(publication!.likes.toString(), 12, 4),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          YMargin(15.sp),
                          Container(
                            width: 113.sp,
                            height: 55.sp,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(ImageOf.publication))),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        hasDivider == true ? AppDivider() : const SizedBox.shrink()
      ],
    );
  }
}
