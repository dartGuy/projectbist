import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/PROVIDERS/escrow_provider/escrow_provider.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/widgets/texts.dart';

class ClientPauseJob extends ConsumerStatefulWidget {
  static const String clientPauseJob = "clientPauseJob";
  final String jobId;
  const ClientPauseJob({required this.jobId, super.key});

  @override
  ConsumerState<ClientPauseJob> createState() => _ClientPauseJobState();
}

class _ClientPauseJobState extends ConsumerState<ClientPauseJob> {
  int selectedDay = 0;
  late TextEditingController tdDayController,
      tdMonthController,
      tdYearController;
  late TextEditingController reasonForPausingController;
  DateTime selectedTargetDate = DateTime.now();
  @override
  void initState() {
    setState(() {
      tdDayController = TextEditingController();
      tdMonthController = TextEditingController();
      tdYearController = TextEditingController();
      reasonForPausingController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    tdDayController.dispose();
    tdMonthController.dispose();
    tdYearController.dispose();
    reasonForPausingController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
  ) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedTargetDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedTargetDate) {
      tdDayController.clear();
      tdMonthController.clear();
      setState(() {
        tdDayController.text = picked.day.toString();
        tdMonthController.text = picked.month.toString();
        tdYearController.text = picked.year.toString();
      });
      if (int.parse(tdDayController.text) < 10) {
        setState(() {
          tdDayController.text = "0${tdDayController.text}";
        });
      }
      if (int.parse(tdMonthController.text) < 10) {
        setState(() {
          tdMonthController.text = "0${tdMonthController.text}";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: "Pause your Job", hasElevation: true, hasIcon: true),
      body: SingleChildScrollView(
        padding: appPadding(),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextOf(
                    "Tell us why you want to pause your job.",
                    16.sp,
                    5,
                    align: TextAlign.left,
                  ),
                )
              ],
            ),
            YMargin(24.sp),
            InputField(
              fieldController: reasonForPausingController,
              hintText: "Write your reason here...",
              maxLines: 4,
            ),
            YMargin(24.sp),
            Row(
              children: [TextOf("Period of Extension", 16.sp, 4)],
            ),
            YMargin(8.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: 0.2.sw,
                    child: InputField(
                      fieldController: tdDayController,
                      showCursor: false,
                      hintText: "dd",
                      onTap: () {
                        _selectDate(context);
                      },
                      readOnly: true,
                    )),
                XMargin(10.sp),
                SizedBox(
                    width: 0.2.sw,
                    child: InputField(
                      fieldController: tdMonthController,
                      showCursor: false,
                      readOnly: true,
                      hintText: "mm",
                      onTap: () {
                        _selectDate(context);
                      },
                    )),
                XMargin(10.sp),
                SizedBox(
                    width: 0.25.sw,
                    child: InputField(
                      fieldController: tdYearController,
                      hintText: "yyyy",
                      onTap: () {
                        _selectDate(context);
                      },
                      showCursor: false,
                      readOnly: true,
                    ))
              ],
            ),
            YMargin(16.sp),
            Row(
              children: [
                Expanded(
                    child: TextOf(
                  "You can only extend by 3 months maximum.",
                  16.sp,
                  4,
                  align: TextAlign.left,
                ))
              ],
            ),
            YMargin(32.sp),
            Button(
              text: "Pause your job",
              onPressed: () {
                EscrowProvider.clientPauseEscrowJob(context, ref,
                    jobId: widget.jobId,
                    pauseDeadline:
                        "${tdDayController.text}/${tdMonthController.text}/${tdYearController.text}",
                    pauseReason: reasonForPausingController.text);
              },
              buttonType: (reasonForPausingController.text.isNotEmpty &&
                      tdDayController.text.isNotEmpty &&
                      tdMonthController.text.isNotEmpty &&
                      tdYearController.text.isNotEmpty)
                  ? ButtonType.blueBg
                  : ButtonType.disabled,
            )
          ],
        ),
      ),
    );
  }
}
