// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/widgets/texts.dart';

// ignore: must_be_immutable
class InputField extends StatefulWidget {
  InputField({
    this.hintText,
    this.onChanged,
    this.isPassword = false,
    this.showVisibility = true,
    this.showCursor = true,
    this.fillColor,
    this.fieldController,
    this.hintColor,
    this.fieldTitle,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines,
    this.maxLength,
    this.radius,
    this.extra,
    this.isOptional = false,
    this.fieldGroupColors,
    this.enabledBorderColor,
    this.lineBreakLimiter,
    this.showWordCount = false,
    this.readOnly = false,
    this.contentPadding,
    this.titleIcon,
    this.suffixIconConstraints,
    this.labelText,
    this.autofocus = false,
    this.validator,
    this.boroderRadius,
    this.focusedBorderColor,
    this.inputType = TextInputType.text,
    super.key,
  });
  Color? fillColor,
      hintColor,
      enabledBorderColor,
      focusedBorderColor,
      fieldGroupColors;
  String? hintText, fieldTitle, labelText;
  double? radius, extra;
  TextInputType inputType;
  EdgeInsets? contentPadding;
  BorderRadius? boroderRadius;
  int? maxLines, maxLength, lineBreakLimiter;
  TextEditingController? fieldController;
  BoxConstraints? suffixIconConstraints;
  VoidCallback? onTap;
  Widget? suffixIcon;
  String? Function(String?)? validator;
  Widget? prefixIcon, titleIcon;
  bool isPassword,
      showVisibility,
      showCursor,
      showWordCount,
      autofocus,
      isOptional,
      readOnly;

