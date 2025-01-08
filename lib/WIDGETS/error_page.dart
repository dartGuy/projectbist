// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({
    super.key,
    this.showButton = true,
    this.onPressed,
    required this.message,
  });
  void Function()? onPressed;
  String message = "";
  bool? showButton;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.sp),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox.square(dimension: 230.sp, child: SvgPicture.asset(ImageOf.noResult)),
          YMargin(10.sp),
          TextOf("Not available", 20.sp, 7),
          YMargin(7.sp),
          TextOf(message, 15.sp, 4),
          YMargin(10.sp),
          (showButton == true &&
                  message.toLowerCase() !=
                      AppConst.ACCESS_FORBIDDEN.toLowerCase())
              ? Button(
                  text: "Try again!",
                  onPressed: onPressed,
                  radius: 100,
                  buttonType: ButtonType.blueBg,
                  fixedSize:
                      Size(MediaQuery.of(context).size.width * 0.3, 46.sp),
                )
              : const SizedBox.shrink()
        ]),
      ),
    );
  }
}
