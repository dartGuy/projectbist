import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/profile_provider/profile_provider.dart';
import 'package:project_bist/PROVIDERS/transaction_providers/transaction_providers/transaction_providers.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/components/app_bottom_sheet.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/drawer_contents.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/UTILS/launch_url.dart';

class CreateWallet extends ConsumerStatefulWidget {
  static const String createWallet = "createWallet";
  const CreateWallet({super.key});

  @override
  ConsumerState<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends ConsumerState<CreateWallet> {
  late TextEditingController virtualNinController;
  @override
  void initState() {
    setState(() {
      virtualNinController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    virtualNinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponseStatus responseStatus = ref.watch(profileProvider);
    ref.watch(profileProvider.notifier).getRequest(
        context: context,
        url: Endpoints.GET_PROFILE,
        loadingMessage: "Please wait...");
    getIt<AppModel>().userProfile = UserProfile.fromJson(responseStatus.data);
    UserProfile userProfile = getIt<AppModel>().userProfile!;
    return Scaffold(
      drawer: const DrawerContents(),
      appBar: customAppBar(
        context,
        hasElevation: true,
        hasIcon: true,
        title: "Create Wallet",
        scale: 1.25.sp,
        leading: Builder(builder: (context) {
          return InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const IconOf(Icons.menu, color: AppColors.primaryColor),
          );
        }),
      ),
      body: Builder(builder: (context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (value) {
            Scaffold.of(context).openDrawer();
          },
          child: Padding(
            padding: appPadding().copyWith(bottom: 20.sp),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox.expand(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: TextOf(
                              "Kindly supply your NIN to create your wallet.",
                              16.sp,
                              4,
                              align: TextAlign.left,
                            ))
                          ],
                        ),
                        YMargin(16.sp),
                        InputField(
                            fieldTitle: "Email address",
                            showCursor: false,
                            readOnly: true,
                            fieldGroupColors: AppColors.grey2,
                            inputType: TextInputType.none,
                            fieldController: TextEditingController(
                                text: switch (responseStatus.responseState) {
                              ResponseState.ERROR => "--No data found--",
                              ResponseState.DATA => userProfile.email!,
                              _ => "---"
                            })),
                        YMargin(16.sp),
                        InputField(
                            fieldTitle: "Full name",
                            readOnly: true,
                            showCursor: false,
                            //  hintText: "Lagbaja",
                            fieldController: TextEditingController(
                                text: switch (responseStatus.responseState) {
                              ResponseState.ERROR => "--No data found--",
                              ResponseState.DATA => userProfile.fullName!,
                              _ => "---"
                            })),
                        YMargin(16.sp),
                        InputField(
                            fieldTitle: "NIN",
                            hintText: "12345678910",
                            inputType: TextInputType.number,
                            onChanged: (value) {
                              // setState(() {
                              //   virtualNinController.text =
                              //       virtualNinController.text.toUpperCase();
                              // });
                            },
                            fieldController: virtualNinController),
                        YMargin(24.sp),
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.sp,
                                          color: AppThemeNotifier.colorScheme(
                                                  context)
                                              .primary),
                                      text:
                                          'The email you used in registering your account will be used for your wallet. ',
                                      children: [
                                        TextSpan(
                                            text: "Contact support ",
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () =>
                                                  LaunchUrl.launchEmailAddress(
                                                      context,
                                                      emailAddress: AppConst
                                                          .SUPPORT_EMAIL,
                                                      emailSubject:
                                                          "[App User] - [YOUR SUBJECT]",
                                                      emailBody:
                                                          "Start typing..."),
                                            style: const TextStyle(
                                                color: AppColors.primaryColor,
                                                decoration:
                                                    TextDecoration.underline),
                                            children: [
                                              TextSpan(
                                                  text: "to change your email.",
                                                  style: TextStyle(
                                                      color: AppThemeNotifier
                                                              .colorScheme(
                                                                  context)
                                                          .primary,
                                                      decoration:
                                                          TextDecoration.none))
                                            ])
                                      ])),
                            )
                          ],
                        ),
                        YMargin(0.2.sh),
                        if (responseStatus.responseState == ResponseState.ERROR)
                          Button(
                            text: "Try again!",
                            onPressed: () {
                              ref.watch(profileProvider.notifier).getRequest(
                                  context: context,
                                  url: Endpoints.GET_PROFILE,
                                  loadingMessage: "Please wait...");
                            },
                            radius: 100,
                            buttonType: ButtonType.blueBg,
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.3, 46.sp),
                          )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 10.sp),
                  color: AppThemeNotifier.themeColor(context)
                      .scaffoldBackgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      responseStatus.responseState == ResponseState.ERROR
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .watch(profileProvider.notifier)
                                        .getRequest(
                                            context: context,
                                            url: Endpoints.GET_PROFILE,
                                            loadingMessage: "Please wait...");
                                  },
                                  child: TextOf("REFRESH THIS PAGE", 13.sp, 6,
                                      color: AppColors.primaryColor),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                      Row(
                        children: [
                          TextOf(
                              "How can I generate my Virtual NIN?", 16.sp, 4),
                          XMargin(5.sp),
                          InkWell(
                            onTap: () {
                              showSheetContents();
                            },
                            child: const IconOf(
                              Icons.info,
                              color: AppColors.brown,
                            ),
                          )
                        ],
                      ),
                      YMargin(20.sp),
                      Button(
                        text: "Verify",
                        buttonType:
                         virtualNinController.text.length == 11 &&
                                responseStatus.responseState ==
                                    ResponseState.DATA
                            ? ButtonType.blueBg
                            : ButtonType.disabled,
                        onPressed: () {
                          TransactionsProvider.submitKYC(context, ref,
                              virtualNIN: virtualNinController.text);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  bool fieldCpmpleted() {
    return (virtualNinController.text.isNotEmpty);
  }

  void showSheetContents() {
    appBottomSheet(context,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextOf("How can I generate my NIN?", 18.sp, 7),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: IconOf(
                    Icons.close,
                    size: 17.5.sp,
                  ),
                )
              ],
            ),
            YMargin(24.sp),
            Row(
              children: [
                Expanded(
                    child: TextOf(
                  "Generate Via USSD",
                  18.sp,
                  7,
                  align: TextAlign.left,
                ))
              ],
            ),
            YMargin(5.sp),
            RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppThemeNotifier.colorScheme(context).primary),
                    text: "Get your NIN with the code ",
                    children: [
                      TextSpan(
                          text: "*346#, ",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppThemeNotifier.colorScheme(context)
                                  .primary),
                          children: [
                            TextSpan(
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppThemeNotifier.colorScheme(context)
                                        .primary),
                                text:
                                    "input ",
                                    children: [
                            TextSpan(
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppThemeNotifier.colorScheme(context)
                                        .primary),
                                text:
                                    "1 ",
                                children: [
                            TextSpan(
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppThemeNotifier.colorScheme(context)
                                        .primary),
                                text:
                                    "and follow the next instruction. Your 11-digit NIN will be displayed on your sceen.")
                          ]
                                    )
                          ]
                                    )
                          ])
                    ])),
            YMargin(10.sp),
            // Row(
            //   children: [
            //     Expanded(
            //         child: TextOf(
            //       "Generate Via NIMC App",
            //       18.sp,
            //       7,
            //       align: TextAlign.left,
            //     ))
            //   ],
            // ),
            // YMargin(5.sp),
            // RichText(
            //     textAlign: TextAlign.left,
            //     text: TextSpan(
            //         style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w400,
            //             color: AppThemeNotifier.colorScheme(context).primary),
            //         text: "On your Homepage, click on ",
            //         children: [
            //           TextSpan(
            //               style: TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w500,
            //                   color: AppThemeNotifier.colorScheme(context)
            //                       .primary),
            //               text: "“Get Virtual NIN”",
            //               children: [
            //                 TextSpan(
            //                     style: TextStyle(
            //                         fontSize: 16,
            //                         fontWeight: FontWeight.w400,
            //                         color: AppThemeNotifier.colorScheme(context)
            //                             .primary),
            //                     text: ", get started and click on ",
            //                     children: [
            //                       TextSpan(
            //                           style: TextStyle(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.w500,
            //                               color: AppThemeNotifier.colorScheme(
            //                                       context)
            //                                   .primary),
            //                           text: "“Input Enterprise short-code” ",
            //                           children: [
            //                             TextSpan(
            //                                 style: TextStyle(
            //                                     fontSize: 16,
            //                                     fontWeight: FontWeight.w400,
            //                                     color: AppThemeNotifier
            //                                             .colorScheme(context)
            //                                         .primary),
            //                                 text:
            //                                     "enter the enterprise short code ",
            //                                 children: [
            //                                   TextSpan(
            //                                       style: TextStyle(
            //                                           fontSize: 16,
            //                                           fontWeight:
            //                                               FontWeight.w500,
            //                                           color: AppThemeNotifier
            //                                                   .colorScheme(
            //                                                       context)
            //                                               .primary),
            //                                       text: "696739 ",
            //                                       children: [
            //                                         TextSpan(
            //                                           style: TextStyle(
            //                                               fontSize: 16,
            //                                               fontWeight:
            //                                                   FontWeight.w400,
            //                                               color: AppThemeNotifier
            //                                                       .colorScheme(
            //                                                           context)
            //                                                   .primary),
            //                                           text: "and submit.",
            //                                         )
            //                                       ])
            //                                 ])
            //                           ])
            //                     ])
            //               ])
            //         ])),
          ],
        ));
  }
}

// class BouncingAnimation extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Bouncing Image'),
//         ),
//         body: Center(
//           child: BouncingImage(),
//         ),
//       ),
//     );
//   }
// }

// class BouncingImage extends StatefulWidget {
//   @override
//   _BouncingImageState createState() => _BouncingImageState();
// }

// class _BouncingImageState extends State<BouncingImage>
//     with SingleTickerProviderStateMixin {
//   double initialHeight = 200;
//   double initialImageHeight = 200;
//   double expandedImageHeight = 300;
//   void poopAnimationIn() async {
//     setState(() {
//       initialImageHeight = expandedImageHeight;
//     });
//     await Future.delayed(const Duration(milliseconds: 500), () {
//       setState(() {
//         initialImageHeight = initialHeight;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox.square(
//               dimension: 110.sp,
//               child: RippleWave(
//                   color: AppColors.primaryColor,
//                   child: Image.asset(
//                     ImageOf.logoRound,
//                     height: 50.sp,
//                   )),
//             ),

//             // Positioned(
//             //   right: 5,
//             //   top: 5,
//             //   child:Image.asset(ImageOf.logo),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
// }
