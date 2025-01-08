import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/transaction_models/transaction_model.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/auth_provider/auth_provider.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/PROVIDERS/transaction_providers/bank_list_provider.dart';
import 'package:project_bist/PROVIDERS/transaction_providers/transaction_providers/transaction_providers.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/VIEWS/all_nav_screens/_all_nav_screens/all_nav_screens.dart.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/VIEWS/wallet_processes/client_select_escrow_to_fund.dart';
import 'package:project_bist/VIEWS/wallet_processes/filter_transaction.dart';
import 'package:project_bist/VIEWS/wallet_processes/flud_wallet_screen.dart';
import 'package:project_bist/VIEWS/wallet_processes/withdraw_screen.dart';
import 'package:project_bist/WIDGETS/components/app_bottom_sheet.dart';
import 'package:project_bist/WIDGETS/drawer_contents.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/loading_indicator.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/VIEWS/notification_screen/notification_screen.dart';

class WalletHomePage extends ConsumerStatefulWidget {
  const WalletHomePage({super.key});

  static const String walletHomePage = "walletHomePage";

  @override
  ConsumerState<WalletHomePage> createState() => _WalletHomePageState();
}

class _WalletHomePageState extends ConsumerState<WalletHomePage> with SingleTickerProviderStateMixin {
  bool showBalance = true;
  final ScrollPhysics _physics = const BouncingScrollPhysics();

