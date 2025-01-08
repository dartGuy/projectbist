import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/VIEWS/wallet_processes/create_wallet.dart';
import 'package:project_bist/VIEWS/wallet_processes/wallet_home.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/drawer_contents.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class WalletSetup extends StatefulWidget {
  static const String walletSetup = "walletSetup";
  const WalletSetup({super.key});

  @override
  State<WalletSetup> createState() => _WalletSetupState();
}

class _WalletSetupState extends State<WalletSetup> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerContents(),
      body: Builder(builder: (context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (value) {
            Scaffold.of(context).openDrawer();
          },
          child: Padding(
            padding: appPadding(),
            child: Column(
              children: [
                Expanded(
                  flex: 15,
                  child: PageView.builder(
                    itemCount: 3,
                    onPageChanged: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                    itemBuilder: (context, index) => Column(
                      children: [
                        Expanded(
                            flex: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SvgPicture.asset(currentIndex == 0
                                    ? ImageOf.walletSlider1
                                    : currentIndex == 1
                                        ? ImageOf.walletSlider2
                                        // : currentIndex == 2
                                        //     ? ImageOf.walletSlider3
                                            : ImageOf.walletSlider4),
                              ],
                            )),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextOf(
                                  currentIndex == 0
                                      ? "Sign up for your wallet with your NIN"
                                      : currentIndex == 1
                                          ? "Generate NIN Via USSD"
                                          // : currentIndex == 2
                                          //     ? "Generate Via NIMC App"
                                              : "Your Name will be Verified",
                                  25.sp,
                                  7,
                                  fontFamily: Fonts.montserrat,
                                ),
                                YMargin(25.sp),
                                switch (currentIndex) {
                                  1 => RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppThemeNotifier.colorScheme(
                                                          context)
                                                      .primary),
                                          text:
                                              "Get your NIN with the code ",
                                          children: [
                                            TextSpan(
                                                text:
                                                    "*346# ",
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppThemeNotifier
                                                            .colorScheme(
                                                                context)
                                                        .primary),
                                                children: [
                                                  TextSpan(
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppThemeNotifier
                                                                  .colorScheme(
                                                                      context)
                                                              .primary),
                                                      text:
                                                          "for NGN20 \n1. Select NIN Retrieval by typing in 1\n2. Follow the instructions on your screen\n3. Your phone will display your ",
                                                          children: [
                                                  TextSpan(
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppThemeNotifier
                                                                  .colorScheme(
                                                                      context)
                                                              .primary),
                                                      text:
                                                          "11-digit NIN", children: [
                                                  TextSpan(
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppThemeNotifier
                                                                  .colorScheme(
                                                                      context)
                                                              .primary),
                                                      text:
                                                          "NIN")
                                                ])
                                                ]
                                                          )
                                                ])
                                          ])),
                                  // 2 => RichText(
                                  //     textAlign: TextAlign.center,
                                  //     text: TextSpan(
                                  //         style: TextStyle(
                                  //             fontSize: 16.sp,
                                  //             fontWeight: FontWeight.w400,
                                  //             color:
                                  //                 AppThemeNotifier.colorScheme(
                                  //                         context)
                                  //                     .primary),
                                  //         text: "On your Homepage, click on ",
                                  //         children: [
                                  //           TextSpan(
                                  //               style: TextStyle(
                                  //                   fontSize: 16.sp,
                                  //                   fontWeight: FontWeight.w500,
                                  //                   color: AppThemeNotifier
                                  //                           .colorScheme(
                                  //                               context)
                                  //                       .primary),
                                  //               text: "“Get Virtual NIN”",
                                  //               children: [
                                  //                 TextSpan(
                                  //                     style: TextStyle(
                                  //                         fontSize: 16.sp,
                                  //                         fontWeight:
                                  //                             FontWeight.w400,
                                  //                         color: AppThemeNotifier
                                  //                                 .colorScheme(
                                  //                                     context)
                                  //                             .primary),
                                  //                     text:
                                  //                         ", get started and click on ",
                                  //                     children: [
                                  //                       TextSpan(
                                  //                           style: TextStyle(
                                  //                               fontSize: 16.sp,
                                  //                               fontWeight:
                                  //                                   FontWeight
                                  //                                       .w500,
                                  //                               color: AppThemeNotifier
                                  //                                       .colorScheme(
                                  //                                           context)
                                  //                                   .primary),
                                  //                           text:
                                  //                               "“Input Enterprise short-code” ",
                                  //                           children: [
                                  //                             TextSpan(
                                  //                                 style: TextStyle(
                                  //                                     fontSize:
                                  //                                         16,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .w400,
                                  //                                     color: AppThemeNotifier.colorScheme(
                                  //                                             context)
                                  //                                         .primary),
                                  //                                 text:
                                  //                                     "enter the enterprise short code: ",
                                  //                                 children: [
                                  //                                   TextSpan(
                                  //                                       style: TextStyle(
                                  //                                           fontSize:
                                  //                                               16,
                                  //                                           fontWeight: FontWeight
                                  //                                               .w500,
                                  //                                           color: AppThemeNotifier.colorScheme(context)
                                  //                                               .primary),
                                  //                                       text:
                                  //                                           "696739, ",
                                  //                                       children: [
                                  //                                         TextSpan(
                                  //                                           style: TextStyle(
                                  //                                               fontSize: 16.sp,
                                  //                                               fontWeight: FontWeight.w400,
                                  //                                               color: AppThemeNotifier.colorScheme(context).primary),
                                  //                                           text:
                                  //                                               "and submit.",
                                  //                                         )
                                  //                                       ])
                                  //                                 ])
                                  //                           ])
                                  //                     ])
                                  //               ])
                                  //         ])),
                                  _ => TextOf(
                                      currentIndex == 0
                                          ? "Sign up and verify your wallet using your National Identification Number (NIN); a unique 11-digit number issued by the NIMC"
                                          : "Your first and last name must be the same with your NIN information.",
                                      16.sp,
                                      4,
                                    ),
                                },
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        0.025.sh.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              3,
                              (index) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3.5.sp),
                                    child: CircleAvatar(
                                      radius: 5.sp,
                                      backgroundColor: currentIndex == index
                                          ? AppColors.primaryColor
                                          : AppColors.secondaryColor
                                              .withOpacity(0.6),
                                    ),
                                  )),
                        ),
                        0.025.sh.verticalSpace,
                        currentIndex != 2
                            ? const SizedBox.shrink()
                            : Button(
                                text: "Get Started",
                                buttonType: ButtonType.blueBg,
                                onPressed: () {
                                  getIt<AppModel>()
                                      .appCacheBox!
                                      .put(AppConst.HAS_SEEN_WALLET_FLOW, true);
                                  AppMethods.isBackendVerifiedUser()
                                      ? Navigator.pushReplacementNamed(context,
                                          WalletHomePage.walletHomePage)
                                      : Navigator.pushNamed(
                                          context, CreateWallet.createWallet);
                                },
                              )
                      ],
                    ))
              ],
            ),
          ),
        );
      }),
    );
  }
}
