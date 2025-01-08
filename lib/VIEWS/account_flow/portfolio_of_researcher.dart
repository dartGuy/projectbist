import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/profile_provider/profile_provider.dart';
import 'package:project_bist/PROVIDERS/publications_providers/publications_providers.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/profile_image.dart';
import 'package:project_bist/VIEWS/my_publications/my_publications.dart';
// ignore_for_file: library_private_types_in_public_api
import 'package:project_bist/VIEWS/reseaechers_reviews_screen/reseaechers_reviews_screen.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/loading_indicator.dart';
import 'package:project_bist/WIDGETS/publication_item.dart';
import 'package:project_bist/WIDGETS/review_item.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';

import '../../WIDGETS/error_page.dart';

class PortfolioOfResearcher extends ConsumerStatefulWidget {
  static const String portfolioOfResearcher = "portfolioOfResearcher";
  const PortfolioOfResearcher({super.key});

  @override
  ConsumerState<PortfolioOfResearcher> createState() =>
      _PortfolioOfResearcherState();
}

class _PortfolioOfResearcherState extends ConsumerState<PortfolioOfResearcher> {
  @override
  @override
  Widget build(BuildContext context) {
    ResponseStatus responseStatus = ref.watch(profileProvider);
    ref.watch(profileProvider.notifier).getRequest(
        context: context,
        url: Endpoints.GET_PROFILE,
        loadingMessage: "Please wait...");
    getIt<AppModel>().userProfile = UserProfile.fromJson(responseStatus.data);
    UserProfile userProfile = getIt<AppModel>().userProfile!;

    return Scaffold(
        appBar: customAppBar(context,
            title: "My Portfolio", hasElevation: true, hasIcon: true),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: switch (responseStatus.responseState!) {
              ResponseState.LOADING =>
                LoadingIndicator(message: "Please wait..."),
              ResponseState.ERROR => ErrorPage(
                  message: responseStatus.message!,
                  onPressed: () {
                    ref.watch(profileProvider.notifier).getRequest(
                        context: context,
                        url: Endpoints.GET_PROFILE,
                        loadingMessage: "Please wait...",
                        inErrorCase: true);
                  }),
              ResponseState.DATA => Column(children: [
                  topSection(context, userProfile: userProfile),
                  eachResearcherDetailItem(context,
                      iconName: ImageOf.locationIcon,
                      title: "Institution",
                      subtitle: userProfile.institutionName!),
                  eachResearcherDetailItem(
                    context,
                    iconName: ImageOf.areaOfExperienceIcon,
                    title: "Area of Expertise",
                    subtitle: userProfile.division!,
                    others: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          YMargin(16.sp),
                          TextOf("Sector/ parastatal of Expertise", 16, 4,
                              color: AppThemeNotifier.colorScheme(context)
                                  .onSecondary),
                          YMargin(8.sp),
                          TextOf(userProfile.faculty!, 18, 6),
                        ]),
                  ),
                  eachResearcherDetailItem(context,
                      iconName: ImageOf.yearsOfExperience,
                      title: "Years of Experience",
                      subtitle: "3 Years Experience"),
                  eachResearcherDetailItem(context,
                      iconName: ImageOf.stariconoutlined,
                      title: "Rating",
                      subtitle: "3.5/5.0"),
                  eachResearcherDetailItem(context,
                      iconName: ImageOf.declinerateicon,
                      title: "Decline Rate",
                      subtitle: "15%(Good)"),
                  eachResearcherDetailItem(context,
                      iconName: ImageOf.deliveryRateIcon,
                      title: "Delivery Rate",
                      subtitle: "90%(Fast)"),
                  // AppComponents.publicationsListSections(context),

                  const Divider(
                    color: AppColors.grey4,
                    thickness: 0.4,
                  ),
                  publicationsSection(userProfile: userProfile),
                  AppDivider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Column(
                      children: [
                        Row(
                          children: [TextOf("Rating", 14.sp, 4)],
                        ),
                        YMargin(8.sp),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextOf("4.2/5.0", 26.sp, 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                        5,
                                        (_) => Image.asset(
                                              ImageOf.ratedIcon,
                                              height: 18.sp,
                                            )),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(flex: 4, child: SizedBox.shrink()),
                            Expanded(
                              flex: 8,
                              child: Column(
                                children: List.generate(
                                    5,
                                    (index) => Row(children: [
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextOf(
                                                    ((index - 5)
                                                            .abs()
                                                            .toDouble())
                                                        .toString(),
                                                    16.sp,
                                                    5),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              flex: 2, child: XMargin(10.sp)),
                                          Expanded(
                                            flex: 12,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ...List.generate(
                                                    (index - 5).abs(),
                                                    (index) => Image.asset(
                                                          ImageOf.ratedIcon,
                                                          height: 15.sp,
                                                        )),
                                                ...List.generate(
                                                    (index),
                                                    (index) => Image.asset(
                                                          ImageOf.ashStar,
                                                          height: 15.sp,
                                                        ))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextOf(
                                                    ((index - 5).abs() * 4)
                                                        .toString(),
                                                    16.sp,
                                                    5),
                                              ],
                                            ),
                                          ),
                                        ])),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  YMargin(7.sp),
                  AppDivider(),
                  reviewsSection()
                ])
            })

