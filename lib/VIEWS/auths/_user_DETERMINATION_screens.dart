// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/auths/create_account_screens_ALL_USERS.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';

enum UserTypes { student, professional, researcher }

@immutable
class BeginUserDetermination extends ConsumerStatefulWidget {
  static const String beginUserDetermination = "beginUserDetermination";

  const BeginUserDetermination({super.key});
  @override
  _BeginUserDeterminationState createState() => _BeginUserDeterminationState();
}

class _BeginUserDeterminationState
    extends ConsumerState<BeginUserDetermination> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: appPadding(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            YMargin(20.sp),
            Row(
              children: [
                TextOf("What best describe you?", 20.sp, 6),
              ],
            ),
            YMargin(18.sp),
            ...List.generate(
                2,
                (index) => InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (index == 0) {
                          Navigator.pushNamed(
                              context,
                              StudentOrProffesionalDeterminatinScreen
                                  .studentOrProffesionalDeterminatinScreen);
                        } else {
                          ref
                              .watch(switchUserProvider.notifier)
                              .switchUser(UserTypes.researcher);
                          Navigator.pushNamed(
                              context,
                              AllUsersCreateAccountScreen
                                  .allUsersCreateAccountScreen,
                              arguments: ref.watch(switchUserProvider));
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.sp),
                        child: Card(
                          elevation: 8,
                          shadowColor: AppThemeNotifier.colorScheme(context)
                              .onSecondary
                              .withOpacity(0.2),
                          surfaceTintColor: AppThemeNotifier.themeColor(context)
                              .scaffoldBackgroundColor,
                          color: AppThemeNotifier.themeColor(context)
                              .scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.sp, vertical: 15.sp),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.grey1, width: 1),
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Column(children: [
                                SvgPicture.asset(
                                    index == 0
                                        ? ImageOf.client
                                        : ImageOf.researcher,
                                    width: 144.16,
                                    height: 150.3),
                                YMargin(20.sp),
                                Row(
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextOf(
                                            index == 0
                                                ? "Client"
                                                : "Researcher",
                                            16.sp,
                                            6,
                                            color: AppThemeNotifier.colorScheme(
                                                    context)
                                                .primary,
                                            fontFamily: Fonts.nunito,
                                          ),
                                          TextOf(
                                            index == 0
                                                ? "Seeking expert solution?"
                                                : "Looking for opportunity?",
                                            16.sp,
                                            4,
                                            fontFamily: Fonts.nunito,
                                          )
                                        ]),
                                  ],
                                )
                              ])),
                        ),
                      ),
                    ))
          ]),
        ),
      ),
    ));
  }
}

class StudentOrProffesionalDeterminatinScreen extends ConsumerStatefulWidget {
  static const String studentOrProffesionalDeterminatinScreen =
      "studentOrProffesionalDeterminatinScreen";
  const StudentOrProffesionalDeterminatinScreen({super.key});

  @override
  ConsumerState<StudentOrProffesionalDeterminatinScreen> createState() =>
      _StudentOrProffesionalDeterminatinScreenState();
}

class _StudentOrProffesionalDeterminatinScreenState
    extends ConsumerState<StudentOrProffesionalDeterminatinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, hasIcon: true),
      body: SafeArea(
          child: Padding(
        padding: appPadding(),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: TextOf(
                "Are you a Student or Professional?",
                20.sp,
                5,
                align: TextAlign.start,
              )),
            ],
          ),
          YMargin(24.sp),
          ...List.generate(
              2,
              (index) => Container(
                    margin: EdgeInsets.only(bottom: 16.sp),
                    child: Card(
                      elevation: 8,
                      shadowColor: AppThemeNotifier.colorScheme(context)
                          .onSecondary
                          .withOpacity(0.2),
                      surfaceTintColor: AppThemeNotifier.themeColor(context)
                          .scaffoldBackgroundColor,
                      color: AppThemeNotifier.themeColor(context)
                          .scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.sp, vertical: 15.sp),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.grey1, width: 1),
                            borderRadius: BorderRadius.circular(10.r)),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            if (index == 0) {
                              ref
                                  .watch(switchUserProvider.notifier)
                                  .switchUser(UserTypes.student);
                              Navigator.pushNamed(
                                  context,
                                  AllUsersCreateAccountScreen
                                      .allUsersCreateAccountScreen,
                                  arguments: ref.watch(switchUserProvider));
                            } else {
                              ref
                                  .watch(switchUserProvider.notifier)
                                  .switchUser(UserTypes.professional);
                              Navigator.pushNamed(
                                  context,
                                  AllUsersCreateAccountScreen
                                      .allUsersCreateAccountScreen,
                                  arguments: ref.watch(switchUserProvider));
                            }
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextOf(
                                  index == 0
                                      ? "Student"
                                      : "I am a professional",
                                  16.sp,
                                  6,
                                  color: AppThemeNotifier.colorScheme(context)
                                      .primary,
                                  fontFamily: Fonts.nunito,
                                ),
                                YMargin(5.sp),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextOf(
                                        index == 0
                                            ? "A tertiary institution undergraduate/postgraduate."
                                            : "NGO, corporate organisations, government parastatals, research institutes, private individuals, business firms, Non-students etc.",
                                        16.sp,
                                        4,
                                        align: TextAlign.left,
                                        fontFamily: Fonts.nunito,
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                  )),
        ]),
      )),
    );
  }
}
