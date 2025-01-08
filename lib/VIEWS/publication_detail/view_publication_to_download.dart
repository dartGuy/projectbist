import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/PROVIDERS/publications_providers/publications_providers.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/UTILS/profile_image.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import "package:project_bist/MODELS/publication_models/publicaiton_model.dart";

class ViewPublicationToDownload extends ConsumerStatefulWidget {
  static const String viewPublicationToDownload = "viewPublicationToDownload";
  final PublicationModel publicationModel;
  const ViewPublicationToDownload({required this.publicationModel, super.key});

  @override
  ConsumerState<ViewPublicationToDownload> createState() =>
      _ViewPublicationToDownloadState();
}

class _ViewPublicationToDownloadState
    extends ConsumerState<ViewPublicationToDownload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context,
            title: "Download Publication", hasIcon: true, hasElevation: true),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              Padding(
                padding: appPadding(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: TextOf(
                          widget.publicationModel.title,
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
                          "Published ${DateFormat.yMMMMd().format(widget.publicationModel.createdAt)}",
                          14.sp,
                          4,
                        ),
                        XMargin(7.sp),
                        TextOf(
                          "●",
                          5,
                          5,
                          color: AppColors.black,
                        ),
                        XMargin(7.sp),
                        TextOf(widget.publicationModel.type, 14.sp, 4),
                      ],
                    ),
                    YMargin(6.sp),
                    Row(children: [
                      TextOf(
                        "References (${widget.publicationModel.numOfRef})",
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
                        "${(widget.publicationModel.uniquenessScore * 100).toInt()}% Unique",
                        14,
                        4,
                        color: AppThemeNotifier.colorScheme(context).primary,
                      ),
                    ]),
                    YMargin(20.sp),
                    Row(children: [TextOf("Authors", 16.sp, 4)]),
                    Row(
                      children: [
                        Expanded(
                            child: Wrap(
                                runSpacing: 10.sp,
                                children: List.generate(
                                    (widget.publicationModel.owners?.length ??
                                        0),
                                    (index) => Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            buildProfileImage(
                                                radius: 20.sp,
                                                fontSize: 12.sp,
                                                fontWeight: 5,
                                                imageUrl: widget
                                                    .publicationModel
                                                    .researcherId
                                                    .avatar,
                                                fullNameTobSplit: (widget
                                                        .publicationModel
                                                        .owners?[index] ??
                                                    "")),
                                            XMargin(5.sp),
                                            TextOf(
                                                ((widget.publicationModel
                                                        .owners?[index] ??
                                                    "")),
                                                16,
                                                5),
                                            XMargin(10.sp),
                                            index == 0
                                                ? Image.asset(ImageOf.verified2,
                                                    height: 20.sp)
                                                : const SizedBox.shrink(),
                                            XMargin(10.sp)
                                          ],
                                        ))))
                      ],
                    ),
                  ],
                ),
              ),
              AppDivider(),
              YMargin(16.sp),
              eachResearcherDetailItem(context,
                  iconName: ImageOf.locationIcon,
                  title: "Institution",
                  subtitle: "Obafemi Awolowo Univeristy, Ile-Ife"),
              eachResearcherDetailItem(
                context,
                iconName: ImageOf.areaOfExperienceIcon,
                title: "Area of Expertise",
                subtitle: widget.publicationModel.researcherId.sector,
                others: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YMargin(16.sp),
                      TextOf(
                        "Sector/ parastatal of Expertise",
                        16,
                        4,
                      ),
                      YMargin(8.sp),
                      TextOf(
                          widget.publicationModel.researcherId.division, 18, 6),
                    ]),
              ),
              eachResearcherDetailItem(context,
                  iconName: ImageOf.yearsOfExperience,
                  title: "Years of Experience",
                  subtitle: widget.publicationModel.researcherId.experience),
              eachResearcherDetailItem(context,
                  iconName: ImageOf.stariconoutlined,
                  title: "Rating",
                  subtitle: "3.5/5.0"),
              YMargin(60.sp),
              Padding(
                padding: appPadding().copyWith(top: 14.sp),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ImageIcon(
                        AssetImage(ImageOf.downloadIcon),
                        size: 20.sp,
                        color: AppColors.brown,
                      ),
                      XMargin(10.sp),
                      TextOf(
                        "Download file",
                        20.sp,
                        5,
                        color: AppColors.brown,
                      )
                    ]),
                    YMargin(34.sp),
                    InkWell(
                        child: TextOf(
                          "Delete Publication",
                          16.sp,
                          5,
                          color: AppColors.red,
                        ),
                        onTap: () {
                          Alerts.optionalDialog(context,
                              text:
                                  "Are you sure you want to delete this publication?",
                              onTapRight: () {
                            PublicationsAndPlagiarismCheckProvider
                                .deletePublication(context,
                                    publicationId: widget.publicationModel.id,
                                    ref: ref);
                          });
                        })
                  ],
                ),
              )
            ])));
  }
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
