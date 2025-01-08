// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class FilterPublicationsSheetBody extends StatefulWidget {
  FilterPublicationsSheetBody({this.onTapFilter, super.key});
  VoidCallback? onTapFilter;
  @override
  _FilterPublicationsSheetBodyState createState() =>
      _FilterPublicationsSheetBodyState();
}

class _FilterPublicationsSheetBodyState
    extends State<FilterPublicationsSheetBody> {
  String selectedPublicationType = "",
      groupValue = "",
      student = "Student",
      professional = "Professional ";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextOf("Filter Publication Type", 20, 6),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const IconOf(Icons.close))
            ],
          ),
          YMargin(24.sp),
          ...[
            Radio(
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              focusColor: AppColors.primaryColor,
              fillColor:
                  const WidgetStatePropertyAll<Color>(AppColors.primaryColor),
              value: student,
              groupValue: groupValue,
              onChanged: (e) {
                setState(() {
                  groupValue = e!;
                });
              },
            ),
            Radio(
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              focusColor: AppColors.primaryColor,
              fillColor:
                  const WidgetStatePropertyAll<Color>(AppColors.primaryColor),
              value: professional,
              groupValue: groupValue,
              onChanged: (e) {
                setState(() {
                  groupValue = e!;
                });
              },
            )
          ].map((e) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 14,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      groupValue = e.value;
                                    });
                                  },
                                  child: TextOf(e.value, 16, 4)),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [e]))
                    ],
                  ),
                  YMargin(25.sp),
                ],
              ))

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     TextOf("Student", 16, 4),
          //     Radio(
          //       visualDensity: const VisualDensity(
          //           horizontal: VisualDensity.minimumDensity,
          //           vertical: VisualDensity.minimumDensity),
          //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //       focusColor: AppColors.primaryColor,
          //       fillColor: const MaterialStatePropertyAll<Color>(
          //           AppColors.primaryColor),
          //       value: student,
          //       groupValue: groupValue,
          //       onChanged: (e) {
          //         setState(() {
          //           groupValue = e!;
          //         });
          //       },
          //     )
          //   ],
          // ),
          // YMargin(25.sp),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     TextOf("Professional", 16, 4),
          //     Radio(
          //       visualDensity: const VisualDensity(
          //           horizontal: VisualDensity.minimumDensity,
          //           vertical: VisualDensity.minimumDensity),
          //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //       focusColor: AppColors.primaryColor,
          //       fillColor: const MaterialStatePropertyAll<Color>(
          //           AppColors.primaryColor),
          //       value: professional,
          //       groupValue: groupValue,
          //       onChanged: (e) {
          //         setState(() {
          //           groupValue = e!;
          //         });
          //       },
          //     )
          //   ],
          // ),
          ,
          YMargin(5.sp),
          Button(
            text: "Filter",
            buttonType: ButtonType.blueBg,
            onPressed: () {
              widget.onTapFilter == null ? () {} : widget.onTapFilter!();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
