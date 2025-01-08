import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/MODELS/reseaecrers_review/researchers_review.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/publications_providers/publications_providers.dart';
import 'package:project_bist/PROVIDERS/reviews_provider/reviews_provider.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/profile_image.dart';
import 'package:project_bist/VIEWS/client_generate_payment/client_generate_payment.dart';
import 'package:project_bist/VIEWS/messaging/chats_list_screen.dart.dart';

// ignore_for_file: library_private_types_in_public_api
import 'package:project_bist/VIEWS/reseaechers_reviews_screen/reseaechers_reviews_screen.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/components/app_components.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/loading_indicator.dart';
import 'package:project_bist/WIDGETS/review_item.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import '../../MODELS/message_model/single_chat_model.dart';
import '../../PROVIDERS/escrow_provider/escrow_provider.dart';
import '../../PROVIDERS/message_provider/chats_provider.dart';
import '../../WIDGETS/error_page.dart';

class ResearchersProfileScreen extends ConsumerStatefulWidget {
  static const String researchersProfileScreen = "researchersProfileScreen";
  UserProfile? userProfile;

  ResearchersProfileScreen({this.userProfile, super.key});

  @override
  ConsumerState<ResearchersProfileScreen> createState() => _ResearchersProfileScreenState();
}

class _ResearchersProfileScreenState extends ConsumerState<ResearchersProfileScreen> {
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    ResponseStatus responseStatus = ref.watch(publicationsProvider);
    ResponseStatus responseStatusOfResearchersReviews = ref.watch(reviewsProvider);

    if (responseStatus.responseState == ResponseState.LOADING || responseStatusOfResearchersReviews.responseState == ResponseState.LOADING) {
      ref.watch(publicationsProvider.notifier).getRequest(context: context, url: Endpoints.GENERAL_PUBLICATIONS_LIST, showLoading: false);
      ref.watch(reviewsProvider.notifier).getRequest(context: context, url: Endpoints.FETCH_RESEARCHERS_REVIEWS(widget.userProfile!.id!), showLoading: false);
    }
    List<dynamic>? publicationsList = responseStatus.data;
    getIt<AppModel>().postedPublicationList = publicationsList?.map((e) => PublicationModel.fromJson(e)).toList();
    PublicationsList postedPublicationList = getIt<AppModel>().postedPublicationList ?? [];

    List<dynamic>? rawResearchersReviewsList = responseStatusOfResearchersReviews.data;
    getIt<AppModel>().researchersReviewsList = rawResearchersReviewsList?.map((e) => ResearchersReview.fromJson(e)).toList();
    ResearchersReviewsList researchersReviewsList = getIt<AppModel>().researchersReviewsList ?? [];

    reviewsSection() {
      return Padding(
        padding: appPadding().copyWith(top: 16.sp),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextOf("Reviews (${researchersReviewsList.length})", 14.sp, 4),
              Expanded(
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, ResearchersReviewsScreen.researchersReviewsScreen);
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
                    IconOf(Icons.arrow_forward_ios_rounded, color: AppColors.brown, size: 15.sp)
                  ],
                )
              ]))
            ]),
            YMargin(16.sp),
            ...List.generate(
                researchersReviewsList.length,
                (index) => ReviewItem(
                      hasDivider: index == 2 ? false : true,
                      starNumer: index == 1 ? 3 : 5,
                    ))
          ],
        ),
      );
    }

    if (responseStatus.message != null) {
      errorMessage += "Publications Error: ${responseStatus.message}\n";
    }

    if (responseStatusOfResearchersReviews.message != null) {
      errorMessage += "Reviews Error: ${responseStatusOfResearchersReviews.message}\n";
    }

    return Scaffold(
      appBar: customAppBar(context, title: "Researcher’s Profile", hasElevation: true, hasIcon: true),
      body: (responseStatus.responseState == ResponseState.LOADING || responseStatusOfResearchersReviews.responseState == ResponseState.LOADING)
          ? LoadingIndicator(message: "Getting your profile...")
          : (responseStatus.responseState == ResponseState.ERROR || responseStatusOfResearchersReviews.responseState == ResponseState.ERROR)
              ? ErrorPage(
                  message: errorMessage,
                  onPressed: () {
                    if (responseStatus.responseState == ResponseState.ERROR) {
                      ref.watch(publicationsProvider.notifier).getRequest(context: context, url: Endpoints.GENERAL_PUBLICATIONS_LIST, showLoading: false);
                    }
                    if (responseStatusOfResearchersReviews.responseState == ResponseState.ERROR) {
                      ref.watch(reviewsProvider.notifier).getRequest(context: context, url: Endpoints.FETCH_RESEARCHERS_REVIEWS(widget.userProfile!.id!), showLoading: false);
                    }
                  })
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(children: [
                    topSection(context, ref: ref, userProfile: widget.userProfile!),
                    AppDivider(),
                    YMargin(10.sp),
                    eachResearcherDetailItem(context, iconName: ImageOf.locationIcon, title: "Institution", subtitle: widget.userProfile!.institutionName!),
                    eachResearcherDetailItem(
                      context,
                      iconName: ImageOf.areaOfExperienceIcon,
                      title: "Area of Expertise",
                      subtitle: widget.userProfile!.division!,
                      others: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        YMargin(16.sp),
                        TextOf("Sector/parastatal of Expertise", 16, 4, color: AppThemeNotifier.colorScheme(context).onSecondary),
                        YMargin(8.sp),
                        TextOf(widget.userProfile!.faculty!, 18, 6),
                      ]),
                    ),
                    eachResearcherDetailItem(context, iconName: ImageOf.yearsOfExperience, title: "Years of Experience", subtitle: widget.userProfile!.experience!),
                    eachResearcherDetailItem(context, iconName: ImageOf.stariconoutlined, title: "Rating", subtitle: "3.5/5.0"),
                    eachResearcherDetailItem(context, iconName: ImageOf.declinerateicon, title: "Decline Rate", subtitle: "15%(Good)"),
                    eachResearcherDetailItem(context, iconName: ImageOf.deliveryRateIcon, title: "Delivery Rate", subtitle: "90%(Fast)"),
                    AppComponents.publicationsListSections(context,
                        publicationList: postedPublicationList
                            .where(
                              (e) => e.researcherId.email == widget.userProfile!.email,
                            )
                            .toList(),
                        message: "This researcher doesn't have publications posted yet"),
                    const Divider(
                      color: AppColors.grey4,
                      thickness: 0.4,
                    ),
                    reviewsSection()
                  ])),
    );
  }
}

