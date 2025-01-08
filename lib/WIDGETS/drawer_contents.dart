// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_bist/PROVIDERS/auth_provider/auth_provider.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/VIEWS/account_flow/account_home.dart';
import 'package:project_bist/VIEWS/all_nav_screens/_all_nav_screens/all_nav_screens.dart.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/VIEWS/change_theme/change_theme.dart';
import 'package:project_bist/VIEWS/make_report_screen/make_report_screen.dart';
import 'package:project_bist/VIEWS/my_job_and_escrow_flow/my_job_and_escrow_flow.dart';
import 'package:project_bist/VIEWS/my_publications/my_publications.dart';
import 'package:project_bist/VIEWS/originality_test_flow/__originality_test_flow.dart';
import 'package:project_bist/VIEWS/research_notes_flow/research_notes_flow.dart';
import 'package:project_bist/VIEWS/researcher_suggest_topic_page/researcher_suggest_topic_page.dart';
import 'package:project_bist/VIEWS/wallet_processes/create_wallet.dart';
import 'package:project_bist/VIEWS/wallet_processes/wallet_home.dart';
import 'package:project_bist/VIEWS/wallet_processes/wallet_onboarding.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/widgets/texts.dart';
import 'package:project_bist/VIEWS/topics_list_preview_screen/topics_list_preview_screen.dart';


String drawerIcon(String name) {
  return "assets/icons/drawer/$name.png";
}

class DrawerContents extends ConsumerStatefulWidget {
  const DrawerContents({super.key});

  @override
  ConsumerState<DrawerContents> createState() => _DrawerContentsState();
}