        // switch (responseStatus.responseState!) {
        //       // ResponseState.LOADING =>
        //       //   LoadingIndicator(message: "Fetching your portfolio..."),
        //       // ResponseState.ERROR => ErrorPage(
        //       //     message: responseStatus.message ==
        //       //             AppConst.INTERTET_CONNECTION_ERROR
        //       //         ? "Poor intgernet connection. Please ensure you are connected and try again!"
        //       //         : responseStatus.message!,
        //       //     onPressed: () {
        //       //       ref
        //       //           .watch(profileProvider.notifier)
        //       //           .getRequest(context: context, url: Endpoints.GET_PROFILE);
        //       //       responseStatus = ref.watch(profileProvider);
        //       //     },
        //       //   ),
        //       // ResponseState.DATA =>
        //  }
        );
  }

  reviewsSection() {
    return Padding(
      padding: appPadding().copyWith(top: 16.sp),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextOf("Reviews (57)", 14.sp, 4),
            Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context,
                          ResearchersReviewsScreen.researchersReviewsScreen);
                    },
                    child: TextOf(
                      "View all",
                      12,
                      4,
                      decoration: TextDecoration.underline,
                      color: AppColors.brown,
                    ),
                  ),
                  XMargin(5.sp),
                  IconOf(Icons.arrow_forward_ios_rounded,
                      color: AppColors.brown, size: 15.sp)
                ],
              )
            ]))
          ]),
          YMargin(16.sp),
          ...List.generate(
              3,
              (index) => ReviewItem(
                    hasDivider: index == 2 ? false : true,
                    starNumer: index == 1 ? 3 : 5,
                  ))
        ],
      ),
    );
  }

  bool hasDone = false;
  publicationsSection({required UserProfile userProfile}) {
    ResponseStatus responseStatus = ref.watch(publicationsProvider);
    if (responseStatus.responseState != ResponseState.DATA &&
        hasDone == false) {
      setState(() {
        hasDone = true;
      });
      ref.watch(publicationsProvider.notifier).getRequest(
          context: context,
          url: Endpoints.GENERAL_PUBLICATIONS_LIST,
          showLoading: false);
    }

    print("Response Data: ${responseStatus.runtimeType}");

    List<dynamic>? publicationsList = responseStatus.data;

    getIt<AppModel>().researchersPersonalPublications = publicationsList
        ?.map((e) => PublicationModel.fromJson(e))
        .toList()
        .where((e) => e.researcherId.email == userProfile.email)
        .toList();

    PublicationsList generalPublicationList =
        getIt<AppModel>().researchersPersonalPublications ?? [];

    return Padding(
      padding: appPadding().copyWith(
        top: 16.sp,
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextOf("My Publications", 14.sp, 4),
            Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, MyPublicationsScreen.myPublicationsScreen,
                          arguments: true);
                    },
                    child: TextOf(
                      "View all",
                      12,
                      4,
                      decoration: TextDecoration.underline,
                      color: AppColors.brown,
                    ),
                  ),
                  XMargin(5.sp),
                  IconOf(Icons.arrow_forward_ios_rounded,
                      color: AppColors.brown, size: 15.sp)
                ],
              )
            ]))
          ]),
          YMargin(16.sp),
          ...List.generate(generalPublicationList.length, (index) {
            PublicationModel publicationModel = generalPublicationList[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PublicationItem(
                  width: double.infinity,
                  publicationModel: publicationModel,
                ),
                YMargin(10.sp)
              ],
            );
          })
        ],
      ),
    );
  }
}

Widget topSection(BuildContext context, {required UserProfile userProfile}) {
  return Padding(
    padding: appPadding().copyWith(bottom: 0),
    child: Column(
      children: [
        buildProfileImage(
            imageUrl: userProfile.avatar!,
            fullNameTobSplit: userProfile.fullName!),
        YMargin(20.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextOf(userProfile.fullName!, 20.sp, 6),
            XMargin(4.sp),
            ElTooltip(
                color: AppThemeNotifier.themeColor(context)
                    .scaffoldBackgroundColor,
                position: ElTooltipPosition.bottomCenter,
                showArrow: false,
                content: TextOf("Veteran Researcher", 10.sp, 4),
                child: Image.asset(
                  ImageOf.verified,
                  height: 22,
                )),
          ],
        ),
        YMargin(10.sp),
      ],
    ),
  );
}

Widget eachResearcherDetailItem(BuildContext context,
    {required String iconName,
    required String title,
    required String subtitle,
    Widget? others}) {
  return Padding(
    padding: appPadding().copyWith(top: 0, bottom: 16.sp),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageIcon(
          AssetImage(iconName),
          size: 14.sp,
          color: AppThemeNotifier.colorScheme(context).primary,
        ),
        //Image.asset(iconName, height: 14.sp),
        XMargin(14.sp),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextOf(title, 16, 4,
                color: AppThemeNotifier.colorScheme(context).onSecondary),
            YMargin(8.sp),
            TextOf(
              subtitle,
              18,
              6,
              align: TextAlign.left,
            ),
            others ?? const SizedBox.shrink()
          ]),
        ),
      ],
    ),
  );
}
