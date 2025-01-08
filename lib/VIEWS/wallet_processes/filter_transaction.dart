// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/transaction_models/transaction_model.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/input_field_dialog.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:intl/intl.dart';
import "package:project_bist/PROVIDERS/transaction_providers/transaction_providers/transaction_providers.dart";

class FilterTransaction extends ConsumerStatefulWidget {
  static const String filterTransaction = "filterTransaction";
  const FilterTransaction({super.key});
  @override
  ConsumerState<FilterTransaction> createState() => _FilterTransactionState();
}

class _FilterTransactionState extends ConsumerState<FilterTransaction> {
  int selectedPerirod = 0;
  late ScrollController scrollController;
  late TextEditingController startDateController,
      endDateController,
      amountController,
      transactionStatusController;
  @override
  void initState() {
    setState(() {
      startDateController = TextEditingController();
      endDateController = TextEditingController();
      amountController = TextEditingController();
      transactionStatusController = TextEditingController();
      scrollController = ScrollController();
    });
    super.initState();
  }

  String startDate = "", endDate = "";
  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    amountController.dispose();
    scrollController.dispose();
    transactionStatusController.dispose();
    super.dispose();
  }

  DateTime selectedDate = DateTime.now();
  String text = "text";
  @override
  Widget build(BuildContext context) {
    // bool hasRun = false;
    // ResponseStatus responseStatus = ref.watch(transactionProvider);
    // if (ref.watch(transactionProvider).responseState != ResponseState.DATA &&
    //     hasRun == false) {
    //   setState(() {
    //     hasRun = true;
    //   });
    //   ref.read(transactionProvider.notifier).getRequest(
    //       context: context,
    //       url: Endpoints.FILTER_TRANSACTIONS,
    //       showLoading: false);
    // }
    // List<dynamic>? transactions = responseStatus.data?["transactions"];
    // getIt<AppModel>().transactionList =
    //     transactions?.map((e) => TransactionModel.fromJson(json: e)).toList();

    // TransactionList transactionList = getIt<AppModel>().transactionList ?? [];
    return Scaffold(
      body: SafeArea(
          child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox.expand(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: appPadding(),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: IconOf(Icons.close, size: 23.sp)),
                    ],
                  ),
                  YMargin(20.sp),
                  Row(
                    children: [TextOf("Filter Transactions", 25.sp, 7)],
                  ),
                  YMargin(20.sp),
                  Row(
                    children: [
                      TextOf(
                        "Period",
                        16.sp,
                        5,
                        fontFamily: Fonts.inter,
                      )
                    ],
                  ),
                  YMargin(10.sp),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          7,
                          (index) => Padding(
                                padding: EdgeInsets.only(right: 5.sp),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                            side: BorderSide(
                                                color: selectedPerirod == index
                                                    ? AppColors.primaryColor
                                                    : AppThemeNotifier
                                                            .themeColor(context)
                                                        .scaffoldBackgroundColor
                                                        .withOpacity(0.5))),
                                        backgroundColor:
                                            selectedPerirod == index
                                                ? AppColors.primaryColor
                                                    .withOpacity(0.1)
                                                : AppThemeNotifier.themeColor(
                                                        context)
                                                    .scaffoldBackgroundColor
                                                    .withOpacity(0.5)),
                                    onPressed: () {
                                      // print(DateTime.now().weekday);
                                      setState(() {
                                        selectedPerirod = index;
                                      });
                                      if (index == 0) {
                                        setState(() {
                                          startDateController.clear();
                                          endDateController.clear();
                                          startDate = "";
                                          endDate = "";
                                        });
                                      } else if (index == 1) {
                                        startDateController.text =
                                            DateFormat.yMMMMd()
                                                .format(DateTime.now());
                                        startDate = DateFormat('yyyy/MM/dd')
                                            .format(DateTime.now());

                                        endDateController.text =
                                            DateFormat.yMMMMd()
                                                .format(DateTime.now());
                                        endDate = DateFormat('yyyy/MM/dd')
                                            .format(DateTime.now());
                                      } else if (index == 2) {
                                        startDateController.text =
                                            DateFormat.yMMMMd().format(
                                                DateTime.now().subtract(
                                                    Duration(
                                                        days: ((DateTime.now()
                                                                .weekday) +
                                                            7))));
                                        startDate = DateFormat('yyyy/MM/dd')
                                            .format(DateTime.now().subtract(
                                                Duration(
                                                    days: ((DateTime.now()
                                                            .weekday) +
                                                        7))));

                                        endDateController.text =
                                            DateFormat.yMMMMd().format(
                                                DateTime.now().subtract(
                                                    Duration(
                                                        days: ((DateTime.now()
                                                                .weekday) +
                                                            1))));
                                        endDate = DateFormat('yyyy/MM/dd')
                                            .format(DateTime.now().subtract(
                                                Duration(
                                                    days: ((DateTime.now()
                                                            .weekday) +
                                                        1))));
                                      } else if (index == 3) {
                                        startDateController.text =
                                            DateFormat.yMMMMd().format(
                                                DateTime.now().subtract(
                                                    Duration(
                                                        days: ((DateTime.now()
                                                                .weekday) +
                                                            4))));
                                        startDate = DateFormat('yyyy/MM/dd')
                                            .format(DateTime.now().subtract(
                                                Duration(
                                                    days: ((DateTime.now()
                                                            .weekday) +
                                                        4))));

                                        endDateController.text =
                                            DateFormat.yMMMMd()
                                                .format(DateTime.now());
                                        endDate = DateFormat('yyyy/MM/dd')
                                            .format(DateTime.now());
                                      } else if (index == 4) {
                                        startDateController.text =
                                            DateFormat.yMMMMd().format(DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month - 1,
                                                1));
                                        startDate = DateFormat('yyyy/MM/dd')
                                            .format(DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month - 1,
                                                1));

                                        endDateController.text =
                                            DateFormat.yMMMMd().format(DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                0));
                                        endDate = DateFormat('yyyy/MM/dd')
                                            .format(DateTime.now().subtract(
                                                Duration(
                                                    days: ((DateTime.now()
                                                            .weekday) +
                                                        1))));
                                      } else if (index == 5) {
                                        startDateController.text =
                                            DateFormat.yMMMMd().format(DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                1));
                                        startDate = DateFormat('yyyy/MM/dd')
                                            .format(DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                1));

                                        endDateController.text =
                                            DateFormat.yMMMMd().format(DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month + 1,
                                                0));
                                        endDate = DateFormat('yyyy/MM/dd')
                                            .format(DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month + 1,
                                                0));
                                      } else if (index == 6) {
                                        startDateController.text =
                                            DateFormat.yMMMMd().format(DateTime(
                                                DateTime.now().year - 1, 1, 1));
                                        startDate = DateFormat('yyyy/MM/dd')
                                            .format(DateTime(
                                                DateTime.now().year - 1, 1, 1));

                                        endDateController.text =
                                            DateFormat.yMMMMd().format(DateTime(
                                                DateTime.now().year - 1,
                                                13,
                                                0));
                                        endDate = DateFormat('yyyy/MM/dd')
                                            .format(DateTime(
                                                DateTime.now().year - 1,
                                                13,
                                                0));
                                      }
                                    },
                                    child: TextOf(
                                        index == 0
                                            ? "Custom period"
                                            : index == 1
                                                ? "Today"
                                                : index == 2
                                                    ? "Last week"
                                                    : index == 3
                                                        ? "This week"
                                                        : index == 4
                                                            ? "Last month"
                                                            : index == 5
                                                                ? "This month"
                                                                : "Last year",
                                        15.sp,
                                        5)),
                              )),
                    ),
                  ),
                  YMargin(20.sp),
                  InputField(
                    fieldController: startDateController,
                    labelText: "Start Date",
                    readOnly: true,
                    showCursor: false,
                    onTap: () {
                      _selectDate(context, dateTextValue: (value) {
                        setState(() {
                          startDateController.text = value;
                        });
                      }, rawTextValue: (value) {
                        setState(() {
                          startDate = value;
                        });
                      });
                    },
                    suffixIcon: const IconOf(Icons.date_range_rounded),
                  ),
                  YMargin(16.sp),
                  InputField(
                    fieldController: endDateController,
                    labelText: "End Date",
                    readOnly: true,
                    showCursor: false,
                    onTap: () {
                      _selectDate(context, dateTextValue: (value) {
                        setState(() {
                          endDateController.text = value;
                        });
                      }, rawTextValue: (value) {
                        setState(() {
                          endDate = value;
                        });
                      });
                    },
                    suffixIcon: const IconOf(Icons.date_range_rounded),
                  ),
                  YMargin(25.sp),
                  InputField(
                    fieldController: amountController,
                    hintText: "Transaction amount",
                    fieldTitle: "Transaction amount",
                    inputType: TextInputType.number,
                    onTap: () {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent * 0.65,
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                      );
                    },
                    suffixIcon: const IconOf(Icons.payments_outlined),
                  ),
                  YMargin(25.sp),
                  InputFieldDialog(
                      fieldController: transactionStatusController,
                      fieldTitle: "Transaction status",
                      hintText: "Transaction status",
                      shouldExpand: false,
                      beforeOpenDialog: handleAnimationFirst(),
                      optionList: const ["Successful", "Failed", "Processing"]),
                  YMargin(0.5.sh),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.sp)
                .add(EdgeInsets.symmetric(horizontal: 20.sp)),
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Button(
                      text: 'Clear all',
                      buttonType: ButtonType.whiteBg,
                      onPressed: () {
                        setState(() {
                          endDate = "";
                        });
                        setState(() {
                          startDate = "";
                        });
                        for (var element in [
                          startDateController,
                          endDateController,
                          amountController,
                          transactionStatusController
                        ]) {
                          element.clear();
                        }
                      },
                    )),
                const Expanded(flex: 1, child: SizedBox.shrink()),
                Expanded(
                    flex: 5,
                    child: Button(
                      text: "Filter",
                      buttonType: ButtonType.blueBg,
                      onPressed: () {
                        //  print("end date: $endDate\nstart date: $startDate");
                        TransactionsProvider.filterTransactions(context,
                            fromDate: startDate,
                            toDate: endDate,
                            filterData: FilterData(
                                startDate: startDateController.text,
                                endDate: endDateController.text,
                                status: transactionStatusController.text
                                    .toLowerCase(),
                                amount: amountController.text),
                            status:
                                transactionStatusController.text.toLowerCase(),
                            transactionAmount: amountController.text);
                      },
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }

  Future<void> _selectDate(BuildContext context,
      {required Function(String) dateTextValue,
      required Function(String) rawTextValue}) async {
    DateTime? picked;
    await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(2015),
            lastDate: DateTime(2025))
        .then((value) => setState(() {
              picked = value;
            }));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked!;
        rawTextValue(DateFormat('yyyy/MM/dd').format(selectedDate));
        dateTextValue(DateFormat.yMMMMd().format(selectedDate).toString());
      });
    }
  }

  handleAnimationFirst() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }
}

