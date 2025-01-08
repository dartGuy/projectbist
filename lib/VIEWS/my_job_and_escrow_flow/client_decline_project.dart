import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/widgets/texts.dart';

import 'package:project_bist/VIEWS/web_view_page/web_view_page.dart';
import 'package:flutter/gestures.dart';

class ClientDeclineProject extends ConsumerStatefulWidget {
  final String planId;
  static const String clientDeclineProject = 'clientDeclineProject';
  const ClientDeclineProject({required this.planId, super.key});

  @override
  ConsumerState<ClientDeclineProject> createState() => _ClientDeclineProjectState();
}

class _ClientDeclineProjectState extends ConsumerState<ClientDeclineProject> {
  bool acceptedTerms = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context,
            title: "Decline", hasIcon: true, hasElevation: true),
        body: Padding(
          padding: appPadding(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              Row(children: [
                Expanded(
                  child: TextOf(
                      "You are one step closer to declining your project.",
                      14.sp,
                      4,
                      align: TextAlign.left,
                      color: AppColors.brown),
                )
              ]),
              YMargin(10.sp),
              Row(children: [
                Expanded(
                    child: TextOf("Decline Terms and Conditions", 24.sp, 5,
                        align: TextAlign.left))
              ]),
              YMargin(10.sp),
              TextOf(
                aggrement,
                16.sp,
                4,
                align: TextAlign.left,
                height: 1.55.sp,
              ),
              YMargin(32.sp),
              Row(children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      acceptedTerms = !acceptedTerms;
                    });
                  },
                  child: IconOf(
                      acceptedTerms == true
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_outlined,
                      color: AppThemeNotifier.colorScheme(context).primary),
                ),
                XMargin(10.sp),
                RichText(
                    text: TextSpan(
                        text: "I agree with ",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color:
                                AppThemeNotifier.colorScheme(context).primary),
                        children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(
                              context, WebViewPage.webViewPage,
                              arguments: WebViewPageArgument(
                                  sideDisplayUrl:
                                      "https://projectbist.com/terms-and-conditions",
                                  loadingMessage:
                                      "Loading terms of service...")),
                        text: "Terms & conditions",
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.primaryColor),
                      )
                    ]))
              ]),
              YMargin(20.sp),
              Button(
                  text: "Proceed",
                  buttonType: acceptedTerms == true
                      ? ButtonType.blueBg
                      : ButtonType.disabled,
                  onPressed: () {
                    EscrowProvider.declineSubmissionPlan(context, ref, planId: widget.planId);
                  }),
              YMargin(32.sp),
            ]),
          ),
        ));
  }
}

const String aggrement =
    "By using ProjectBist, you acknowledge and agree to the following terms and conditions when seeking research assistance and collaboration with research experts facilitated by the platform.\n\n1. Research Assistance: - ProjectBist is designed to connect students with Researchers to assist in academic research projects. - You may request services such as literature reviews, data analysis, and guidance in accordance with academic integrity standards.\n\n2. Confidentiality and Nondisclosure: - You understand that all information shared during your research collaboration is confidential. You agree not to disclose or misuse any Confidential Information shared by Researchers.\n\n3. Researcher Recognition: - You recognize and agree to acknowledge the contributions of the Researchers in your research work, including but not limited to the acknowledgment section or any relevant part of your research paper.\n\n4. Ethical Use: - You agree to use the research assistance for academic and ethical purposes only. You will not engage in plagiarism or any form of academic dishonesty.\n\n5. Payment and Compensation: - You will pay Researchers for their services as agreed upon, based on the scope of work and complexity of the research project.\n\n6. Research Ownership: - You retain ownership of your research project and the final work product. Researchers provide assistance and guidance but do not claim ownership of your work.";
