import 'package:flutter/material.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/WIDGETS/components/app_bottom_sheet.dart';
import 'package:project_bist/WIDGETS/components/publications_list_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';

class AppComponents {
  // static Widget topicsListSections(
  //     BuildContext context, TopicsList topicsList) {
  //   return topicsListSection(context, topicsList);
  // }

  static Widget publicationsListSections(BuildContext context,
      {required PublicationsList publicationList, String? message}) {
    return publicationsListSection(context,
        publicationList: publicationList, message: message);
  }

  static confirmDeleteInListPopup(
      BuildContext context, int index, WidgetRef ref,
      {required String popupTitle,
      String? deletionDescriptionText,
      Widget? deletionDescriptionWidget,
      Widget? bottomContent,
      Color? backgroundColor,
      Color? textColor,
      void Function()? onPrimaryDeletePressed,
      required String deletionButtonText}) {
    appBottomSheet(context,
        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp)
            .add(EdgeInsets.only(bottom: 10.sp)),
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          YMargin(15.sp),
          TextOf(popupTitle, 20.sp, 8),
          YMargin(25.sp),
          SvgPicture.asset(
            ImageOf.deleteNotification,
            height: 150.sp,
          ),
          YMargin(25.sp),
          deletionDescriptionText != null
              ? TextOf(deletionDescriptionText, 16.sp, 4, align: TextAlign.left)
              : deletionDescriptionWidget!,
          YMargin(40.sp),
          Button2(
              text: deletionButtonText,
              backgroundColor: backgroundColor ??
                  AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
              textColor: textColor ?? AppColors.red,
              onPressed: onPrimaryDeletePressed),
          YMargin(10.sp),
          if (bottomContent != null) bottomContent,
        ]));
  }
}
