// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/PROVIDERS/publications_providers/publications_providers.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/publication_detail/publicaton_detail_info_unpurchased.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import "package:project_bist/UTILS/profile_image.dart";
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/publications_two_item.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/topic_display_items.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/widgets/texts.dart';
import "package:timeago/timeago.dart" as timeago;
import 'package:project_bist/MODELS/topics_model/explore_topics_model.dart';

class PublicationDetailFromDashboardArgument {
  PublicationsList? publicationList;
  PublicationModel publication;
  PublicationDetailFromDashboardArgument(
      {this.publicationList, required this.publication});
}

class PublicationDetailFromDashboard extends ConsumerStatefulWidget {
  static const String publicationDetailFromDashboard =
      "publicationDetailFromDashboard";
  PublicationDetailFromDashboardArgument publicationDetailFromDashboardArgument;
  PublicationDetailFromDashboard(
      {required this.publicationDetailFromDashboardArgument, super.key});

  @override
  ConsumerState<PublicationDetailFromDashboard> createState() =>
      _PublicationDetailFromDashboardState();
}

class _PublicationDetailFromDashboardState
    extends ConsumerState<PublicationDetailFromDashboard> {
  LikeItem likePublication = LikeItem.neutral;

  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isFree = widget
            .publicationDetailFromDashboardArgument.publication.price
            .toInt() ==
        0;
    int publicationLikes =
        widget.publicationDetailFromDashboardArgument.publication.likes;
    List<PublicationModel> getMatchingPublications() {
      List<PublicationModel> matches = [];
      List<String> parts = widget
          .publicationDetailFromDashboardArgument.publication.title
          .split(" ");

      for (PublicationModel singlePublication
          in widget.publicationDetailFromDashboardArgument.publicationList!) {
        if (parts.any((part) => singlePublication.title.contains(part))) {
          matches.add(singlePublication);
        }
      }

      return matches
          .where((e) =>
              getIt<AppModel>().userProfile!.email != e.researcherId.email)
          .toList();
    }

    var recommendationsList = [
      TopicDisplayItem(
        topicModel: ExploreTopicsModel.defaultTopic(),
        hasDivider: true,
      ),
      ...List.generate(
        getMatchingPublications().isNotEmpty
            ? getMatchingPublications().length
            : 0,
        (index) {
          PublicationModel publication = getMatchingPublications()[index];
          return PublicationsTwoItem(
            hasDivider: true,
            publication: publication,
          );
        },
      ),
      TopicDisplayItem(
        // isFromAdmin: true,
        topicModel: ExploreTopicsModel.defaultTopic(),
        hasDivider: true,
      ),
    ];
    recommendationsList.shuffle();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: appPadding().copyWith(bottom: 0, top: 0),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: IconOf(
                        Icons.arrow_back,
                        color: AppThemeNotifier.colorScheme(context).primary,
                      )),
                  XMargin(20.sp),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context,
                            PublicationDetailInfoUnpurchased
                                .publicationDetailInfoUnpurchased,
                            arguments: widget
                                .publicationDetailFromDashboardArgument
                                .publication);
                      },
                      child: Row(
                        children: [
                          buildProfileImage(
                              imageUrl: widget
                                  .publicationDetailFromDashboardArgument
                                  .publication
                                  .researcherId
                                  .avatar,
                              fullNameTobSplit: widget
                                  .publicationDetailFromDashboardArgument
                                  .publication
                                  .name,
                              fontSize: 20.sp,
                              fontWeight: 4,
                              radius: 50.sp),
                          XMargin(10.sp),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextOf(
                                  (widget.publicationDetailFromDashboardArgument
                                                  .publication.owners?.length ??
                                              0) >
                                          1
                                      ? ("${widget.publicationDetailFromDashboardArgument.publication.owners![0]} & ${widget.publicationDetailFromDashboardArgument.publication.owners!.length - 1} other")
                                      : (widget.publicationDetailFromDashboardArgument
                                                      .publication.owners?.length ??
                                                  0) ==
                                              1
                                          ? (widget
                                                  .publicationDetailFromDashboardArgument
                                                  .publication
                                                  .owners ??
                                              [""])[0]
                                          : "only 1 researcher",
                                  16.sp,
                                  5),
                              Row(
                                children: [
                                  TextOf(
                                      timeago
                                              .format(widget
                                                  .publicationDetailFromDashboardArgument
                                                  .publication
                                                  .createdAt)[0]
                                              .toUpperCase() +
                                          timeago
                                              .format(widget
                                                  .publicationDetailFromDashboardArgument
                                                  .publication
                                                  .createdAt)
                                              .substring(
                                                  1,
                                                  timeago
                                                      .format(widget
                                                          .publicationDetailFromDashboardArgument
                                                          .publication
                                                          .createdAt)
                                                      .length),
                                      14.sp,
                                      4),
                                  XMargin(7.sp),
                                  TextOf(
                                    "●",
                                    5,
                                    5,
                                    color: AppThemeNotifier.colorScheme(context)
                                        .primary,
                                  ),
                                  XMargin(7.sp),
                                  IconOf(
                                    Icons.visibility,
                                    size: 15,
                                    color: AppThemeNotifier.colorScheme(context)
                                        .primary,
                                  ),
                                  XMargin(3.sp),
                                  TextOf(
                                      widget
                                          .publicationDetailFromDashboardArgument
                                          .publication
                                          .views
                                          .toString(),
                                      12,
                                      4),
                                  XMargin(7.sp),
                                  TextOf(
                                    "●",
                                    5,
                                    5,
                                    color: AppThemeNotifier.colorScheme(context)
                                        .primary,
                                  ),
                                  XMargin(7.sp),
                                  TextOf(
                                      "${widget.publicationDetailFromDashboardArgument.publication.likes.toString()} Likes",
                                      12,
                                      4),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            YMargin(10.sp),
            Container(
                height: 0.75,
                decoration: BoxDecoration(
                  color: AppColors.grey1.withOpacity(0.75),
                )),
            YMargin(14.sp),

            ///=============== [Expanded Widget Removed from here]
            Expanded(
              child: SingleChildScrollView(
                padding: appPadding().copyWith(bottom: 30.sp, top: 0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: TextOf(
                          widget.publicationDetailFromDashboardArgument
                              .publication.title,
                          20.sp,
                          6,
                          align: TextAlign.left,
                        ))
                      ],
                    ),
                    YMargin(6.sp),
                    Row(
                      children: [
                        TextOf(
                          "Published ${DateFormat.yMMMMd().format(widget.publicationDetailFromDashboardArgument.publication.createdAt)}",
                          14.sp,
                          4,
                        ),
                        XMargin(7.sp),
                        TextOf(
                          "●",
                          5,
                          5,
                          color: AppThemeNotifier.colorScheme(context).primary,
                        ),
                        XMargin(7.sp),
                        TextOf(
                            widget.publicationDetailFromDashboardArgument
                                .publication.type,
                            14.sp,
                            4),
                      ],
                    ),
                    YMargin(6.sp),
                    Row(
                      children: [
                        TextOf(
                          "References (${widget.publicationDetailFromDashboardArgument.publication.numOfRef.toString()})",
                          14,
                          4,
                          color: AppThemeNotifier.colorScheme(context).primary,
                        ),
                        XMargin(7.sp),
                        TextOf(
                          "●",
                          4,
                          5,
                          color: AppThemeNotifier.colorScheme(context).primary,
                        ),
                        XMargin(7.sp),
                        ImageIcon(
                          AssetImage(ImageOf.mergeIcon),
                          color: AppThemeNotifier.colorScheme(context).primary,
                          size: 18.sp,
                        ),
                        XMargin(5.sp),
                        TextOf(
                          "${((widget.publicationDetailFromDashboardArgument.publication.uniquenessScore) * 100).toInt()}% Unique",
                          14,
                          4,
                          color: AppThemeNotifier.colorScheme(context).primary,
                        ),
                      ],
                    ),
                    YMargin(8.sp),

                    widget.publicationDetailFromDashboardArgument.publication
                            .tags!
                            .join()
                            .isNotEmpty
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  runSpacing: 10.sp,
                                  children: List.generate(
                                      widget.publicationDetailFromDashboardArgument
                                              .publication.tags?.length ??
                                          0,
                                      (index) => Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.sp,
                                                    vertical: 5.sp),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.brown1(context),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.r),
                                                  border: Border.all(
                                                      color: AppColors.grey3,
                                                      width: 0.5),
                                                ),
                                                margin: EdgeInsets.only(
                                                    right: 10.sp),
                                                child: Center(
                                                  child: TextOf(
                                                      (widget
                                                              .publicationDetailFromDashboardArgument
                                                              .publication
                                                              .tags ??
                                                          [])[index],
                                                      12,
                                                      4),
                                                ),
                                              ),
                                            ],
                                          )),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    YMargin(12.sp),
                    Row(
                      children: [
                        Expanded(
                            child: TextOf(
                          "Abstract",
                          18.sp,
                          5,
                          align: TextAlign.left,
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextOf(
                          widget.publicationDetailFromDashboardArgument
                              .publication.abstractText,
                          16.sp,
                          4,
                          align: TextAlign.left,
                          height: 1.7.sp,
                        ))
                      ],
                    ),
                    YMargin(20.sp),
                    Row(children: [
                      Padding(
                        padding: EdgeInsets.only(right: 15.sp),
                        child: Row(
                          children: [
                            //
                            InkWell(
                                child: IconOf(
                                    ((likePublication == LikeItem.like ||
                                            widget.publicationDetailFromDashboardArgument
                                                    .publication.hasBeenLiked ==
                                                true)
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_outlined),
                                    size: 15.sp,
                                    color: AppThemeNotifier.colorScheme(context)
                                        .primary),
                                onTap: () {
                                  setState(() {
                                    showLoading = true;
                                  });

                                  PublicationsAndPlagiarismCheckProvider
                                          .likeAndUnlikePublication(
                                              context, ref,
                                              publicationId: widget
                                                  .publicationDetailFromDashboardArgument
                                                  .publication
                                                  .id)
                                      .then((value) {
                                    setState(() {
                                      showLoading = false;
                                    });
                                    if (value.status == true) {
                                      setState(() {
                                        likePublication =
                                            (likePublication == LikeItem.unlike
                                                ? LikeItem.like
                                                : LikeItem.unlike);
                                      });
                                    }
                                  });
                                }),
                            XMargin(5.sp),
                            TextOf(publicationLikes.toString(), 16.sp, 4)
                          ],
                        ),
                      ),
                      ...[
                        Transform.scale(
                          scale: 0.3.sp,
                          child: (showLoading == true &&
                                  ref
                                          .watch(likePublicationsProvider)
                                          .responseState ==
                                      ResponseState.LOADING)
                              ? const CircularProgressIndicator()
                              : ref
                                          .watch(likePublicationsProvider)
                                          .responseState ==
                                      ResponseState.ERROR
                                  ? Text(ref
                                      .watch(likePublicationsProvider)
                                      .message!)
                                  : const SizedBox.shrink(),
                        )
                      ]
                    ]),
                    YMargin(32.sp),
                    // ref.watch(switchUserProvider) == UserTypes.researcher
                    //     ? researcherSalesAndAmountEarned()
                    //     :

                    Column(children: [
                      Row(
                        children: [
                          TextOf("${isFree ? "Get" : "Buy"} Publication", 16.sp,
                              4),
                          XMargin(10.sp),
                          isFree
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7.sp, vertical: 3.sp),
                                  decoration: BoxDecoration(
                                      color: AppColors.brown,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.r),
                                          bottomRight: Radius.circular(10.r))),
                                  child: TextOf(
                                    "Free",
                                    10.sp,
                                    4,
                                    letterSpacing: 2,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                      YMargin(20.sp),
                      Button(
                        text: isFree
                            ? "Download"
                            : "Pay ${AppConst.COUNTRY_CURRENCY} ${widget.publicationDetailFromDashboardArgument.publication.price.toInt()}",
                        onPressed: () {
                          // PublicationsAndPlagiarismCheckProvider
                          //     .purchasePublication(context,
                          //         publicationId: widget
                          //             .publicationDetailFromDashboardArgument
                          //             .publication
                          //             .id);
                          if (isFree) {
                            /// [TO-DO Download Publication]
                            // AppMethods.downloadFile(
                            //     url: url, fileName: fileName);
                          } else {
                            Navigator.pushNamed(
                                context,
                                PublicationDetailInfoUnpurchased
                                    .publicationDetailInfoUnpurchased,
                                arguments: widget
                                    .publicationDetailFromDashboardArgument
                                    .publication);
                          }
                        },
                        buttonType: ButtonType.blueBg,
                      ),
                      YMargin(24.sp),
                      Row(
                        children: [TextOf("Recommended for You", 18.sp, 5)],
                      ),
                      YMargin(20.sp),
                      ...recommendationsList
                    ])
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container researcherSalesAndAmountEarned(
      {int? peoplePurchaseNumber, int? purchaseAmountNaira}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 16.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.brown1(context)),
        child: Column(children: [
          Row(children: [
            TextOf(peoplePurchaseNumber.toString(), 14.sp, 7),
            XMargin(10.sp),
            TextOf("people bought this publication", 14.sp, 4)
          ]),
          YMargin(12.sp),
          Row(children: [
            TextOf(
                "${AppConst.COUNTRY_CURRENCY} ${purchaseAmountNaira.toString()}",
                14.sp,
                7),
            XMargin(10.sp),
            TextOf("generated from this publication", 14.sp, 4)
          ]),
        ]));
  }
}

const String abstractText =
    "Although natural wetlands only cover about 4% of the earth's ice-free land surface, they are the world's largest methane (CH4) source and the only one dominated by climate. In addition, wetlands affect climate by modulating temperatures and heat fluxes, storing water, increasing evaporation, and altering the seasonality of runoff and river discharge to the oceans.\n\nCurrent CH4 emissions from wetlands are relatively well understood but the sensitivity of wetlands and their emissions to climate variations remains the largest uncertainty in the global CH4 cycle and could strongly influence predictions of future climate.";
