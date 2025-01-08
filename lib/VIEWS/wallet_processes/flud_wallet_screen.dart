import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/transaction_providers/transaction_providers/transaction_providers.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

class FundWalletScreen extends ConsumerStatefulWidget {
  const FundWalletScreen({super.key});

  static const String fundWalletScreen = "fundWalletScreen";

  @override
  ConsumerState<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends ConsumerState<FundWalletScreen> {
  late TextEditingController amountToTransferController;

  @override
  void dispose() {
    amountToTransferController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      amountToTransferController = TextEditingController();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return Scaffold(
      appBar: customAppBar(context,
          title: "Fund Wallet", hasIcon: true, hasElevation: true),
      body: Padding(
        padding: appPadding().copyWith(bottom: 20.sp),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox.expand(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: TextOf(
                          "Enter the amount to fund your wallet.",
                          16.sp,
                          5,
                          align: TextAlign.left,
                        ))
                      ],
                    ),
                    YMargin(24.sp),
                    InputField(
                        fieldTitle: "Amount",
                        inputType: TextInputType.number,
                        prefixIcon: TextOf(AppConst.COUNTRY_CURRENCY, 16,
                            amountToTransferController.text.isEmpty ? 4 : 5),
                        fieldController: amountToTransferController),
                  ],
                ),
              ),
            ),
            Button(
              text: "Continue",
              buttonType: amountToTransferController.text.isNotEmpty
                  ? ButtonType.blueBg
                  : ButtonType.disabled,
              onPressed: () {
                TransactionsProvider.fundallet(context, ref,
                    amount: amountToTransferController.text);
                // Navigator.pushNamed(
                //     context, RequestStatusPage.requestStatusPage,
                //     arguments: RequestStatusPageArgument(
                //         title: "Wallet Funded",
                //         buttonText: "Return to Wallet",
                //         onTapButton: () {
                //           Navigator.pop(context);
                //           Navigator.pop(context);
                //         },
                //         customSubtitle: RichText(
                //             textAlign: TextAlign.center,
                //             text: TextSpan(
                //                 text: "Your wallet has been funded with ",
                //                 style: TextStyle(
                //                     fontSize: 16.sp,
                //                     fontWeight: FontWeight.w400,
                //                     color: AppThemeNotifier.colorScheme(context)
                //                         .primary),
                //                 children: [
                //                   TextSpan(
                //                     style: const TextStyle(
                //                         fontWeight: FontWeight.w500),
                //                     text:
                //                         "${AppConst.COUNTRY_CURRENCY}${amountToTransferController.text} ",
                //                   )
                //                 ])),
                //         status: RequestStatus.success));
              },
            )
          ],
        ),
      ),
    );
  }
}
