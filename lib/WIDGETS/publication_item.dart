// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/UTILS/profile_image.dart';

import 'package:project_bist/VIEWS/publication_detail/publication_detail_from_dashboard.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import "package:timeago/timeago.dart" as timeago;

class PublicationItem extends StatelessWidget {
  PublicationItem({
    required this.publicationModel,
    this.publicationList,
    super.key,
    this.width,
    this.argument,
    this.routeName,
  });
  double? width;
  final PublicationModel publicationModel;
  PublicationsList? publicationList;
  String? routeName;
  dynamic argument;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: width ?? 0.85.sw,
          height: 167.sp,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(ImageOf.publication))),
        ),
        Container(
          width: width ?? 0.85.sw,
          height: 167.sp,
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.black.withOpacity(0.5)),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                  context,
                  routeName ??
                      PublicationDetailFromDashboard
                          .publicationDetailFromDashboard,
                  arguments: routeName == null
                      ? PublicationDetailFromDashboardArgument(
                          publication: publicationModel,
                          publicationList: publicationList)
                      : argument);
            },
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    TextOf(publicationModel.title, 16.sp, 7,
                        textOverflow: TextOverflow.ellipsis,
                        align: TextAlign.left,
                        color: AppColors.white,
                        maxLines: 2)
                  ]),
                  YMargin(12.sp),
                  Row(children: [
                    TextOf(
                      timeago.format(publicationModel.createdAt),
                      12.sp,
                      4,
                      color: AppColors.white,
                    ),
                    TextOf("  ●  ", 4, 4, color: AppColors.white),
                    TextOf(" ${publicationModel.type}", 12.sp, 4,
                        color: AppColors.white),
                  ]),
                  YMargin(12.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.sp),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: AppColors.brown),
                          height: 29.sp,
                          child: Center(
                              child: TextOf(
                            "${AppConst.COUNTRY_CURRENCY} ${AppMethods.moneyComma(publicationModel.price.toInt().toString())}",
                            15,
                            5,
                            color: AppColors.white,
                          ))),
                      TextOf(
                        DateFormat.yMMM()
                            .format(publicationModel.createdAt)
                            .toUpperCase(),
                        14,
                        5,
                        color: AppColors.white,
                      ),
                      TextOf(
                        "●",
                        4,
                        5,
                        color: AppColors.white,
                      ),
                      ImageIcon(
                        AssetImage(ImageOf.mergeIcon),
                        color: AppColors.white,
                        size: 18.sp,
                      ),
                      TextOf(
                        "${publicationModel.uniquenessScore}% Unique",
                        14,
                        5,
                        color: AppColors.white,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      XMargin(0.05.sw)
                    ],
                  ),
                  YMargin(12.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          buildProfileImage(
                              imageUrl: publicationModel.researcherId.avatar,
                              fullNameTobSplit:
                                  publicationModel.researcherId.fullName,
                              radius: 22.5.sp,
                              fontSize: 10.sp,
                              fontWeight: 4),
                          XMargin(10.sp),
                          TextOf(
                            (publicationModel.owners?.isEmpty ?? false)
                                ? ""
                                : (publicationModel.owners?.length ?? 0) == 1
                                    ? (publicationModel.owners?[0] ?? "")
                                    : "${(publicationModel.owners?[0] ?? "")} & ${(publicationModel.owners?.length ?? 0) - 1} others",
                            13.sp,
                            6,
                            color: AppColors.white,
                          ),
                          Row(
                              children: List.generate(
                                  2,
                                  (index) => Row(
                                        children: [
                                          XMargin(12.sp),
                                          IconOf(
                                            index == 0
                                                ? Icons.thumb_up_outlined
                                                : Icons.visibility_outlined,
                                            color: AppColors.white,
                                            size: 13.sp,
                                          ),
                                          XMargin(6.sp),
                                          TextOf(
                                            index == 0
                                                ? publicationModel.likes
                                                    .toString()
                                                : publicationModel.views
                                                    .toString(),
                                            13,
                                            6,
                                            color: AppColors.white,
                                          )
                                        ],
                                      )))
                        ],
                      )
                    ],
                  ),
                ]),
          ),
        )
      ],
    );
  }
}
