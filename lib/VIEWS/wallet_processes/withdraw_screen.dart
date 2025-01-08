import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/core.dart';
import 'package:project_bist/main.dart';

class WithdrawScreen extends ConsumerStatefulWidget {
  const WithdrawScreen({super.key});

  static const String withdrawScreen = "withdrawScreen";

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  late TextEditingController selectBankController,
      accountNumberController,
      amountToTransferController,
      remarkController,
      searchBankController;

  @override
  void dispose() {
    selectBankController.dispose();
    accountNumberController.dispose();
    amountToTransferController.dispose();
    remarkController.dispose();
    searchBankController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      selectBankController = TextEditingController();
      accountNumberController = TextEditingController();
      amountToTransferController = TextEditingController();
      searchBankController = TextEditingController();
      remarkController = TextEditingController();
    });

    super.initState();
  }

  String bankCode = "";
  @override
  Widget build(BuildContext context) {
    AvailabilityStatus responseStatusOfVerifyAccountNumber =
        ref.watch(verifyAccountNumberProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
    return Scaffold(
      appBar: customAppBar(context,
          title: "Withdraw", hasIcon: true, hasElevation: true),
      body: Padding(
        padding: appPadding().copyWith(bottom: 20.sp),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox.expand(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    YMargin(24.sp),
                    InputFieldDialog(
                        fieldController: selectBankController,
                        hintText: "Select Bank",
                        ref: ref,
                        searchBankController: searchBankController,
                        noListOptionText: "No result available",
                        fieldTitle: "Bank name",
                        onChanged: () {
                          accountNumberController.clear();
                          ref
                              .read(verifyAccountNumberProvider.notifier)
                              .switchState(ResponseAvailabilityState.NEUTRAL);
                        },
                        openDialog:
                            ref.watch(bankListProvider).bankList.isNotEmpty,
                        shouldExpand:
                            ref.watch(bankListProvider).bankList.isNotEmpty,
                        hasTopContent: true,
                        beforeOpenDialog: performSomethingsFirst(),
                        optionList:
                            ref.watch(bankListProvider).searchBankList.map((e) {
                          setState(() {
                            bankCode = e.code;
                          });
                          return e.name;
                        }).toList()),
                    YMargin(16.sp),
                    InputField(
                        fieldTitle: "Account number",
                        inputType: TextInputType.number,
                        hintText: "Account number",
                        onChanged: (value) {
                          if (accountNumberController.text.length < 10) {
                            ref
                                .read(verifyAccountNumberProvider.notifier)
                                .switchState(ResponseAvailabilityState.NEUTRAL);
                          }
                          if (accountNumberController.text.length == 10 &&
                              selectBankController.text.isNotEmpty) {
                            ref
                                .watch(verifyAccountNumberProvider.notifier)
                                .request(
                                  context,
                                  ref,
                                  endpoint: Endpoints.VERIFY_ACCOUNT_NUMBER(
                                      accountNumber:
                                          accountNumberController.text,
                                      bankCode: bankCode),
                                );
                          }
                        },
                        fieldController: accountNumberController),
                    YMargin(8.sp),
                    switch (
                        responseStatusOfVerifyAccountNumber.responseState!) {
                      ResponseAvailabilityState.LOADING => Row(
                          children: [
                            const CupertinoWidget(
                                child: CupertinoActivityIndicator()),
                            XMargin(10.sp),
                            TextOf(
                              "Verifying account details...",
                              18.sp,
                              5,
                              align: TextAlign.left,
                            )
                          ],
                        ),
                      ResponseAvailabilityState.DATA => Row(
                          children: [
                            TextOf(
                              responseStatusOfVerifyAccountNumber
                                  .data["account_name"],
                              18.sp,
                              5,
                              align: TextAlign.left,
                              color: AppColors.green,
                            ),
                          ],
                        ),
                      ResponseAvailabilityState.ERROR => Row(
                          children: [
                            TextOf(
                              AppMethods.toTitleCase(
                                  responseStatusOfVerifyAccountNumber.message!),
                              18.sp,
                              5,
                              align: TextAlign.left,
                              color: AppColors.red,
                            ),
                          ],
                        ),
                      ResponseAvailabilityState.NEUTRAL =>
                        const SizedBox.shrink()
                    },
                    YMargin(16.sp),
                    (responseStatusOfVerifyAccountNumber.responseState ==
                            ResponseAvailabilityState.DATA)
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InputField(
                                  fieldTitle: "Amount",
                                  inputType: TextInputType.number,
                                  prefixIcon: TextOf(
                                      AppConst.COUNTRY_CURRENCY,
                                      16,
                                      amountToTransferController.text.isEmpty
                                          ? 4
                                          : 5),
                                  fieldController: amountToTransferController),
                              YMargin(16.sp),
                              InputField(
                                  fieldTitle: "Remark",
                                  maxLines: 3,
                                  hintText: "Describe this transaction",
                                  fieldController: remarkController),
                              YMargin(20.sp),
                            ],
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            ),
            Button(
              text: "Withdraw",
              buttonType: selectBankController.text.isNotEmpty &&
                      accountNumberController.text.length == 10 &&
                      amountToTransferController.text.isNotEmpty
                  ? ButtonType.blueBg
                  : ButtonType.disabled,
              onPressed: () {
                TransactionsProvider.debitWallet(context,
                    accountNumber: accountNumberController.text,
                    ref: ref,
                    accountName: responseStatusOfVerifyAccountNumber
                        .data["account_name"],
                    bankCode: bankCode,
                    remark: remarkController.text,
                    amount: amountToTransferController.text);
              },
            )
          ],
        ),
      ),
    );
  }

  performSomethingsFirst() {
    Future.delayed(const Duration(seconds: 1), () {
      if (ref.watch(bankListProvider).bankList.isEmpty) {
        ref.watch(bankListProvider.notifier).getBanksList(context);
      }

      if (ref.watch(bankListProvider).searchBankList.isEmpty) {
        ref.watch(bankListProvider).searchBankList =
            ref.watch(bankListProvider).bankList;
      }
    });
  }
}
