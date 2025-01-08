// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';
import 'package:project_bist/PROVIDERS/publications_providers/publications_providers.dart';
import 'package:project_bist/PROVIDERS/transaction_providers/transaction_providers/transaction_providers.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/components/app_bottom_sheet.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/loading_indicator.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class SelectWalletToPayScreenArgument {
  final PaymentDetail paymentDetail;
  PublicationModel? publicationModel;
  UserProfile? userProfile;
  SelectWalletToPayScreenArgument(
      {required this.paymentDetail, this.publicationModel, this.userProfile});
}

class SelectWalletToPayScreen extends ConsumerStatefulWidget {
  static const String selectWalletToPayScreen = "selectWalletToPayScreen";
  SelectWalletToPayScreenArgument? selectWalletToPayScreenArgument;
  SelectWalletToPayScreen({this.selectWalletToPayScreenArgument, super.key});

  @override
  ConsumerState<SelectWalletToPayScreen> createState() =>
      _SelectWalletToPayScreenState();
}

class _SelectWalletToPayScreenState
    extends ConsumerState<SelectWalletToPayScreen> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    bool walletBalanceInsufficient =
        (getIt<AppModel>().appCacheBox!.get(AppConst.USER_WALLET_BALANCE) ??
                0) <
            widget.selectWalletToPayScreenArgument!.paymentDetail.amountToPay;
    ResponseStatus responseStatus = ref.watch(transactionProvider);
    ref.read(transactionProvider.notifier).getRequest(
        context: context, url: Endpoints.FETCH_WALLET, showLoading: false);

    getIt<AppModel>()
        .appCacheBox!
        .put(AppConst.USER_WALLET_BALANCE, responseStatus.data?["amount"]);

   getIt<AppModel>()
        .appCacheBox!
        .put(AppConst.USER_ESCROW_BALANCE, responseStatus.data?["escrowAmount"]);

        
    return Scaffold(
        appBar: customAppBar(context,
            title: "Pay", hasIcon: true, hasElevation: true),
        body: switch (responseStatus.responseState!) {
          ResponseState.LOADING =>
            LoadingIndicator(message: "Fetching wallet details..."),
          ResponseState.ERROR => ErrorPage(
              message: responseStatus.message! ==
                      AppConst.WALLET_DOES_NOT_EXIST_FOR_USER
                  ? "You haven't created your wallet yet.\nGo to the wallet screen to setup your wallet."
                  : responseStatus.message!,
              showButton: responseStatus.message! !=
                  AppConst.WALLET_DOES_NOT_EXIST_FOR_USER,
              onPressed: () {
                ref.read(transactionProvider.notifier).getRequest(
                    context: context,
                    url: Endpoints.FETCH_WALLET,
                    showLoading: false,
                    inErrorCase: true);
              },
            ),
          ResponseState.DATA => Padding(
              padding: appPadding().copyWith(bottom: 20.sp),
              child: Stack(alignment: Alignment.bottomCenter, children: [
                SizedBox.expand(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextOf(
                              "Make your payment",
                              16,
                              4,
                              align: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      YMargin(16.sp),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                            color: selected == true
                                ? AppColors.secondaryColor.withOpacity(0.15)
                                : AppThemeNotifier.themeColor(context)
                                    .scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                                color: selected == true
                                    ? AppColors.primaryColor
                                    : AppColors.grey4)),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selected = !selected;
                            });
                          },
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  IconOf(
                                    Icons.wallet,
                                    color: isDarkTheme(context)
                                        ? AppColors.grey1
                                        : AppColors.grey4,
                                  ),
                                  XMargin(10.sp),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextOf("Pay from Wallet", 16, 7),
                                      TextOf(
                                          "Balance: NGN ${AppMethods.moneyComma(getIt<AppModel>().appCacheBox!.get(AppConst.USER_WALLET_BALANCE))}",
                                          12,
                                          4)
                                    ],
                                  )
                                ],
                              ),
                              Expanded(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconOf(
                                    selected == true
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: selected == true
                                        ? AppColors.primaryColor
                                        : AppColors.grey4,
                                    size: 25.sp,
                                  )
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                      YMargin(10.sp),
                      Text(
                          walletBalanceInsufficient
                              ? "Your wallet balance is insufficient to complete your payment. Go to \"Menu>Wallet>Fund Wallet\" to fund your wallet."
                              : "Your wallet balance is sufficient to complete your payment",
                          style: TextStyle(
                              color: walletBalanceInsufficient
                                  ? AppColors.red
                                  : null)),
                    ],
                  ),
                ),
                Button(
                  buttonType: (selected == true && !walletBalanceInsufficient)
                      ? ButtonType.blueBg
                      : ButtonType.disabled,
                  onPressed: () {
                    appBottomSheet(context,
                        body: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextOf("Pay from Wallet", 20, 7),
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const IconOf(Icons.close))
                              ],
                            ),
                            YMargin(20.sp),
                            Row(
                              children: [
                                TextOf(
                                  "Confirm to pay for this ${widget.selectWalletToPayScreenArgument!.paymentDetail.paymentFor == PaymentFor.publication ? "publication" : "job"}",
                                  16,
                                  4,
                                  color: isDarkTheme(context)
                                      ? AppColors.grey1
                                      : AppColors.grey3,
                                ),
                              ],
                            ),
                            YMargin(15.sp),
                            ...List.generate(
                                2,
                                (index) => Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  TextOf(
                                                      index == 0
                                                          ? "Payment for"
                                                          : "Amount",
                                                      16,
                                                      4),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                children: [
                                                  TextOf(
                                                      index == 0
                                                          ? (widget
                                                              .selectWalletToPayScreenArgument!
                                                              .paymentDetail
                                                              .paymentForText)
                                                          : "${AppConst.COUNTRY_CURRENCY} ${AppMethods.moneyComma(widget.selectWalletToPayScreenArgument!.paymentDetail.amountToPay)}",
                                                      16,
                                                      6),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        YMargin(15.sp)
                                      ],
                                    )),
                            YMargin(10.sp),
                            Button(
                              text:
                                  "Pay ${AppConst.COUNTRY_CURRENCY} ${AppMethods.moneyComma(widget.selectWalletToPayScreenArgument!.paymentDetail.amountToPay)}",
                              onPressed: () {
                                Navigator.pop(context);

                                if (widget.selectWalletToPayScreenArgument!
                                        .paymentDetail.paymentFor ==
                                    PaymentFor.publication) {
                                  bool status =
                                      PublicationsAndPlagiarismCheckProvider
                                          .purchasePublication(context,
                                              publicationId: widget
                                                  .selectWalletToPayScreenArgument!
                                                  .publicationModel!
                                                  .id);
                                  if (status == true) {
                                    appBottomSheet(context,
                                        body: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextOf(
                                                    "Pay from Wallet", 20, 7),
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const IconOf(
                                                        Icons.close))
                                              ],
                                            ),
                                            YMargin(24.sp),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: TextOf(
                                                  "You can now download the publication to your local storage.",
                                                  14.sp,
                                                  4,
                                                  align: TextAlign.left,
                                                )),
                                              ],
                                            ),
                                            YMargin(16.sp),
                                            RichText(
                                                text: TextSpan(
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: AppThemeNotifier
                                                                .colorScheme(
                                                                    context)
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    text:
                                                        "Bought publication can also be found and downloaded in",
                                                    children: const [
                                                  TextSpan(
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      text:
                                                          "“Menu > My Publications > Bought”")
                                                ])),
                                            YMargin(20.sp),
                                            Button(
                                              text: "Download Publication",
                                              onPressed: () {
                                                List.generate(
                                                    3,
                                                    (_) =>
                                                        Navigator.pop(context));
                                              },
                                              buttonType: ButtonType.blueBg,
                                            )
                                          ],
                                        ));
                                  }
                                } else if (widget
                                        .selectWalletToPayScreenArgument!
                                        .paymentDetail
                                        .paymentFor ==
                                    PaymentFor.job) {
                                  EscrowProvider.createEscrowFromResearchersProfile(
                                      context,
                                      ref: ref,
                                      researcherId: widget
                                          .selectWalletToPayScreenArgument!
                                          .paymentDetail
                                          .receiverOfPaymentId!,
                                      jobId: widget
                                          .selectWalletToPayScreenArgument!
                                          .paymentDetail
                                          .paymentObjectId!,
                                      projectFee: widget
                                          .selectWalletToPayScreenArgument!
                                          .paymentDetail
                                          .amountToPay
                                          .toString(),
                                      userProfile: widget
                                          .selectWalletToPayScreenArgument!
                                          .userProfile!);
                                }
                              },
                              buttonType: ButtonType.blueBg,
                            )
                          ],
                        ));
                  },
                  text: "Continue",
                )
              ]),
            ),
        });
  }
}

enum PaymentFor { publication, job, another }

class PaymentDetail {
  final String paymentForText;
  final int amountToPay;
  String? paymentObjectId, receiverOfPaymentId;
  final PaymentFor paymentFor;

  PaymentDetail(
      {required this.paymentForText,
      required this.paymentFor,
      required this.amountToPay,
      this.paymentObjectId,
      this.receiverOfPaymentId});
}