class TransactionsFilteredScreen extends StatefulWidget {
  TransactionsFilteredScreen(
      {required this.transactionList, required this.filterData, super.key});
  TransactionList? transactionList;
  FilterData? filterData;
  @override
  State<TransactionsFilteredScreen> createState() =>
      _TransactionsFilteredScreenState();
}

class _TransactionsFilteredScreenState
    extends State<TransactionsFilteredScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextOf("Transactions", 15.sp, 5),
          backgroundColor:
              AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const IconOf(Icons.arrow_back_ios_rounded)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            AppDivider(),
            // YMargin(15.sp),

            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.transactionList!.length,
                    itemBuilder: (context, index) {
                      TransactionModel transaction =
                          widget.transactionList!.reversed.toList()[index];
                      bool isDebit() =>
                          (transaction.title.toLowerCase().contains("credit") ==
                              false) &&
                          transaction.title.toLowerCase().contains("funded") ==
                              false;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.sp, horizontal: 15.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 6,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.secondaryColor
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
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 0.6.sw,
                                          child: TextOf(
                                            transaction.title,
                                            14.sp,
                                            6,
                                            align: TextAlign.left,
                                            maxLines: 1,
                                            textOverflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        TextOf(
                                            "${timeago.format(DateTime.parse(transaction.createdAt))[0].toUpperCase() + timeago.format(DateTime.parse(transaction.createdAt)).substring(1)}  •  ${transaction.description}",
                                            12.sp,
                                            4,
                                            align: TextAlign.left,
                                            textOverflow: TextOverflow.ellipsis)
                                      ],
                                    )
                                  ],
                                )),
                            Expanded(
                                flex: 2,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            TextOf(
                                                "${AppConst.COUNTRY_CURRENCY} ${AppMethods.moneyComma(transaction.transactionAmount)}",
                                                12.5.sp,
                                                6),
                                            Container(
                                              width: 70.sp,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3.5.sp,
                                                  vertical: 2.5.sp),
                                              decoration: BoxDecoration(
                                                  color: AppColors
                                                      .secondaryColor
                                                      .withOpacity(0.1)),
                                              child: Center(
                                                child: TextOf(
                                                    transaction.status,
                                                    12.sp,
                                                    6,
                                                    color: switch (
                                                        transaction.status) {
                                                      "successful" =>
                                                        AppColors.green1,
                                                      "processing" =>
                                                        AppColors.yellow,
                                                      _ => AppColors.red
                                                    }),
                                              ),
                                            )
                                          ]),
                                    ]))
                          ],
                        ),
                      );
                    }))
          ],
        ));
  }
}

class FilterData {
  final String startDate, endDate, amount, status;
  FilterData(
      {required this.startDate,
      required this.endDate,
      required this.status,
      required this.amount});
}

//enum TransactionStatus {}