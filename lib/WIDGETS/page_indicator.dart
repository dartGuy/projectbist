import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.initialIndex,
    required this.length,
  });

  final int initialIndex, length;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          length,
          (index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.sp),
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: initialIndex == index
                      ? AppColors.primaryColor
                      : AppColors.blueLite,
                ),
              )),
    );
  }
}
