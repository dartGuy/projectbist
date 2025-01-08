import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/reviews_provider/reviews_provider.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/drawer_contents.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

class MakeReportScreen extends ConsumerStatefulWidget {
  static const String makeReportScreen = "makeReportScreen";
  const MakeReportScreen({super.key});

  @override
  ConsumerState<MakeReportScreen> createState() => _MakeReportScreenState();
}

class _MakeReportScreenState extends ConsumerState<MakeReportScreen> {
  late TextEditingController reportFieldController;
  @override
  void initState() {
    setState(() {
      reportFieldController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    reportFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    return Scaffold(
      drawer: const DrawerContents(),
      appBar: customAppBar(context,
          title: "Report",
          hasElevation: true,
          scale: 1.25.sp, leading: Builder(builder: (context) {
        return Builder(builder: (context) {
          return InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const IconOf(Icons.menu, color: AppColors.primaryColor),
          );
        });
      }), hasIcon: true),
      body: Builder(builder: (context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (value) {
            Scaffold.of(context).openDrawer();
          },
          child: Padding(
            padding: appPadding().copyWith(bottom: 20.sp),
            child: Stack(alignment: Alignment.bottomCenter, children: [
              SizedBox.expand(
                  child: Column(children: [
                Row(children: [
                  Expanded(
                      child: TextOf(
                          "Do write to us on any issue you want to report. We would get back to you as soon as possible through your mail.",
                          16.sp,
                          4,
                          align: TextAlign.left))
                ]),
                YMargin(24.sp),
                InputField(
                  fieldController: reportFieldController,
                  hintText: "Write your report...",
                  maxLines: 4,
                ),
              ])),
              Button(
                text: "Send Report",
                buttonType: reportFieldController.text.isNotEmpty
                    ? ButtonType.blueBg
                    : ButtonType.disabled,
                onPressed: () {
                  ReviewsProvider.sendReportOrReviewToAdmin(context,
                          emailContent: reportFieldController.text,
                          messageType: "report")
                      .then((value) => reportFieldController.clear());
                },
              )
            ]),
          ),
        );
      }),
    );
  }
}
