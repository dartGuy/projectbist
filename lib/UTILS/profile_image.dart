import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import "package:project_bist/THEMES/app_themes.dart";

CachedNetworkImage buildProfileImage(
    {required String imageUrl,
    required String fullNameTobSplit,
    double? radius,
    double? fontSize,
    int? fontWeight}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, imageProvider) => SizedBox.square(
      dimension: radius ?? 70.sp,
      child: CircleAvatar(backgroundImage: imageProvider),
    ),
    placeholder: (context, url) => SizedBox.square(
      dimension: radius ?? 70.sp,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    ),
    errorWidget: (context, url, error) => SizedBox.square(
      dimension: radius ?? 70.sp,
      child: CircleAvatar(
        radius: radius == null ? 35.sp : radius / 2,
        backgroundColor:
            AppThemeNotifier.colorScheme(context).primary == AppColors.black
                ? AppColors.primaryColorLight
                : AppColors.red1.withOpacity(0.7),
        child: TextOf(
          fullNameTobSplit.split(" ").length == 1
              ? fullNameTobSplit.split(" ")[0][0].toUpperCase()
              : ("${fullNameTobSplit.split(" ")[0][0]}${fullNameTobSplit.split(" ")[0][0]}"),
          fontSize ?? 27.sp,
          fontWeight ?? 7,
          fontFamily: Fonts.montserrat,
          color: AppColors.white,
        ),
      ),
    ),
  );
}
