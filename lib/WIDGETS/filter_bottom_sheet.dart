// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/check_box_input_getter.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/texts.dart';

class FilterTopicSheetBody extends ConsumerStatefulWidget {
  FilterTopicSheetBody(
      {this.onTapFilter,
      required this.onSelectedDateItemClicked,
      required this.onSelectedSectorOrFacultyItemClicked,
      required this.onSelectedDivisionItemClicked,
      required this.onSelectedPaperTypeItemClicked,
      this.userType,
      super.key});
  VoidCallback? onTapFilter;
  UserTypes? userType;
  Function(String)? onSelectedDateItemClicked,
      onSelectedDivisionItemClicked,
      onSelectedSectorOrFacultyItemClicked,
      onSelectedPaperTypeItemClicked;
  @override
  _FilterJobsSheetBodyState createState() => _FilterJobsSheetBodyState();
}

class _FilterJobsSheetBodyState extends ConsumerState<FilterTopicSheetBody> {
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
              TextOf("Filter", 20, 6),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: IconOf(
                    Icons.close,
                    color: AppThemeNotifier.colorScheme(context).primary,
                  ))
            ],
          ),
          ExpansionTile(
            title: Row(
              children: [
                TextOf("By Date", 16, 5),
              ],
            ),
            collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            collapsedIconColor: AppThemeNotifier.colorScheme(context).primary,
            iconColor: AppThemeNotifier.colorScheme(context).primary,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            children: [
              CheckboxOptionsInputGetter(
                  onItemClicked: widget.onSelectedDateItemClicked,
                  availableOptionsList: const [
                    "Last 24 hours",
                    "Last 14 hours",
                    "Last month"
                  ])
            ],
          ),
          ExpansionTile(
            collapsedIconColor: AppThemeNotifier.colorScheme(context).primary,
            iconColor: AppThemeNotifier.colorScheme(context).primary,
            title: Row(
              children: [
                TextOf(
                    ref.watch(switchUserProvider) == UserTypes.student
                        ? "Faculty/Area of Expertise"
                        : "Sector/Parastatal",
                    16,
                    5),
              ],
            ),
            collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            children: [
              CheckboxOptionsInputGetter(
                  onItemClicked: widget.onSelectedSectorOrFacultyItemClicked,
                  availableOptionsList:
                      ref.watch(switchUserProvider) == UserTypes.student
                          ? const [
                              "Art",
                              "Commercial",
                              "Education",
                              "Science",
                            ]
                          : [
                              "Oil & Gas",
                              "Manufacturing",
                              "Finance",
                              "Banking",
                              "Education",
                              "Dental Sciences",
                              "Accounting and Management"
                            ])
            ],
          ),
          ExpansionTile(
            collapsedIconColor: AppThemeNotifier.colorScheme(context).primary,
            iconColor: AppThemeNotifier.colorScheme(context).primary,
            title: Row(
              children: [
                TextOf(
                    ref.watch(switchUserProvider) == UserTypes.student
                        ? "Discipline"
                        : "Division",
                    16,
                    5),
              ],
            ),
            collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            children: [
              CheckboxOptionsInputGetter(
                  onItemClicked: widget.onSelectedDivisionItemClicked,
                  availableOptionsList:
                      ref.watch(switchUserProvider) == UserTypes.student
                          ? const [
                              "Biochemistry",
                              "Agric Science",
                              "Law",
                              "Geography",
                              "Chemistry Education"
                            ]
                          : [
                              "FMCG",
                              "Agric Feeds",
                              "Law",
                              "Geography",
                              "Chemistry Education"
                            ])
            ],
          ),
          ref.watch(switchUserProvider) == UserTypes.researcher
              ? ExpansionTile(
                  collapsedIconColor:
                      AppThemeNotifier.colorScheme(context).primary,
                  iconColor: AppThemeNotifier.colorScheme(context).primary,
                  title: Row(
                    children: [
                      TextOf("Paper Type", 16, 5),
                    ],
                  ),
                  collapsedShape:
                      const RoundedRectangleBorder(side: BorderSide.none),
                  shape: const RoundedRectangleBorder(side: BorderSide.none),
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  children: [
                    CheckboxOptionsInputGetter(
                        onItemClicked: widget.onSelectedPaperTypeItemClicked,
                        availableOptionsList: const [
                          "Student Thesis",
                          "Professional Thesis"
                        ])
                  ],
                )
              : const SizedBox.shrink(),
          Button(
              text: "Filter",
              buttonType: ButtonType.blueBg,
              onPressed: widget.onTapFilter ??
                  () {
                    Navigator.pop(context);
                  })
        ],
      ),
    );
  }
}
