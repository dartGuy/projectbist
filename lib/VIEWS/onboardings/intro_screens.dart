import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/VIEWS/auths/login_screens.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/page_indicator.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

class IntroScreens extends StatefulWidget {
  static const String introScreens = "introScreens";

  const IntroScreens({super.key});

  @override
  State<IntroScreens> createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  int initialIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: appPadding(),
          child: Column(
            children: [
              const Expanded(
                flex: 1,
                child: SizedBox.expand(),
              ),
              Expanded(
                flex: 7,
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (value) {
                    setState(() {
                      initialIndex = value;
                    });
                  },
                  children: List.generate(3, (index) {
                    return pageViewContents(id: index);
                  }),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    YMargin(35.sp),
                    PageIndicator(
                      initialIndex: initialIndex,
                      length: 3,
                    ),
                    YMargin(35.sp),
                    Button(
                        text: "Create an Account",
                        buttonType: ButtonType.blueBg,
                        onPressed: () {
                          Navigator.pushNamed(context,
                              BeginUserDetermination.beginUserDetermination);
                        }),
                    YMargin(0.02.sh),
                    Button(
                      text: "Login",
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.loginScreen);
                      },
                      buttonType: ButtonType.whiteBg,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<String> companyAndInstitutionNames = [
    'Dangote Group',
    'Guaranty Trust Bank (GTBank)',
    'Nigerian National Petroleum Corporation (NNPC)',
    'Zenith Bank',
    'Access Bank',
    'University of Lagos (UNILAG)',
    'First Bank of Nigeria',
    'Lagos State University (LASU)',
    'Oando',
    'MTN Nigeria',
    'United Bank for Africa (UBA)',
    'Nigerian Breweries',
    'Covenant University',
    'Flour Mills of Nigeria',
    'Fidelity Bank',
    'Airtel Nigeria',
    'Julius Berger Nigeria',
    'Nigerian Stock Exchange (NSE)',
    'Stanbic IBTC Bank',
    'University of Ibadan (UI)',
  ];

  pageViewContents({required int id}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        YMargin(id == 0 ? 0.05.sh : 0),
        SvgPicture.asset(
          id == 0
              ? ImageOf.slidie1
              : id == 1
                  ? ImageOf.slidie2
                  : ImageOf.slidie3,
          height: 0.3.sh,
        ),
        Column(
          children: [
            TextOf(
              switch (id) {
                0 => "Are You a Student or Professional?",
                1 => "In Need of Research Materials?",
                _ => "Are You a Researcher?"
              },
              26.sp,
              7,
              fontFamily: Fonts.montserrat,
            ),
            YMargin(20.sp),
            Row(
              children: [
                Expanded(
                  child: TextOf(
                    switch (id) {
                      0 => "Get expert solutions for your research needs",
                      1 =>
                        "Explore original research materials, tested for plagiarism and AI contents",
                      _ =>
                        "Connect with a pool of clients seeking your specialized skills "
                    },
                    18.sp,
                    4,
                    fontFamily: Fonts.montserrat,
                    align: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
