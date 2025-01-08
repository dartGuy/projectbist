import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:hive_flutter/hive_flutter.dart';
import "package:flutter/material.dart";
import "package:project_bist/CORE/app_models.dart";
import "package:project_bist/THEMES/app_themes.dart";
import "package:project_bist/THEMES/color_themes.dart";
import "package:project_bist/UTILS/constants.dart";
import "package:project_bist/WIDGETS/app_divider.dart";
import "package:project_bist/WIDGETS/custom_appbar.dart";
import "package:project_bist/WIDGETS/drawer_contents.dart";
import "package:project_bist/WIDGETS/iconss.dart";
import "package:project_bist/WIDGETS/spacing.dart";
import "package:project_bist/WIDGETS/texts.dart";
import "package:project_bist/main.dart";

class ChangeThemeScreen extends StatefulWidget {
  static const String changeThemeScreen = "changeThemeScreen";
  const ChangeThemeScreen({super.key});

  @override
  State<ChangeThemeScreen> createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends State<ChangeThemeScreen> {
// var box = Hive.box(AppConst.THEME_MODE_KEY)
  List<Radio> radioButtons(String theme, Box<dynamic> box) => [
        Radio(
            value: AppConst.LIGHT_THEME_KEY,
            groupValue: theme,
            onChanged: (value) {
              box.put(AppConst.THEME_MODE_KEY, value);
            }),
        Radio(
            value: AppConst.DARK_THEME_KEY,
            groupValue: theme,
            onChanged: (value) {
              box.put(AppConst.THEME_MODE_KEY, value);
            }),
        Radio(
            value: AppConst.SYSTEM_THEME_KEY,
            groupValue: theme,
            onChanged: (value) {
              box.put(AppConst.THEME_MODE_KEY, value);
            }),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerContents(),
        appBar: customAppBar(context,
            title: "Change Theme",
            hasElevation: true,
            scale: 1.25.sp, leading: Builder(builder: (context) {
          return InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const IconOf(Icons.menu, color: AppColors.primaryColor),
          );
        }), hasIcon: true),
        body: Builder(builder: (context) {
          return PopScope(
            canPop: false,
            onPopInvoked: (value) {
              Scaffold.of(context).openDrawer();
            },
            child: ValueListenableBuilder<Box>(
                valueListenable: getIt<AppModel>().appCacheBox!.listenable(),
                builder: (context, box, widget) {
                  String theme = box.get(AppConst.THEME_MODE_KEY,
                      defaultValue: AppConst.SYSTEM_THEME_KEY);
                  return Column(children: [
                    ...List.generate(
                        2,
                        (index) => Padding(
                              padding: EdgeInsets.symmetric(
                                      horizontal: 10.sp, vertical: 5.sp)
                                  .copyWith(bottom: 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: index == 0
                                        ? radioButtons(theme, box)[0]
                                        : radioButtons(theme, box)[1],
                                  ),
                                  Expanded(
                                    flex: 11,
                                    child: InkWell(
                                      enableFeedback: false,
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        index == 0
                                            ? box.put(
                                                AppConst.THEME_MODE_KEY,
                                                radioButtons(theme, box)[0]
                                                    .value)
                                            : box.put(
                                                AppConst.THEME_MODE_KEY,
                                                radioButtons(theme, box)[1]
                                                    .value);
                                      },
                                      child: Row(
                                        children: [
                                          TextOf(
                                              "${index == 0 ? "Light" : "Dark"} Mode",
                                              15.sp,
                                              4),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                    AppDivider(
                      color: AppThemeNotifier.colorScheme(context).onSecondary,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp)
                          .copyWith(bottom: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: radioButtons(theme, box)[2],
                          ),
                          Expanded(
                              flex: 11,
                              child: InkWell(
                                enableFeedback: false,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () async {
                                  await box.put(AppConst.THEME_MODE_KEY,
                                      radioButtons(theme, box)[2].value);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextOf("System Default", 15.sp, 4),
                                    YMargin(10.sp),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextOf(
                                            "Switch to \"System Default\" for a seamless look that matches your device settings.",
                                            12.5.sp,
                                            4,
                                            color: AppThemeNotifier.colorScheme(
                                                    context)
                                                .onSecondary,
                                            align: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    )
                  ]);
                }),
          );
        }));
  }
}
