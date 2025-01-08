import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/profile_provider/profile_provider.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import "package:project_bist/UTILS/profile_image.dart";
import 'package:project_bist/VIEWS/account_flow/portfolio_of_researcher.dart';
import 'package:project_bist/VIEWS/account_flow/preview_profile.dart';
import 'package:project_bist/VIEWS/account_flow/privacy_home.dart';
import 'package:project_bist/VIEWS/account_flow/review_screen.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/drawer_contents.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import "package:fade_shimmer/fade_shimmer.dart";

class AccountHomePage extends ConsumerStatefulWidget {
  const AccountHomePage({super.key});
  static const String accountHomePage = "accountHomePage";
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountHomePageState();
}

class _AccountHomePageState extends ConsumerState<AccountHomePage> {
  @override
  Widget build(BuildContext context) {
    ResponseStatus responseStatus = ref.watch(profileProvider);
    ref.watch(profileProvider.notifier).getRequest(
        context: context, url: Endpoints.GET_PROFILE, showLoading: false);
    getIt<AppModel>().userProfile = UserProfile.fromJson(responseStatus.data);
    UserProfile userProfile = getIt<AppModel>().userProfile!;
    return Scaffold(
        drawer: const DrawerContents(),
        appBar: customAppBar(context,
            hasIcon: true,
            hasElevation: true,
            title: "Account",
            scale: 1.25.sp, leading: Builder(builder: (context) {
          return InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const IconOf(Icons.menu, color: AppColors.primaryColor),
          );
        })),
        body: Builder(builder: (context) {
          return PopScope(
            canPop: false,
            onPopInvoked: (value) {
              Scaffold.of(context).openDrawer();
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox.expand(
                  child: SingleChildScrollView(
                      padding: appPadding().copyWith(top: 28.sp),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: responseStatus.responseState ==
                                    ResponseState.DATA
                                ? () {
                                    Navigator.pushNamed(
                                        context, PreviewProfile.previewProfile);
                                  }
                                : null,
                            child: responseStatus.responseState ==
                                    ResponseState.ERROR
                                ? const SizedBox.shrink()
                                : Row(
                                    children: [
                                      responseStatus.responseState ==
                                              ResponseState.LOADING
                                          ? FadeShimmer.round(
                                              size: 60,
                                              fadeTheme: isDarkTheme(context)
                                                  ? FadeTheme.dark
                                                  : FadeTheme.light,
                                            )
                                          : buildProfileImage(
                                              imageUrl: userProfile.avatar!,
                                              fullNameTobSplit:
                                                  userProfile.fullName!),
                                      XMargin(15.sp),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            responseStatus.responseState ==
                                                    ResponseState.LOADING
                                                ? FadeShimmer(
                                                    height: 12.sp,
                                                    width: 0.35.sw,
                                                    fadeTheme:
                                                        isDarkTheme(context)
                                                            ? FadeTheme.dark
                                                            : FadeTheme.light,
                                                    radius: 4.r,
                                                  )
                                                : TextOf(userProfile.fullName!,
                                                    16.sp, 6),
                                            YMargin(3.sp),
                                            responseStatus.responseState ==
                                                    ResponseState.LOADING
                                                ? FadeShimmer(
                                                    height: 12.sp,
                                                    width: 0.30.sw,
                                                    radius: 4.r,
                                                    fadeTheme:
                                                        isDarkTheme(context)
                                                            ? FadeTheme.dark
                                                            : FadeTheme.light,
                                                  )
                                                : TextOf("Profile details",
                                                    12.sp, 4),
                                          ]),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconOf(
                                                Icons.arrow_forward_ios_rounded,
                                                color: AppThemeNotifier
                                                        .colorScheme(context)
                                                    .primary),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                          YMargin(14.sp),
                          ref.watch(switchUserProvider) != UserTypes.researcher
                              ? const SizedBox.shrink()
                              : accountAtions(
                                  context,
                                  iconPath: ImageOf.profileIconn2,
                                  title: "My Portfolio",
                                  routeToGo: PortfolioOfResearcher
                                      .portfolioOfResearcher,
                                  subtitle: "Publications, reviews and ratings",
                                ),
                          // accountAtions(context,
                          //     iconPath: ImageOf.creditCardIcon,
                          //     title: "Saved cards",
                          //     subtitle: "Add, review or edit connected cards"),
                          // accountAtions(context,
                          //     iconPath: ImageOf.bankIcon,
                          //     title: "Saved Banks",
                          //     subtitle: "Manage bank details"),
                          accountAtions(context,
                              iconPath: ImageOf.lockIcon,
                              title: "Privacy",
                              routeToGo: PrivacyPage.privacyPage,
                              subtitle: "Change password or delete account"),
                          accountAtions(context,
                              iconPath: ImageOf.stariconoutlined,
                              title: "Review",
                              routeToGo: ReviewsScreen.reeviewScreen,
                              subtitle:
                                  "Tell us about how our app make you feel"),
                        ],
                      )),
                ),
                responseStatus.responseState == ResponseState.ERROR
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            child: TextOf("REFRESH THIS PAGE", 15.sp, 5,
                                color: AppColors.primaryColor),
                            onTap: () {
                              ref.watch(profileProvider.notifier).getRequest(
                                  context: context,
                                  url: Endpoints.GET_PROFILE,
                                  showLoading: false);
                            },
                          ),
                          YMargin(30.sp)
                        ],
                      )
                    : const SizedBox.shrink()
              ],
            ),
          );
        }));
  }
}

Widget accountAtions(BuildContext context,
    {required String iconPath,
    required String title,
    required String subtitle,
    String? routeToGo}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 16.sp),
    child: InkWell(
      onTap: () {
        routeToGo == null ? () {} : Navigator.pushNamed(context, routeToGo);
      },
      child: Row(children: [
        ImageIcon(
          AssetImage(iconPath),
          size: 20.sp,
          color: AppThemeNotifier.colorScheme(context).primary,
        ),
        XMargin(20.sp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [TextOf(title, 16.sp, 6), TextOf(subtitle, 12.sp, 4)],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconOf(Icons.arrow_forward_ios_rounded,
                  color: AppThemeNotifier.colorScheme(context).primary),
            ],
          ),
        )
      ]),
    ),
  );
}