  @override
  Widget build(BuildContext context) {
    if (ref.watch(bankListProvider).bankList.isEmpty) {
      ref.watch(bankListProvider.notifier).getBanksList(context);
    }
    ResponseStatus responseStatus = ref.watch(transactionProvider);
    ref.read(transactionProvider.notifier).getRequest(
        context: context, url: Endpoints.FETCH_WALLET, showLoading: false);

    List<dynamic>? transactions = responseStatus.data?["transactions"];
    getIt<AppModel>().transactionList =
        transactions?.map((e) => TransactionModel.fromJson(json: e)).toList();
    getIt<AppModel>()
        .appCacheBox!
        .put(AppConst.USER_WALLET_BALANCE, responseStatus.data?["amount"]);
    getIt<AppModel>().appCacheBox!.put(
        AppConst.USER_ESCROW_BALANCE, responseStatus.data?["escrowAmount"]);

    TransactionList transactionList = getIt<AppModel>().transactionList ?? [];
    return Scaffold(
      appBar: customAppBar(
        context,
        hasIcon: true,
        hasElevation: true,
        title: "Wallet",
        scale: 1.25.sp,
        leading: Builder(builder: (context) {
          return InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const IconOf(Icons.menu, color: AppColors.primaryColor),
          );
        }),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.sp),
            child: InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, ref.watch(switchUserProvider) == UserTypes.researcher? NotificationScreen.notificationScreen: AllNavScreens.allNavScreens, (route) => false,
                    arguments: ref.watch(switchUserProvider) == UserTypes.researcher?TabController(length: 4, vsync: this): 2);
              },
              child: ImageIcon(
                AssetImage(
                  ImageOf.notificationNav,
                ),
                color: AppThemeNotifier.colorScheme(context).primary,
                size: 20.sp,
              ),
            ),
          )
        ],
      ),
      drawer: const DrawerContents(),
      body: Builder(builder: (context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (value) {
            Scaffold.of(context).openDrawer();
          },
          child: SingleChildScrollView(
            physics: _physics,
            child: Column(
              children: [
                Padding(
                  padding: appPadding(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextOf(
                            showBalance
                                ? "${AppConst.COUNTRY_CURRENCY} ${AppMethods.moneyComma(getIt<AppModel>().appCacheBox!.get(AppConst.USER_WALLET_BALANCE) ?? 0.00)}"
                                : "*********",
                            24.sp,
                            7,
                            align: TextAlign.left,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TextOf(
                            "Wallet balance",
                            14.sp,
                            4,
                            align: TextAlign.left,
                            color: isDarkTheme(context)
                                ? AppColors.grey1
                                : AppColors.grey3,
                          )),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                setState(() {
                                  showBalance = !showBalance;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.sp, vertical: 5.sp),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.primaryColor),
                                  borderRadius: BorderRadius.circular(50.sp),
                                ),
                                child: TextOf(
                                    "${showBalance ? "Hide" : 'Show'} Balance",
                                    14.sp,
                                    4,
                                    color: AppThemeNotifier.colorScheme(context)
                                        .primary),
                              )),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextOf(
                            showBalance
                                ? "${AppConst.COUNTRY_CURRENCY} ${AppMethods.moneyComma(getIt<AppModel>().appCacheBox!.get(AppConst.USER_ESCROW_BALANCE) ?? 0.00)}"
                                : "*********",
                            24.sp,
                            7,
                            align: TextAlign.left,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TextOf(
                            "Escrow balance",
                            14.sp,
                            4,
                            align: TextAlign.left,
                            color: isDarkTheme(context)
                                ? AppColors.grey1
                                : AppColors.grey3,
                          )),
                        ],
                      ),
                      YMargin(12.sp),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 10,
                            child: SizedBox(
                                height: 48.sp,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: AppColors.brown,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.r)),
                                    ),
                                    onPressed: () {
                                      if (ref.watch(switchUserProvider) ==
                                          UserTypes.researcher) {
                                        Navigator.pushNamed(context,
                                            FundWalletScreen.fundWalletScreen);
                                      } else {
                                        clientFundOptionsBottomSheet(context);
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const IconOf(
                                          Icons.add,
                                          color: AppColors.white,
                                        ),
                                        XMargin(7.sp),
                                        TextOf(
                                            "Fund${ref.watch(switchUserProvider) == UserTypes.researcher ? " Wallet" : ""}",
                                            16,
                                            5,
                                            color: AppColors.white),
                                      ],
                                    ))),
                          ),
                          const Expanded(flex: 1, child: SizedBox.shrink()),
                          Expanded(
                            flex: 10,
                            child: SizedBox(
                                height: 48.sp,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: AppColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.r)),
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(verifyAccountNumberProvider
                                              .notifier)
                                          .switchState(ResponseAvailabilityState
                                              .NEUTRAL);
                                      Navigator.pushNamed(context,
                                          WithdrawScreen.withdrawScreen);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          ImageOf.withdrwIcon,
                                          height: 15.sp,
                                        ),
                                        XMargin(7.sp),
                                        TextOf("Withdraw", 16, 5,
                                            color: AppColors.white),
                                      ],
                                    ))),
                          )
                        ],
                      ),
                      // YMargin(16.sp),
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.4,
                  color: AppThemeNotifier.colorScheme(context).onSecondary,
                ),
                SingleChildScrollView(
                  padding: appPadding(),
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextOf("Transaction History", 14.sp, 4),
                          (transactionList.isEmpty ||
                                  responseStatus.responseState !=
                                      ResponseState.DATA)
                              ? const IconOf(Icons.filter_list)
                              : InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        FilterTransaction.filterTransaction);
                                  },
                                  child: const IconOf(Icons.filter_list))
                        ],
                      ),
                      YMargin(10.sp),
                      YMargin(responseStatus.responseState != ResponseState.DATA
                          ? 0.05.sh
                          : 0),
                      switch (responseStatus.responseState!) {
                        ResponseState.LOADING =>
                          LoadingIndicator(message: "Fetching transactions..."),
                        ResponseState.ERROR => ErrorPage(
                            message: responseStatus.message!,
                            onPressed: () {
                              ref
                                  .watch(transactionProvider.notifier)
                                  .getRequest(
                                      context: context,
                                      url: Endpoints.FETCH_WALLET,
                                      showLoading: false,
                                      inErrorCase: true);
                            },
                          ),
                        ResponseState.DATA => transactionList.isEmpty
                            ? ErrorPage(
                                message:
                                    "Your transactions will appear here when available",
                                showButton: false,
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: _physics,
                                itemCount: transactionList.length,
                                itemBuilder: (context, index) {
                                  TransactionModel transaction =
                                      transactionList.reversed.toList()[index];
                                  bool isDebit() =>
                                      (transaction.title
                                              .toLowerCase()
                                              .contains("credit") ==
                                          false) &&
                                      transaction.title
                                              .toLowerCase()
                                              .contains("funded") ==
                                          false;
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.sp),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            flex: 6,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: AppColors
                                                      .secondaryColor
                                                      .withOpacity(0.1),
                                                  radius: 10.sp,
                                                  child: TextOf(
                                                    isDebit() ? "D" : "C",
                                                    10,
                                                    4,
                                                    color: isDebit()
                                                        ? AppColors.red
                                                        : AppColors.green1,
                                                  ),
                                                ),
                                                XMargin(10.sp),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: 0.6.sw,
                                                        child: TextOf(
                                                          transaction.title,
                                                          14.sp,
                                                          6,
                                                          align: TextAlign.left,
                                                          maxLines: 1,
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                      ),
                                                      TextOf(
                                                        "${timeago.format(DateTime.parse(transaction.createdAt))[0].toUpperCase() + timeago.format(DateTime.parse(transaction.createdAt)).substring(1)}  •  ${transaction.description}",
                                                        12.sp,
                                                        4,
                                                        textOverflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        align: TextAlign.left,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        TextOf(
                                                            "${AppConst.COUNTRY_CURRENCY} ${AppMethods.moneyComma(transaction.transactionAmount)}",
                                                            12.5.sp,
                                                            6),
                                                        Container(
                                                          width: 70.sp,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      3.5.sp,
                                                                  vertical:
                                                                      2.5.sp),
                                                          decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .secondaryColor
                                                                  .withOpacity(
                                                                      0.1)),
                                                          child: Center(
                                                            child: TextOf(
                                                                transaction
                                                                    .status,
                                                                12.sp,
                                                                6,
                                                                color: switch (
                                                                    transaction
                                                                        .status) {
                                                                  "successful" =>
                                                                    AppColors
                                                                        .green1,
                                                                  "processing" =>
                                                                    AppColors
                                                                        .yellow,
                                                                  _ =>
                                                                    AppColors.red
                                                                }),
                                                          ),
                                                        )
                                                      ]),
                                                ]))
                                      ],
                                    ),
                                  );
                                })
                      }
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  clientFundOptionsBottomSheet(BuildContext context) {
    appBottomSheet(context,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextOf("Fund", 20, 7),
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
                  "Please confirm the balance you want to fund",
                  16.sp,
                  4,
                  color:
                      isDarkTheme(context) ? AppColors.grey1 : AppColors.grey3,
                ),
              ],
            ),
            YMargin(15.sp),
            ...List.generate(2, (index) => clientFundOptions(context, index))
          ],
        ));
  }

  Container clientFundOptions(BuildContext context, int index) {
    return Container(
        margin: EdgeInsets.only(bottom: 16.sp),
        width: double.infinity,
        decoration: BoxDecoration(
            //color: AppColors.brown1(context),
            border: Border.all(
                color: AppThemeNotifier.colorScheme(context).onSecondary),
            borderRadius: BorderRadius.circular(9.r)),
        child: Padding(
            padding: EdgeInsets.all(15.sp),
            child: InkWell(
              child: TextOf(
                  switch (index) { 0 => "Fund Wallet", _ => "Fund Escrow" },
                  16.sp,
                  5),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context,
                    index == 0
                        ? FundWalletScreen.fundWalletScreen
                        : ClientSelectEscrowToFund.clientSelectEscrowToFund);
              },
            )));
  }
}
