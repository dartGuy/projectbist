// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

enum RequestStatus { success, failed, loading }

class RequestStatusPageArgument {
  final String title, subtitle;
  final RequestStatus status;
  final String? buttonText;
  final VoidCallback? onTapButton;
  final Widget? customSubtitle;
  RequestStatusPageArgument(
      {required this.title,
      this.subtitle = "",
      this.onTapButton,
      this.customSubtitle,
      required this.status,
      this.buttonText});
}

class RequestStatusPage extends StatelessWidget {
  static const String requestStatusPage = "requestStatusPage";
  RequestStatusPage({required this.requesStatusPageArgument, super.key});
  RequestStatusPageArgument requesStatusPageArgument;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: appPadding().copyWith(bottom: 30.sp),
          child: Column(
            children: [
              requesStatusPageArgument.status != RequestStatus.success
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const IconOf(Icons.close))
                      ],
                    )
                  : const SizedBox.shrink(),
              YMargin(0.02.sh),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      switch (requesStatusPageArgument.status) {
                        RequestStatus.success => ImageOf.successGif,
                        RequestStatus.failed => ImageOf.cancelGif,
                        _ => ImageOf.loadingGif
                      },
                      height: 0.275.sh,
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   flex: 3,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //        ],
              //   ),
              // ),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextOf(
                              requesStatusPageArgument.title,
                              18.sp,
                              7,
                              align: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      YMargin(16.sp),
                      requesStatusPageArgument.customSubtitle ??
                          TextOf(requesStatusPageArgument.subtitle, 16.sp, 4),
                      requesStatusPageArgument.status == RequestStatus.loading
                          ? const SizedBox.shrink()
                          : Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Button(
                                    text: requesStatusPageArgument.buttonText ??
                                        "Go to Home",
                                    onPressed: () {
                                      requesStatusPageArgument.onTapButton ==
                                              null
                                          ? Navigator.pop(context)
                                          : requesStatusPageArgument
                                              .onTapButton!();
                                    },
                                    buttonType: ButtonType.blueBg,
                                  )
                                ],
                              ),
                            ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
