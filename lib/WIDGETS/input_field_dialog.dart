// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/transaction_providers/bank_list_provider.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

class InputFieldDialog extends StatefulWidget {
  InputFieldDialog(
      {required this.fieldController,
      this.hintText,
      required this.optionList,
      this.shouldExpand = true,
      this.hasTopContent,
      this.openDialog = true,
      this.titleIcon,
      this.searchBankController,
      this.topContent,
      this.beforeOpenDialog,
      this.onChanged,
      this.ref,
      this.suffixIcon,
      this.noListOptionText,
      super.key,
      this.fieldTitle});
  late TextEditingController fieldController;
  List<String> optionList;
  String? hintText, fieldTitle, noListOptionText;
  Widget? titleIcon, suffixIcon, topContent;
  WidgetRef? ref;
  TextEditingController? searchBankController;
  bool? shouldExpand;
  bool? hasTopContent;
  VoidCallback? beforeOpenDialog;
  Function? onChanged;
  bool openDialog;
  @override
  State<InputFieldDialog> createState() => _InputFieldDialogState();
}

class _InputFieldDialogState extends State<InputFieldDialog> {
  @override
  Widget build(BuildContext context) {
    return InputField(
        hintText: widget.hintText,
        fieldTitle: widget.fieldTitle,
        showCursor: false,
        titleIcon: widget.titleIcon,
        readOnly: true,
        inputType: TextInputType.none,
        suffixIcon: widget.suffixIcon ??
            IconOf(
              Icons.expand_more_outlined,
              color: AppThemeNotifier.colorScheme(context).primary,
            ),
        onTap: () {
          if (widget.openDialog == true) {
            if (widget.beforeOpenDialog != null) {
              widget.beforeOpenDialog!();
              Future.delayed(const Duration(milliseconds: 500), () {
                openDialog(
                  ref: widget.ref,
                  hasTopContent: widget.hasTopContent,
                  shouldExpand: widget.shouldExpand,
                  topContent: widget.topContent,
                  onChanged: widget.onChanged,
                  searchBankController: widget.searchBankController,
                  noListOptionText: widget.noListOptionText,
                );
              });

              // widget.beforeOpenDialog!.then((value) {
              //   widget.openDialog == true
              //   ?
              //   : () {};
              // });
            } else {
              openDialog(
                  ref: widget.ref,
                  hasTopContent: widget.hasTopContent,
                  shouldExpand: widget.shouldExpand,
                  onChanged: widget.onChanged,
                  topContent: widget.topContent,
                  searchBankController: widget.searchBankController,
                  noListOptionText: widget.noListOptionText);
            }
          }
          // widget.beforeOpenDialog != null ? widget.beforeOpenDialog!() : () {};
          // widget.openDialog == true
          //     ?
          //     : () {};
        },
        fieldController: widget.fieldController);
  }

  void openDialog(
      {bool? hasTopContent,
      String? noListOptionText,
      bool? shouldExpand,
      WidgetRef? ref,
      Function? onChanged,
      Widget? topContent,
      TextEditingController? searchBankController}) {
    // WidgetsBinding.instance.addPersistentFrameCallback((_) {
    //   if (!mounted) return;
    //   setState(() {});
    // });
    showDialog(
        context: context,
        builder: (context) => Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 10.sp),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            backgroundColor:
                AppThemeNotifier.themeColor(context).scaffoldBackgroundColor,
            child: StatefulBuilder(builder: (context, changeState) {
              // WidgetsBinding.instance.addPersistentFrameCallback((_) {
              //   if (mounted) {
              //     changeState(() {});
              //   }
              // });
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    hasTopContent == true
                        ? (topContent ??
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.sp)
                                  .copyWith(top: 10),
                              child: InputField(
                                hintText: "Search bank...",
                                fieldController: searchBankController,
                                fillColor: AppColors.brown1(context),
                                radius: 10.r,
                                hintColor: AppThemeNotifier.colorScheme(context)
                                            .primary ==
                                        AppColors.white
                                    ? AppColors.grey1
                                    : AppColors.grey3,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10.sp),
                                onChanged: (value) {
                                  changeState(() {
                                    searchBankController!.text = value!;
                                  });
                                  ref!
                                      .watch(bankListProvider.notifier)
                                      .searchBanks(searchQuery: value);
                                },
                                enabledBorderColor: AppColors.brown1(context),
                                focusedBorderColor: AppColors.brown1(context),
                                prefixIcon: IconOf(
                                  Icons.search,
                                  size: 23.sp,
                                  color: AppThemeNotifier.colorScheme(context)
                                              .primary ==
                                          AppColors.white
                                      ? AppColors.grey1
                                      : AppColors.grey3,
                                ),
                              ),
                            ))
                        : const SizedBox.shrink(),
                    widget.optionList.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppThemeNotifier.themeColor(context)
                                                .brightness ==
                                            Brightness.dark
                                        ? ImageOf.noSearchLight
                                        : ImageOf.noSearchDark,
                                    height: 150.sp,
                                  ),
                                  YMargin(20.sp),
                                  TextOf(
                                      noListOptionText ??
                                          "--No option available--",
                                      20.sp,
                                      7)
                                ],
                              ),
                            ),
                          )
                        : shouldExpand == true
                            ? Expanded(child: optionList(onChanged))
                            : optionList(onChanged),
                  ],
                ),
              );
            })));
  }

  ListView optionList(Function? onChanged) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      itemCount: widget.optionList.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        // String element = widget.optionList[index];
        return InkWell(
          onTap: () {
            setState(() {
              widget.fieldController.text = widget.optionList[index];
            });
            if (onChanged != null) {
              onChanged();
            }
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TextOf(
                    widget.optionList[index],
                    16.sp,
                    5,
                    color: AppThemeNotifier.colorScheme(context).primary ==
                            AppColors.black
                        ? AppColors.grey3
                        : AppColors.grey1,
                    align: TextAlign.left,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
