import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';

class ReviewItem extends StatelessWidget {
  ReviewItem(
      {this.hasDivider = false,
      this.ratingDate,
      this.unratedIcon,
      this.starNumer,
      super.key});
  bool? hasDivider;
  int? starNumer;
  String? unratedIcon, ratingDate;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      YMargin(2.sp),
      Row(
        children: [
          CircleAvatar(
            radius: 10.sp,
            backgroundImage: AssetImage(ImageOf.profilePic1),
          ),
          XMargin(3.sp),
          TextOf("Lagbaja Awe", 12, 6),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextOf(
                ratingDate ?? '',
                12,
                4,
                color: AppThemeNotifier.colorScheme(context).onSecondary,
              )
            ],
          ))
        ],
      ),
      YMargin(5.sp),
      Row(
        children: [
          ...List.generate(
            starNumer ?? 5,
            (index) => Padding(
              padding: EdgeInsets.only(right: 5.sp),
              child: Image.asset(
                ImageOf.ratedIcon,
                height: 17.sp,
              ),
            ),
          ),
          ...List.generate(
              5 - (starNumer ?? 5),
              (index) => Padding(
                    padding: EdgeInsets.only(right: 5.sp),
                    child: Image.asset(
                      unratedIcon ?? ImageOf.stariconoutlined,
                      height: 15.sp,
                    ),
                  ))
        ],
      ),
      YMargin(8.sp),
      Row(
        children: [
          Expanded(
              child: TextOf(
                  "Berkies is one of a kind. i would really give my next project",
                  16,
                  4,
                  align: TextAlign.left))
        ],
      ),
      YMargin(3.sp),
      hasDivider == true ? const Divider() : const SizedBox.shrink()
    ]);
  }
}
