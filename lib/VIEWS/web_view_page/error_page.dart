// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/texts.dart';

@immutable
class ErrorPage extends StatefulWidget {
  const ErrorPage({
    super.key,
    required this.controller,
  });

  final InAppWebViewController? controller;

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  double _width = 400.0;
  double _height = 50.0;
  void _tapDown(TapDownDetails details) {
    setState(() {
      _width = 300.0;
      _height = 36.0;
    });
  }

  void _tapUp(TapUpDetails details) {
    setState(() {
      _width = 400.0;
      _height = 50.0;
    });
  }

  void _tapCancel() {
    setState(() {
      _width = 400;
      _height = 50.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Image.asset(
                        ImageOf.cancelGif,
                        height: 250,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextOf("Something went wrong!", 15.sp, 6),
                      const SizedBox(height: 2),
                      TextOf(
                          "Kindly confirm your internet connection\nis stable and try again.",
                          13.sp,
                          4,
                          color: AppColors.grey2),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      GestureDetector(
                        onTapDown: _tapDown,
                        onTapUp: _tapUp,
                        onTapCancel: _tapCancel,
                        onTap: () {
                          widget.controller!.reload();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          width: _width,
                          height: _height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.primaryColor,
                          ),
                          child: Center(
                              child: TextOf(
                            "Kindly confirm your internet connection\nis stable and try again.",
                            15.sp,
                            5,
                            color:
                                AppThemeNotifier.colorScheme(context).onPrimary,
                          )
                              // child: Text(
                              //   "Reload",
                              //   style: AppColors.bodyLargeBold.copyWith(
                              //       color: AppColors.white,
                              //       fontSize: 15,
                              //       fontWeight: FontWeight.w500),
                              // ),
                              ),
                        ),
                      )
                    ])))));
  }
}
