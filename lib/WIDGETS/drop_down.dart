import 'package:flutter/material.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';

// ignore: must_be_immutable
class DropDownField extends StatefulWidget {
  DropDownField({
    required this.selectedValue,
    required this.fieldsOfStudy,
    required this.hintText,
    super.key,
  });
  final List<String>? fieldsOfStudy;
  String? selectedValue, hintText;
  @override
  State<DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  bool _showUnderline = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(
                color: widget.selectedValue != null
                    ? AppColors.primaryColor
                    : AppColors.grey4),
            borderRadius: BorderRadius.circular(12),
            color: widget.selectedValue != null
                ? AppColors.blue1
                : AppColors.white),
        child: Center(
          child: DropdownButton<String>(
            isExpanded: true,
            underline: const SizedBox.shrink(),
            value: widget.selectedValue,
            icon: const IconOf(Icons.expand_more),
            hint: TextOf(
              widget.hintText!,
              15,
              5,
              color: AppColors.grey4,
            ),
            onTap: () {
              setState(() {
                _showUnderline = true;
              });
            },
            onChanged: (e) {
              setState(() {
                widget.selectedValue = e;
              });
            },
            items: widget.fieldsOfStudy!
                .map((e) => DropdownMenuItem<String>(
                    alignment: Alignment.bottomCenter,
                    value: e,
                    onTap: () {
                      setState(() {
                        _showUnderline = false;
                      });
                    },
                    enabled: true,
                    child: Column(
                      mainAxisAlignment: (widget.selectedValue == null)
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        (widget.selectedValue == null)
                            ? const YMargin(3)
                            : const SizedBox.shrink(),
                        Row(
                          children: [
                            TextOf(
                              e,
                              16,
                              5,
                              color: AppColors.grey4,
                            ),
                          ],
                        ),
                        (widget.selectedValue == null)
                            ? const YMargin(2)
                            : const SizedBox.shrink(),
                        (widget.selectedValue == null)
                            ? const Divider(
                                color: AppColors.grey3,
                              )
                            : const SizedBox.shrink(),
                      ],
                    )))
                .toList(),
          ),
        ),
      ),
    );
  }
}