Widget topSection(BuildContext context, {required WidgetRef ref, required UserProfile userProfile}) {
  // final messageProvider = StateNotifierProvider<MessageNotifier, List<SingleChatModel>>((ref) {
  //   return MessageNotifier();
  // });
  return Padding(
    padding: appPadding().copyWith(bottom: 10),
    child: Column(
      children: [
        buildProfileImage(imageUrl: userProfile.avatar!, fullNameTobSplit: userProfile.fullName!),
        YMargin(20.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextOf(userProfile.fullName!, 20.sp, 6),
            XMargin(4.sp),
            Image.asset(
              ImageOf.verified,
              height: 22,
            )
          ],
        ),
        YMargin(10.sp),
        TextOf("Online", 14.sp, 4, color: AppColors.primaryColor),
        YMargin(16.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ref.watch(switchUserProvider) == UserTypes.student
            //     ? const SizedBox.shrink()
            //     :
                eachTopProfileAction(
                    iconName: ImageOf.messageNav,
                    name: "Message   ",
                    onTap: () {
                      List<SingleChatModel> chatsList = ref.watch(chatsProvider).data??[];
                      ChatsProvider.fetchOrCreateChat(context, recipientId:  userProfile.id!, recipientRole: 'researcher');
                      // Navigator.pushNamed(context, ChattingPage.chattingPage,
                      //     arguments: ChattingPageArgument(
                      //         picturePath: userProfile.avatar!,
                      //         buddyName: userProfile.fullName!,
                      //         userType: switch ((userProfile.role, userProfile.clientType)) { ("researcher", "") => UserTypes.researcher, ("client", "student") => UserTypes.student, ("client", "professional") => UserTypes.professional, _ => UserTypes.researcher },
                      //         friendId: userProfile.id!,
                      //         recipientRole: userProfile.role!,
                      //         chatId: switch (chatsList.isEmpty) {
                      //           true => null,
                      //           false => ref.watch(messageProvider).firstWhere((e) {
                      //               User user = [e.user1, e.user2].where((e) => e.id == userProfile.id!).first;
                      //               return (user.id == userProfile.id!);
                      //             }).id
                      //         },
                      //         messagesList: switch (chatsList.isEmpty) {
                      //           true => null,
                      //           false => ref.watch(messageProvider).firstWhere((e) {
                      //               User user = [e.user1, e.user2].where((e) => e.id == userProfile.id!).first;
                      //               return (user.id == userProfile.id!);
                      //             }).messages
                      //         }));
                    },
                  ),
            eachTopProfileAction(
                onTap: () {
                  ref.invalidate(escrowsJobsAppliedByResearcherProvider);
                  Navigator.pushNamed(context, ClientGeneratePayment.clientGeneratePayment, arguments: userProfile);
                },
                iconName: ImageOf.genefratePaymentIcon,
                name: "Generate Payment"),
            eachTopProfileAction(iconName: ImageOf.shareIcon, name: "Share Profile")
          ],
        ),
      ],
    ),
  );
}

Widget eachResearcherDetailItem(BuildContext context, {required String iconName, required String title, required String subtitle, Widget? others}) {
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextOf(title, 16, 4, color: AppThemeNotifier.colorScheme(context).onSecondary),
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

Widget eachTopProfileAction({required String iconName, required String name, void Function()? onTap}) {
  return Column(
    children: [
      InkWell(
        onTap: onTap,
        child: Image.asset(
          iconName,
          height: 25.sp,
        ),
      ),
      YMargin(5.sp),
      TextOf(name, 14.sp, 5, color: AppColors.primaryColor)
    ],
  );
}
