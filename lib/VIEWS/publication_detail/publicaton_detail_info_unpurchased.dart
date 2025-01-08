import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/client_generate_payment/select_wallet_to_pay.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import "package:project_bist/UTILS/profile_image.dart";
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class PublicationDetailInfoUnpurchased extends StatefulWidget {
  static const String publicationDetailInfoUnpurchased =
      "publicationDetailInfoUnpurchased";
  const PublicationDetailInfoUnpurchased(
      {required this.publicationModel, super.key});
  final PublicationModel publicationModel;
  @override
  State<PublicationDetailInfoUnpurchased> createState() =>
      _PublicationDetailInfoUnpurchasedState();
}

class _PublicationDetailInfoUnpurchasedState
    extends State<PublicationDetailInfoUnpurchased> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context,
            title: "Publication Info", hasIcon: true, hasElevation: true),
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
                    (widget.publicationModel.owners ?? []).isEmpty
                        ? Row(
                            children: [
                              TextOf("Only 1 author", 15.sp, 4),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                  child: Wrap(
                                      runSpacing: 10.sp,
                                      children: List.generate(
                                          (widget.publicationModel.owners
                                                  ?.length ??
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
                                                      (widget.publicationModel
                                                              .owners?[index] ??
                                                          ""),
                                                      16,
                                                      5),
                                                  XMargin(10.sp),
                                                  index == 0
                                                      ? Image.asset(
                                                          ImageOf.verified2,
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
                  subtitle:
                      widget.publicationModel.researcherId.institutionName),
              eachResearcherDetailItem(
                context,
                iconName: ImageOf.areaOfExperienceIcon,
                title: "Area of Expertise",
                subtitle: widget.publicationModel.researcherId.sector,
                others: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YMargin(16.sp),
                      TextOf("Sector/ parastatal of Expertise", 16, 4,
                          color: AppThemeNotifier.colorScheme(context)
                              .onSecondary),
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
              eachResearcherDetailItem(context,
                  iconName: ImageOf.declinerateicon,
                  title: "Decline Rate",
                  subtitle: "15%(Good)"),
              eachResearcherDetailItem(context,
                  iconName: ImageOf.deliveryRateIcon,
                  title: "Delivery Rate",
                  subtitle: "90%(Fast)"),
              Padding(
                padding: appPadding().copyWith(top: 14.sp),
                child: Column(
                  children: [
                    Row(children: [
                      TextOf("Publication price:", 16.sp, 4),
                      XMargin(7.5.sp),
                      TextOf(
                          "${AppConst.COUNTRY_CURRENCY} ${widget.publicationModel.price.toInt()}",
                          20.sp,
                          5)
                    ]),
                    YMargin(20.sp),
                    Button(
                      text:
                          "Pay ${AppConst.COUNTRY_CURRENCY} ${widget.publicationModel.price.toInt()}",
                      buttonType: ButtonType.blueBg,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context,
                            SelectWalletToPayScreen.selectWalletToPayScreen,
                            arguments: SelectWalletToPayScreenArgument(
                                paymentDetail: PaymentDetail(
                                  paymentForText: "Publication",
                                  paymentFor: PaymentFor.publication,
                                  amountToPay:
                                      widget.publicationModel.price.toInt(),
                                ),
                                publicationModel: widget.publicationModel));
                      },
                    ),
                    YMargin(24.sp),
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