  void Function(String?)? onChanged;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
    return Column(
      children: [
        widget.fieldTitle == null
            ? const SizedBox.shrink()
            : Column(
                children: [
                  Row(
                    children: [
                      TextOf(
                        widget.fieldTitle!,
                        16.sp,
                        5,
                        align: TextAlign.left,
                        color: widget.fieldGroupColors,
                      ),
                      widget.isOptional == true
                          ? TextOf(
                              "  (Optional)",
                              16,
                              4,
                              align: TextAlign.left,
                              color: AppThemeNotifier.colorScheme(context)
                                  .onSecondary,
                            )
                          : const SizedBox.shrink(),
                      widget.titleIcon != null
                          ? Padding(
                              padding: EdgeInsets.only(left: 5.sp),
                              child: widget.titleIcon!)
                          : const SizedBox.shrink()
                    ],
                  ),
                  YMargin(8.sp),
                ],
              ),
        SizedBox(
          child: Center(
            child: TextFormField(
              onChanged: widget.onChanged,
              controller: widget.fieldController,
              inputFormatters: widget.lineBreakLimiter != null
                  ? [LineBreakLimiter(widget.lineBreakLimiter!)]
                  : null,
              autofocus: widget.autofocus,
              readOnly: widget.readOnly,
              cursorColor: AppColors.primaryColor,
              onTap: () {
                if (widget.onTap != null) {
                  widget.onTap!();
                }
              },
              validator: widget.validator,
              showCursor: widget.showCursor,
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
              keyboardType: widget.inputType,
              obscureText: widget.isPassword == true ? obscureText : false,
              style: TextStyle(
                  fontFamily: Fonts.nunito,
                  color: widget.fieldGroupColors ??
                      (AppThemeNotifier.colorScheme(context).primary),
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  decoration: TextDecoration.none,
                  decorationColor: Colors.transparent),
              decoration: InputDecoration(
                  fillColor: widget.fillColor ??
                      ((widget.fieldController != null &&
                              widget.fieldController!.text.isNotEmpty &&
                              AppThemeNotifier.colorScheme(context).primary ==
                                  AppColors.black)
                          ? AppColors.blue1
                          : AppThemeNotifier.colorScheme(context).onPrimary),
                  filled: true,
                  contentPadding: widget.contentPadding ??
                      EdgeInsets.symmetric(vertical: 16.sp, horizontal: 10.sp),
                  labelText: widget.labelText,
                  labelStyle: TextStyle(
                      fontFamily: Fonts.nunito,
                      color: widget.fieldGroupColors ??
                          widget.hintColor ??
                          AppColors.grey3,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                      fontFamily: Fonts.nunito,
                      color: widget.fieldGroupColors ??
                          widget.hintColor ??
                          AppColors.grey3,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp),
                  //  suffix: widget.suffixIcon ?? SizedBox.shrink(),
                  prefixIcon: widget.prefixIcon,
                  prefixIconConstraints: BoxConstraints(
                      maxHeight: 30.sp,
                      maxWidth: 60.sp,
                      minHeight: 25.sp,
                      minWidth: 55.sp),
                  suffixIconConstraints: widget.suffixIconConstraints ??
                      BoxConstraints(
                          maxHeight: 37.5.sp + (widget.extra ?? 0),
                          maxWidth: 45.sp + (widget.extra ?? 0),
                          minHeight: 24.5.sp + (widget.extra ?? 0),
                          minWidth: 35.sp + (widget.extra ?? 0)),
                  suffixIcon: widget.suffixIcon != null
                      ? Padding(
                          padding: EdgeInsets.only(right: 15.sp),
                          child: widget.suffixIcon,
                        )
                      : (widget.isPassword
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              child: IconOf(obscureText == true
                                  ? Icons.visibility
                                  : Icons.visibility_off))
                          : const SizedBox.shrink()),
                  enabledBorder: OutlineInputBorder(
                      borderRadius:
                        widget.boroderRadius??  BorderRadius.circular(widget.radius ?? 12.r),
                      borderSide: BorderSide(
                        color: widget.fieldGroupColors ??
                            widget.enabledBorderColor ??
                            AppColors.primaryColor,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(widget.radius ?? 12.r),
                      borderSide: BorderSide(
                        color: widget.fieldGroupColors ??
                            widget.focusedBorderColor ??
                            AppColors.grey3,
                      )),
                  counterText: widget.showWordCount == true
                      ? "${widget.fieldController!.text.length}/${widget.maxLength} characters"
                      : null),
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
  PasswordField({
    this.hintText,
    this.onChanged,
    this.isPassword = false,
    this.showVisibility = true,
    this.showCursor = true,
    this.fillColor,
    required this.fieldController,
    this.hintColor,
    this.fieldTitle,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines,
    this.maxLength,
    this.validator,
    this.radius,
    this.fieldGroupColors,
    this.enabledBorderColor,
    this.showWordCount = false,
    this.focusedBorderColor,
    this.inputType = TextInputType.text,
    super.key,
  });
  Color? fillColor,
      hintColor,
      enabledBorderColor,
      focusedBorderColor,
      fieldGroupColors;
  String? hintText, fieldTitle;
  double? radius;
  TextInputType inputType;
  int? maxLines, maxLength;
  TextEditingController? fieldController;
  VoidCallback? onTap;
  Widget? suffixIcon;
  String? Function(String?)? validator;
  Widget? prefixIcon;
  bool isPassword, showVisibility, showCursor, showWordCount;

  void Function(String?)? onChanged;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    return Column(
      children: [
        widget.fieldTitle == null
            ? const SizedBox.shrink()
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TextOf(
                        widget.fieldTitle!,
                        16,
                        5,
                        align: TextAlign.left,
                        color: widget.fieldGroupColors,
                      ))
                    ],
                  ),
                  YMargin(8.sp),
                ],
              ),
        TextFormField(
          onChanged: widget.onChanged,
          controller: widget.fieldController,

          cursorColor: AppColors.primaryColor,
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          showCursor: widget.showCursor,
          maxLength: widget.maxLength,
          validator: widget.validator,
          keyboardType: widget.inputType,
          //keyboardAppearance: ,
          obscureText: widget.isPassword == true ? obscureText : false,
          style: TextStyle(
              fontFamily: Fonts.nunito,
              color: AppThemeNotifier.colorScheme(context).primary,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              decoration: TextDecoration.none,
              decorationColor: Colors.transparent),
          decoration: InputDecoration(
              fillColor: widget.fillColor ??
                  ((widget.fieldController!.text.isNotEmpty &&
                          AppThemeNotifier.colorScheme(context).primary ==
                              AppColors.black)
                      ? AppColors.blue1
                      : AppThemeNotifier.colorScheme(context).onPrimary),
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.sp, horizontal: 10.sp),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                  fontFamily: Fonts.nunito,
                  color: widget.fieldGroupColors ??
                      widget.hintColor ??
                      AppColors.grey3,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp),
              //  suffix: widget.suffixIcon ?? SizedBox.shrink(),
              prefixIcon: widget.prefixIcon,
              prefixIconConstraints: BoxConstraints(
                  maxHeight: 30.sp,
                  maxWidth: 60.sp,
                  minHeight: 25.sp,
                  minWidth: 55.sp),
              suffixIconConstraints: BoxConstraints(
                  maxHeight: 37.5.sp,
                  maxWidth: 45.sp,
                  minHeight: 24.5.sp,
                  minWidth: 35.sp),
              suffixIcon: widget.suffixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(right: 15.sp),
                      child: widget.suffixIcon,
                    )
                  : (widget.isPassword
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          child: IconOf(obscureText == true
                              ? Icons.visibility
                              : Icons.visibility_off))
                      : const SizedBox.shrink()),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 12.r),
                  borderSide: BorderSide(
                    color: widget.fieldGroupColors ??
                        widget.enabledBorderColor ??
                        AppColors.primaryColor,
                  )),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 12.r),
                  borderSide: BorderSide(
                    color: widget.fieldGroupColors ??
                        widget.focusedBorderColor ??
                        AppColors.red,
                  )),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 12.r),
                  borderSide: BorderSide(
                    color: widget.fieldGroupColors ??
                        widget.focusedBorderColor ??
                        AppColors.red,
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 12.r),
                  borderSide: BorderSide(
                    color: widget.fieldGroupColors ??
                        widget.focusedBorderColor ??
                        AppColors.grey3,
                  )),
              counterText: widget.showWordCount == true
                  ? "${widget.fieldController!.text.length}/${widget.maxLength} characters"
                  : null),
        ),
      ],
    );
  }
}

