import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

class PrivacyAndPolicy extends StatelessWidget {
  static const String privacyAndPolicy = "privacyAndPolicy";
  const PrivacyAndPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: "Privacy", hasIcon: true, hasElevation: true),
      body: Padding(
        padding: appPadding(),
        child: TextOf(
          privacyPolicy,
          16.sp,
          5,
          height: 1.75.sp,
          align: TextAlign.left,
        ),
      ),
    );
  }
}

const String privacyPolicy =
    "Although natural wetlands only cover about 4% of the earth's ice-free land surface, they are the world's largest methane (CH4) source and the only one dominated by climate. In addition, wetlands affect climate by modulating temperatures and heat fluxes, storing water, increasing evaporation, and altering the seasonality of runoff and river discharge to the oceans.\n\nCuCurrent CH4 emissions from wetlands are relatively well understood but the sensitivity of wetlands and their emissions to climate variations remains the largest uncertainty in the global CH4 cycle and could strongly influence predictions of future climate.\n\nCurrent CH4 emissions from wetlands are relatively well understood but the sensitivity of wetlands and their emissions to climate variations remains the largest uncertainty in the global CH4 cycle and could strongly influence predictions of future climate.";
