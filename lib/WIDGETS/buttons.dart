// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/WIDGETS/texts.dart';

// class Button extends StatefulWidget {
//   Button(
//       {required this.text,
//       this.onPressed,
//       this.buttonType = ButtonType.blueBg,
//       super.key});
//   final String text;
//   ButtonType? buttonType;
//   final VoidCallback? onPressed;

//   @override
//   State<Button> createState() => _ButtonState();
// }

// class _ButtonState extends State<Button> {
//   Color buttonColor = AppColors.secondaryColor;
//   @override
//   void initState() {
//     buttonColor = widget.buttonType == ButtonType.blueBg
//         ? widget.color?? AppColors.primaryColor
//         : widget.buttonType == ButtonType.whiteBg
//             ? AppColors.white
//             : AppColors.secondaryColor;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
//     return ElevatedButton(
//         style: ElevatedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//                 side: BorderSide(
//                     color: widget.buttonType == ButtonType.disabled
//                         ? AppColors.secondaryColor
//                         : widget.color?? AppColors.primaryColor),
//                 borderRadius: BorderRadius.circular(12)),
//             surfaceTintColor: AppColors.white,
//             fixedSize: Size(MediaQuery.of(context).size.width, 56),
//             backgroundColor: widget.color?? AppColors.primaryColor),
//         onPressed: widget.onPressed,
//         child: TextOf(widget.text, 16, 5,
//             color: widget.buttonType == ButtonType.whiteBg
//                 ? widget.color?? AppColors.primaryColor
//                 : AppColors.white));
//   }
// }

enum ButtonType { whiteBg, blueBg, disabled }

class Button extends StatefulWidget {
  Button({
    this.text,
    this.child,
    this.color,
    this.radius,
    this.fixedSize,
    this.onPressed,
    this.buttonType,
    super.key,
  });
  Widget? child;
  final String? text;
  Color? color;
  double? radius;
  Size? fixedSize;
  ButtonType? buttonType;
  final VoidCallback? onPressed;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  Color _resolveButtonColor() {
    if (widget.buttonType == ButtonType.blueBg) {
      return widget.color ?? AppColors.primaryColor;
    } else if (widget.buttonType == ButtonType.whiteBg) {
      return AppThemeNotifier.colorScheme(context).primary == AppColors.black
          ? AppColors.white
          : AppColors.grey1.withOpacity(0.075);
    } else {
      return AppColors.secondaryColor;
    }
  }

  Color _resolveButtonBorderColor() {
    if (widget.buttonType == ButtonType.disabled || widget.buttonType == null) {
      return AppColors.secondaryColor;
    } else {
      return widget.color ?? AppColors.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          disabledBackgroundColor: AppColors.secondaryColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: _resolveButtonBorderColor(),
              ),
              borderRadius: BorderRadius.circular(widget.radius ?? 12)),
          fixedSize: widget.fixedSize ??
              Size(MediaQuery.of(context).size.width, 56.sp),
          backgroundColor: _resolveButtonColor()
          // onSurface: AppColors.white, // Change to onSurface if needed
          ),
      onPressed: (widget.buttonType == ButtonType.disabled ||
              widget.buttonType == null)
          ? null
          : widget.onPressed,
      child: widget.child ??
          TextOf(
            widget.text!,
            16.sp,
            5,
            color: widget.buttonType == ButtonType.whiteBg
                ? widget.color ?? AppColors.primaryColor
                : AppColors.white,
          ),
    );
  }
}

class Button2 extends StatelessWidget {
  Button2({
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    super.key,
  });

  final String text;
  void Function()? onPressed;
  Color? backgroundColor, textColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primaryColor,
        fixedSize: Size(
          0.85.sw,
          40.sp,
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.red),
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      onPressed: onPressed,
      child: TextOf(
        text,
        16.sp,
        5,
        color: textColor,
      ),
    );
  }
}
