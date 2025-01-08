import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/bank_model/bank_model.dart';
import 'package:project_bist/MODELS/transaction_models/transaction_model.dart';
import 'package:project_bist/PROVIDERS/_base_provider/base_provider.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/auth_provider/auth_provider.dart';
import 'package:project_bist/SERVICES/api_service.dart';
import 'package:flutter/material.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/VIEWS/wallet_processes/filter_transaction.dart';
import 'package:project_bist/VIEWS/wallet_processes/wallet_home.dart';
import 'package:project_bist/VIEWS/web_view_page/web_view_page.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';
import 'package:project_bist/PROVIDERS/profile_provider/profile_provider.dart';

final transactionProvider =
    StateNotifierProvider<BaseProvider<TransactionModel>, ResponseStatus>(
        (ref) => BaseProvider<TransactionModel>());
final verifyAccountNumberProvider =
    StateNotifierProvider<MultipleBaseProvider, AvailabilityStatus>(
        (ref) => MultipleBaseProvider());

// final emailAvailabilityProvider = StateNotifierProvider<MultipleBaseProvider,
//     >((_) => MultipleBaseProvider());

class TransactionsProvider {
  static final ApiService _apiService = ApiService();
  static submitKYC(BuildContext context, WidgetRef ref,
      {required String virtualNIN}) {
    if (virtualNIN.isEmpty) {
      Alerts.openStatusDialog(context,
          title: "Missing field",
          isSuccess: false,
          description: "Your Virtual NIN is required to continue");
    }
    else {
      _apiService.apiRequest(context,
          url: Endpoints.SUBMIT_KYC,
          method: Methods.POST,
          loadingMessage:
              "Verification Processing...\nPlease wait while we verify your details.",
          formData: {"identityNumber": virtualNIN}).then((value) {
        if (value.status == true) {
          ref.invalidate(transactionProvider);
          ref.invalidate(escrowsProvider);
          ref.invalidate(profileProvider);
          Alerts.openStatusDialog(context,
              title: "Verification Successful",
              description:
                  "Your wallet has been created. You can now proceed to wallet.",
              isDismissible: false, actionTextAction: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(
                context, WalletHomePage.walletHomePage);
          }, actionText: "Proceed to your wallet", hasCancel: false);
        }
      });
    }
  }

  static Future fundallet(BuildContext context, WidgetRef ref,
      {required String amount}) async {
    await _apiService
        .apiRequest(context,
            url: Endpoints.FUND_WALLET(amount),
            loadingMessage: "Fueling your wallet...\nAlmost there!",
            formData: {"amount": amount, "remark": "Wallet funding"},
            method: Methods.PUT)
        .then((value) {ref.invalidate(transactionProvider);
      if (value.status == true) {
        Navigator.pushReplacementNamed(context, WebViewPage.webViewPage,
            arguments: WebViewPageArgument(
                loadingMessage:
                    "Processing payment details...\nPlease wait a moment!",
                sideDisplayUrl: value.data["url"],
                whenSomeUrlConditionsMet: (url) {

                  var request = http.get(Uri.parse(url!));
                  dynamic data;
                  request.then((value) {
                    data = jsonDecode(value.body);
                    print(data);
                    if (data["success"] == true) {
                      ref.invalidate(transactionProvider);
                      Alerts.openStatusDialog(context,
                          title: "Transaction Successful",
                          description:
                              "You have successfully funded your wallet with ${AppMethods.moneyComma(amount)}");
                      Future.delayed(const Duration(seconds: 2), () {
                        List.generate(3, (_) => Navigator.pop(context));
                      });
                    } else if (data["success"] == false) {
                      Alerts.openStatusDialog(context,
                          isSuccess: false,
                          description: data["message"],
                          isDismissible: false);
                      Future.delayed(const Duration(seconds: 2), () {
                        List.generate(3, (index) => Navigator.pop(context));
                      });
                    }
                  });
                },
                onTryExit: (){
              },));
      }
    });
  }

  static Future<BankList> getBanks(BuildContext context) async {
    BankList? bankList;
    await _apiService
        .apiRequest(context,
            url: Endpoints.GET_BANKS,
            method: Methods.GET,
            loadingMessage: "Fetching available banks...")
        .then((value) {
      if (value.status == true) {
        List<dynamic> rawBanks = value.data;
        bankList = rawBanks.map((e) => BankModel.fromJson(e)).toList();
      }
    });

    return bankList!;
  }
  // static String verifyAccountNumber(BuildContext context,
  //     {required String accountNumber, required String bankCode}) {
  //   String userAccountNumber = "";
  //   _apiService
  //       .apiRequest(context,
  //           url: Endpoints.VERIFY_ACCOUNT_NUMBER(
  //               accountNumber: accountNumber, bankCode: bankCode),
  //           method: Methods.GET,
  //           loadingMessage: "Verifying account details...")
  //       .then((value) {
  //     if (value.status == true) {}
  //   });

  //   return userAccountNumber;
  // }

  static filterTransactions(BuildContext context,
      {String? status,
      String? transactionAmount,
      String? fromDate,
      String? toDate,
      FilterData? filterData}) {
    TransactionList? transactionList;
    Map<String, dynamic> queryParameters = {};
    if ((fromDate ?? "").isNotEmpty) {
      queryParameters.addEntries({"fromDate": AppMethods.convertStringToDateFormat(fromDate??"") }.entries);
    }
    if ((toDate ?? "").isNotEmpty) {
      queryParameters.addEntries({"toDate": DateTime.parse(AppMethods.convertStringToDateFormat(toDate??"")).add(const Duration(days: 1)).toString()}.entries);
    }
    if ((status ?? "").isNotEmpty) {
      queryParameters.addEntries({"status": status}.entries);
    }
    if ((transactionAmount ?? "").isNotEmpty) {
      queryParameters
          .addEntries({"transactionAmount": transactionAmount}.entries);
    }

    _apiService
        .apiRequest(context,
            url: Endpoints.FILTER_TRANSACTIONS,
            method: Methods.GET,
            loadingMessage: "Filtering transactions..",
            queryParameters: queryParameters)
        .then((value) {
      List<dynamic> data = value.data;
      transactionList =
          data.map((e) => TransactionModel.fromJson(json: e)).toList();

      if (value.status == true) {
        if (transactionList!.isEmpty) {
          Alerts.openStatusDialog(context,
              description: "No transactions found for this inputs",
              isSuccess: false);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TransactionsFilteredScreen(
                      filterData: filterData,
                      transactionList: transactionList!.reversed.toList())));
        }
      }
    });
  }

  static Future debitWallet(BuildContext context,
      {required String accountNumber,
      required String accountName,
      required String bankCode,
      required String amount,
      required String remark,
      required WidgetRef ref}) async {
    await _apiService
        .apiRequest(context,
            url: Endpoints.DEBIT_WALLET,
            loadingMessage: "Processing your withdrawal\nPlease wait...",
            formData: {
              "accountNumber": accountNumber,
              "accountName": accountName,
              "bankCode": bankCode,
              "amount": amount,
              "remark": remark
            },
            method: Methods.PUT)
        .then((value) {
      if (value.status == true) {
        //  Navigator.pop(context);
        ref.invalidate(transactionProvider);

        Alerts.openStatusDialog(context,
            title: "Withdrawal successful",
            isDismissible: false,
            description:
                "Successfully transferred NGN ${AppMethods.moneyComma(amount)} to your bank account");
        Future.delayed(const Duration(seconds: 1), () {
          List.generate(2, (index) => Navigator.pop(context));
        });
        // Navigator.pushNamed(context, WebViewPage.webViewPage,
        //     arguments: WebViewPageArgument(
        //         loadingMessage: "Processing your withdrawal\nPlease wait...",
        //         sideDisplayUrl: value.data["url"],
        //         whenSomeUrlConditionsMet: (url) {
        //           print("WITHDRAWAL SEEN SEEN");

        //           var request = http.get(Uri.parse(url!));
        //           dynamic data;
        //           request.then((value) {
        //             data = jsonDecode(value.body);
        //             print(data);
        //             if (data["success"] == true) {
        //               ref.invalidate(transactionProvider);
        //               Alerts.openStatusDialog(context,
        //                   title: "Withdrawal Successful",
        //                   description:
        //                       "You will receive ${AppMethods.moneyComma(amount)} in your bank account");
        //               Future.delayed(const Duration(seconds: 2), () {
        //                 List.generate(3, (_) => Navigator.pop(context));
        //               });
        //             } else if (data["success"] == false) {
        //               Alerts.openStatusDialog(context,
        //                   isSuccess: false,
        //                   description: data["message"],
        //                   isDismissible: false);
        //               Future.delayed(const Duration(seconds: 2), () {
        //                 List.generate(3, (index) => Navigator.pop(context));
        //               });
        //             }
        //           });
        //         }));
        // Navigator.pushReplacementNamed(
        //     context, RequestStatusPage.requestStatusPage,
        //     arguments: RequestStatusPageArgument(
        //         title: "Withdrawal sent",
        //         buttonText: "Return to Wallet",
        //         onTapButton: () {
        //           Navigator.pop(context);
        //         },
        //         customSubtitle: RichText(
        //             textAlign: TextAlign.center,
        //             text: TextSpan(
        //                 text: "You will receive ",
        //                 style: TextStyle(
        //                     fontSize: 16.sp,
        //                     fontWeight: FontWeight.w400,
        //                     color:
        //                         AppThemeNotifier.colorScheme(context).primary),
        //                 children: [
        //                   TextSpan(
        //                       style:
        //                           const TextStyle(fontWeight: FontWeight.w500),
        //                       text: "${AppConst.COUNTRY_CURRENCY}$amount",
        //                       children: const [
        //                         TextSpan(
        //                             style:
        //                                 TextStyle(fontWeight: FontWeight.w400),
        //                             text: "in your bank account soon.")
        //                       ])
        //                 ])),
        //         status: RequestStatus.success));
      }
    });
  }
}