int? incrementMaxLines(
    {required TextEditingController textControllercontroller}) {
int maxCharsPerLine = calculateMaxCharsPerLine();
  int lineBreaks = '\n'.allMatches(textControllercontroller.text).length;
  int calculatedLines = (textControllercontroller.text.length / maxCharsPerLine).ceil();
  return min(((calculatedLines > lineBreaks ? calculatedLines : lineBreaks) + 1), 5); /// [maximum of 6]

  // double ss = textControllercontroller.text.length / 0.8.sw;
  // int sz = ((ss * (1 / ss)).isNaN?1:(ss * (1 / ss))).toInt();
  // int v = sz;
  // return switch ("\n".allMatches(textControllercontroller.text).length >= 3) {
  //   true => 3,
  //   _ => (v)
  //   // (textControllercontroller.text.length > 108
  //   //   ? 5
  //   //   : textControllercontroller.text.length > 81
  //   //       ? 4
  //   //       : textControllercontroller.text.length > 54
  //   //           ? 3
  //   //           : textControllercontroller.text.length > 27
  //   //               ? 2
  //   //               : null)
  //};
}

int calculateMaxCharsPerLine() {
  double effectiveWidth =0.8.sw;
  double charWidth = 8.sp;
  return (effectiveWidth / charWidth).floor();
}

int calculateMaxLines(String text) {
  int maxCharsPerLine = calculateMaxCharsPerLine();
  int lineBreaks = '\n'.allMatches(text).length;
  int calculatedLines = (text.length / maxCharsPerLine).ceil();
  return (calculatedLines > lineBreaks ? calculatedLines : lineBreaks) + 1;
}


class LineBreakLimiter extends TextInputFormatter {
  final int maxLineBreaks;

  LineBreakLimiter(this.maxLineBreaks);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int lineBreakCount = '\n'.allMatches(newValue.text).length;

    if (lineBreakCount > maxLineBreaks) {
      return oldValue;
    }

    return newValue;
  }
}
