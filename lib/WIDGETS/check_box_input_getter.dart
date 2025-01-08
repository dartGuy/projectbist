// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';

class CheckboxOptionsInputGetter extends StatefulWidget {
  CheckboxOptionsInputGetter(
      {required this.onItemClicked,
      required this.availableOptionsList,
      super.key});
  Function(String)? onItemClicked;
  final List<String> availableOptionsList;
  @override
  State<CheckboxOptionsInputGetter> createState() =>
      _CheckboxOptionsInputGetterState();
}

class _CheckboxOptionsInputGetterState
    extends State<CheckboxOptionsInputGetter> {
  String selected = "";
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return Column(
      children: widget.availableOptionsList
          .map((e) => Column(
                children: [
                  InkWell(
                    onTap: () {
                      widget.onItemClicked!(e);
                      setState(() {
                        selected = e;
                      });
                    },
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage(
                            selected == e
                                ? ImageOf.selectedIcon
                                : ImageOf.unselectedIcon,
                          ),
                          size: selected == e ? 18.75.sp : 18.sp,
                          color: AppThemeNotifier.colorScheme(context).primary,
                        ),
                        XMargin(7.sp),
                        TextOf(e, 16, 4)
                      ],
                    ),
                  ),
                  YMargin(10.sp)
                ],
              ))
          .toList(),
    );
  }
}
