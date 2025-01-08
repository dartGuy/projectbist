import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/WIDGETS/filter_bottom_sheet.dart';
import 'package:project_bist/WIDGETS/filter_jobs_sheet_body.dart';
import 'package:project_bist/WIDGETS/filter_profile_sheet_body.dart';
import 'package:project_bist/WIDGETS/filter_publications_sheet_body.dart';


appBottomSheet(BuildContext context,
    {required Widget body, EdgeInsetsGeometry? padding}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
          width: double.infinity,
          padding: padding ??
              EdgeInsets.symmetric(vertical: 30.sp, horizontal: 20.sp),
          decoration: BoxDecoration(
              color:
                  AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r))),
          child: body));
}

class AppBottomSheet {
  static filterJob(BuildContext context, {VoidCallback? onTapFilter}) {
    appBottomSheet(context,
        body: FilterJobsSheetBody(onTapFilter: onTapFilter));
  }

  static filterPublication(BuildContext context, {VoidCallback? onTapFilter}) {
    appBottomSheet(context,
        body: FilterPublicationsSheetBody(onTapFilter: onTapFilter));
  }

  static filterProfile(BuildContext context, {VoidCallback? onTapFilter}) {
    appBottomSheet(context,
        body: FilterProfilesSheetBody(onTapFilter: onTapFilter));
  }

  static filterTopic(BuildContext context,
      {VoidCallback? onTapFilter,
      UserTypes? userTypes,
      required Function(String)? onSelectedDateItemClicked,
      required Function(String)? onSelectedSectorOrFacultyItemClicked,
      required Function(String)? onSelectedDivisionItemClicked,
      required Function(String)? onSelectedPaperTypeItemClicked}) {
    appBottomSheet(context,
        body: FilterTopicSheetBody(
            onTapFilter: () {
              onTapFilter != null ? onTapFilter() : () {};
            },
            userType: userTypes,
            onSelectedDateItemClicked: onSelectedDateItemClicked,
            onSelectedSectorOrFacultyItemClicked:
                onSelectedSectorOrFacultyItemClicked,
            onSelectedDivisionItemClicked: onSelectedDivisionItemClicked,
            onSelectedPaperTypeItemClicked: onSelectedPaperTypeItemClicked));
  }
}