class _DrawerContentsState extends ConsumerState<DrawerContents> {
  List<ThemeTypeModel> themeModeList = [
    ThemeTypeModel(mode: ThemeMode.system, name: "System Default"),
    ThemeTypeModel(mode: ThemeMode.light, name: "Light Mode"),
    ThemeTypeModel(mode: ThemeMode.dark, name: "Dark Mode"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height,
      color: AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
      child: Consumer(
        builder: (context, ref, child) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 20.sp),
            child: Column(
              children: [
                YMargin(50.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ImageOf.logoWideOne,
                      height: 35,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: IconOf(Icons.close,
                            size: 24,
                            color:
                                AppThemeNotifier.colorScheme(context).primary))
                  ],
                ),
                YMargin(50.sp),
                drawerOption(ref,
                    id: 0,
                    iconName: drawerIcon('home'),
                    optionName: "Home",
                    onTap: (ref.watch(selectedDrawerProvider) == 0)
                        ? () {
                            Navigator.pop(context);
                          }
                        : () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                AllNavScreens.allNavScreens, (_) => false);
                          }),
                drawerOption(ref,
                    id: 1,
                    iconName: drawerIcon('my_publications'),
                    optionName: "My Publications", onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context,
                      MyPublicationsScreen.myPublicationsScreen, (_) => false);
                }),
                drawerOption(ref,
                    id: 2,
                    iconName: drawerIcon('explore_topics'),
                    optionName: "Explore Topics", onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    TopicsListPreviewScreen.topicsListPreviewScreen,
                    arguments: true,
                    (_) => false,
                  );
                }),
                drawerOption(ref,
                    id: 3,
                    iconName: drawerIcon('my_job'),
                    optionName: "My jobs", onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context,
                      MyJosbAndEscrowFlow.myJosbAndEscrowFlow, (_) => false);
                }),
                ref.watch(switchUserProvider) != UserTypes.researcher
                    ? const SizedBox.shrink()
                    : drawerOption(ref,
                        id: 4,
                        iconName: drawerIcon('suggest_topic'),
                        optionName: "Suggest Topic", onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            ResearchSuggestTopicPage.researchSuggestTopicPage,
                            (_) => false);
                      }),
                drawerOption(ref,
                    id: 5,
                    iconName: drawerIcon('wallet'),
                    optionName: "Wallet", onTap: () {
                  (AppMethods.hasSeenWalletFlow() &&
                          AppMethods.isBackendVerifiedUser())
                      ? Navigator.pushNamedAndRemoveUntil(
                          context, WalletHomePage.walletHomePage, (_) => false)
                      : (AppMethods.hasSeenWalletFlow() &&
                              !AppMethods.isBackendVerifiedUser())
                          ? Navigator.pushNamedAndRemoveUntil(
                              context, CreateWallet.createWallet, (_) => false)
                          : Navigator.pushNamedAndRemoveUntil(
                              context, WalletSetup.walletSetup, (_) => false);
                }),
                drawerOption(ref,
                    id: 6, comingSoon: true,
                    iconName: drawerIcon('originality_test'),
                    optionName: "Originality Test", onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context,
                      OriginalityTestFlow.originalityTestFlow, (_) => false);
                }),
                drawerOption(ref,
                    id: 7,
                    iconName: drawerIcon('research_note'),
                    optionName: "Research Note", onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context,
                      ResearchNotesFlow.researchNotesFlow, (_) => false);
                }),
                drawerOption(ref,
                    id: 8,
                    iconName: drawerIcon('account'),
                    optionName: "Account", onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AccountHomePage.accountHomePage, (_) => false);
                }),
                drawerOption(ref,
                    id: 9,
                    iconName: drawerIcon('report'),
                    optionName: "Report", onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MakeReportScreen.makeReportScreen, (_) => false);
                }),
                drawerOption(ref,
                    id: 10,
                    iconName: drawerIcon('change_theme'),
                    optionName: "Change Theme", onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context,
                      ChangeThemeScreen.changeThemeScreen, (_) => false);
                }),
                SizedBox(
                  height: 50.sp,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      backgroundColor: AppThemeNotifier.themeColor(context)
                          .scaffoldBackgroundColor),
                  child: Row(
                    children: [
                      ImageIcon(
                        AssetImage(drawerIcon("logout")),
                        color: AppColors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      TextOf("Log Out", 16, 5, color: AppColors.red)
                    ],
                  ),
                  onPressed: () {
                    AuthProviders.logout(context, ref);
                  },
                ),
                SizedBox(
                  height: 50.sp,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Column drawerOption(WidgetRef ref,
      {required int id,
      required String iconName,
      required String optionName,
      required VoidCallback onTap, bool comingSoon = false}) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
              backgroundColor: ref.watch(selectedDrawerProvider) == id
                  ? AppColors.primaryColor
                  : AppThemeNotifier.themeColor(context)
                      .scaffoldBackgroundColor),
          onPressed: comingSoon ==true?null: () {
            ref.watch(selectedDrawerProvider.notifier).setState(id);
            // setState(() {
            //   selectedDrawerIndex = id;
            // });

            onTap();
          },
          child: Row(
            children: [
              ImageIcon(
                AssetImage(iconName),
                color: comingSoon ==true ? AppColors.grey2 :(ref.watch(selectedDrawerProvider) == id
                    ? AppColors.white
                    : AppThemeNotifier.colorScheme(context).primary),
                size: 20.sp,
              ),
              SizedBox(width: 10.sp),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    TextOf(
                    optionName,
                    16.sp,
                    5,
                    color: comingSoon == true?AppColors.grey2:( ref.watch(selectedDrawerProvider) == id
                        ? AppColors.white
                        : AppThemeNotifier.colorScheme(context).primary),
                  ),
comingSoon == true? Padding(padding: EdgeInsets.only(bottom: 10.5.sp, left: 5.sp), child: Container(padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 3.sp), decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(30.r)), child: TextOf("Beta", 14.sp, 3, color: AppColors.white))): const SizedBox.shrink()
                  ]),
                  // TextOf(
                  //   optionName,
                  //   16.sp,
                  //   5,
                  //   color: comingSoon == true?AppColors.grey2:( ref.watch(selectedDrawerProvider) == id
                  //       ? AppColors.white
                  //       : AppThemeNotifier.colorScheme(context).primary),
                  // ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}

class ThemeTypeModel {
  ThemeTypeModel({
    required this.mode,
    required this.name,
  });
  final String name;
  ThemeMode mode;
}

// final userJobsProvider =
//     StateNotifierProvider<BaseProvider<JobModel>, ResponseStatus>(
//         (ref) => BaseProvider<JobModel>());

final selectedDrawerProvider =
    StateNotifierProvider<SelectedDrawerProvider, int>(
        (ref) => SelectedDrawerProvider());

class SelectedDrawerProvider extends StateNotifier<int> {
  SelectedDrawerProvider() : super(0);

  void setState(int newState) {
    state = newState;
  }
}
