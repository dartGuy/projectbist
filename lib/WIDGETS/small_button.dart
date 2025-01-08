import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
    super.key,
    required this.text,
    this.onTapped,
  });
  final String text;
  final VoidCallback? onTapped;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.sp,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
              backgroundColor: AppColors.primaryColor,
              disabledBackgroundColor: AppColors.primaryColor
              //fixedSize: Size(106.sp, 0.sp)
              ),
          onPressed: onTapped,
          child: TextOf(text, 12.sp, 5, color: AppColors.white)),
    );
  }
}
