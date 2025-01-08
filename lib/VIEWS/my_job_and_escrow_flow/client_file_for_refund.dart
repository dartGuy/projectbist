import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/HELPERS/alert_dialog.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/widgets/texts.dart';

class ClientFileForRefund extends StatefulWidget {
  static const String clientFileForRefund = "clientFileForRefund";
  const ClientFileForRefund({super.key});

  @override
  State<ClientFileForRefund> createState() => _ClientFileForRefundState();
}

class _ClientFileForRefundState extends State<ClientFileForRefund> {
  late TextEditingController reasonFilingForRefundController;
  @override
  void initState() {
    setState(() {
      reasonFilingForRefundController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    reasonFilingForRefundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: "File for a Refund", hasElevation: true, hasIcon: true),
      body: SingleChildScrollView(
        padding: appPadding(),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextOf(
                    "Tell us why you want to file for a refund.",
                    16.sp,
                    5,
                    align: TextAlign.left,
                  ),
                )
              ],
            ),
            YMargin(24.sp),
            InputField(
              fieldController: reasonFilingForRefundController,
              hintText: "Write your reason here...",
              maxLines: 4,
            ),
            YMargin(32.sp),
            Button(
              text: "File for a Refund",
              onPressed: () {
                Alerts.infoDialog(context,
                    title: "Support Request Submitted",
                    subtitle:
                        "Your request to “File for a refund” has been submitted successfully. We will get back to you as soon as possible.");
              },
              buttonType: ButtonType.blueBg,
            )
          ],
        ),
      ),
    );
  }
}
