import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:pinput/pinput.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/WIDGETS/texts.dart';

// ignore: must_be_immutable
class OtpField extends StatefulWidget {
  int InputFieldLength;
  late TextEditingController? pinController;
  OtpField(
      {this.InputFieldLength = 4,
      this.borderRadius,
      this.pinController,
      this.size = 50,
      this.color,
      this.onChanged,
      super.key});
  Color? color;

  Function(String)? onChanged;
  double? borderRadius;
  double size;
  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  late FocusNode focusNode;

  @override
  void dispose() {
    widget.pinController?.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    widget.pinController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color focusedBorderColor = AppColors.primaryColor;
    Color fillColor = AppThemeNotifier.colorScheme(context).onPrimary;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Pinput(
          controller: widget.pinController,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          length: widget.InputFieldLength,
          focusNode: focusNode,
          androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
          listenForMultipleSmsOnAndroid: true,
          defaultPinTheme:
              defaultPinTheme(context, size: widget.size, color: widget.color),
          separatorBuilder: (index) => SizedBox(width: 8.sp),
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          onCompleted: (pin) {
            debugPrint('onCompleted: $pin');
          },
          onChanged: widget.onChanged,
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 9.sp),
                width: widget.size * 0.5.sp,
                height: 1,
                color: focusedBorderColor,
              ),
            ],
          ),
          obscureText: false,
          // obscuringWidget: CircleAvatar(
          //   backgroundColor: AppThemeNotifier.colorScheme(context).primary,
          //   radius: widget.size * 0.2.r,
          // ),
          focusedPinTheme:
              defaultPinTheme(context, size: widget.size, color: widget.color)
                  .copyWith(
            decoration:
                defaultPinTheme(context, size: widget.size, color: widget.color)
                    .decoration!
                    .copyWith(
                      borderRadius:
                          BorderRadius.circular(widget.borderRadius ?? 9.sp),
                      border: Border.all(color: focusedBorderColor),
                    ),
          ),
          // disabledPinTheme: ,
          submittedPinTheme:
              defaultPinTheme(context, size: widget.size, color: widget.color)
                  .copyWith(
            decoration:
                defaultPinTheme(context, size: widget.size, color: widget.color)
                    .decoration!
                    .copyWith(
                      color: fillColor,
                      borderRadius:
                          BorderRadius.circular(widget.borderRadius ?? 10.sp),
                      border: Border.all(color: focusedBorderColor),
                    ),
          ),
          errorPinTheme:
              defaultPinTheme(context, size: widget.size, color: widget.color)
                  .copyBorderWith(
            border: Border.all(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  final formKey = GlobalKey<FormState>();

  PinTheme defaultPinTheme(BuildContext context,
      {required double size, Color? color}) {
    return PinTheme(
      width: size,
      height: size,
      textStyle: TextStyle(
        fontSize: 18,
        fontFamily: Fonts.nunito,
        color: AppThemeNotifier.colorScheme(context).primary,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 9.sp),
        color: color ??
            AppThemeNotifier.colorScheme(context).onPrimary.withOpacity(0.5.sp),
        border: Border.all(
            color: color ??
                (AppThemeNotifier.colorScheme(context).primary ==
                        AppColors.black
                    ? AppColors.grey1
                    : AppColors.grey2)),
      ),
    );
  }
}
