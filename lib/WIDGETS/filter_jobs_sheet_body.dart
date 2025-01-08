// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/WIDGETS/check_box_input_getter.dart';

class FilterJobsSheetBody extends StatefulWidget {
  FilterJobsSheetBody({this.onTapFilter, super.key});
  VoidCallback? onTapFilter;
  @override
  // ignore: library_private_types_in_public_api
  _FilterJobsSheetBodyState createState() => _FilterJobsSheetBodyState();
}

class _FilterJobsSheetBodyState extends State<FilterJobsSheetBody> {
  String selectedJobType = '',
      selectedDateInterval = "",
      selectedInstitutionOrParastatal = "",
      selecteddivisionOrFaculty = "";

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
                  child: const IconOf(Icons.close))
            ],
          ),
          // YMargin(24.sp),
          ExpansionTile(
            title: Row(
              children: [
                TextOf("By Job Type", 16, 5),
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
                  onItemClicked: (e) {
                    setState(() {
                      selectedJobType = e;
                    });
                  },
                  availableOptionsList: const ["Student", "Professional"])
            ],
          ),

          ExpansionTile(
            collapsedIconColor: AppThemeNotifier.colorScheme(context).primary,
            iconColor: AppThemeNotifier.colorScheme(context).primary,
            title: Row(
              children: [
                TextOf("By Date", 16, 5),
              ],
            ),
            collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            children: [
              CheckboxOptionsInputGetter(
                  onItemClicked: (e) {
                    setState(() {
                      selectedDateInterval = e;
                    });
                  },
                  availableOptionsList: const [
                    "Last 24 hours",
                    "Last 14 days",
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
                    selectedJobType == "Professional"
                        ? "Sector/Parastatal"
                        : "Institution",
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
                  onItemClicked: (e) {
                    setState(() {
                      selectedInstitutionOrParastatal = e;
                    });
                  },
                  availableOptionsList: selectedJobType == "Professional"
                      ? ["Oil & Gas", "Manufacturing", "Science"]
                      : [
                          "Obafemi Awolowo University",
                          "University of Ibadan",
                          "University of Lagos"
                        ])
            ],
          ),

          ExpansionTile(
            collapsedIconColor: AppThemeNotifier.colorScheme(context).primary,
            iconColor: AppThemeNotifier.colorScheme(context).primary,
            title: Row(
              children: [
                TextOf(
                    selectedJobType == "Professional"
                        ? "Division"
                        : "Faculty/Area of Expertise",
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
                  onItemClicked: (e) {
                    setState(() {
                      selecteddivisionOrFaculty = e;
                    });
                  },
                  availableOptionsList: selectedJobType == "Professional"
                      ? ["FMCG", "Agric Feeds", "Law"]
                      : ["Art", "Commercial", "Science"])
            ],
          ),

          selectedJobType != "Professional"
              ? ExpansionTile(
                  collapsedIconColor:
                      AppThemeNotifier.colorScheme(context).primary,
                  iconColor: AppThemeNotifier.colorScheme(context).primary,
                  title: Row(
                    children: [
                      TextOf("Discipline", 16, 5),
                    ],
                  ),
                  collapsedShape:
                      const RoundedRectangleBorder(side: BorderSide.none),
                  shape: const RoundedRectangleBorder(side: BorderSide.none),
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  children: [
                    CheckboxOptionsInputGetter(
                        onItemClicked: (e) {
                          setState(() {
                            selecteddivisionOrFaculty = e;
                          });
                        },
                        availableOptionsList: const [
                          "Biochemistry",
                          "Agric Science",
                          "Law"
                        ])
                  ],
                )
              : const SizedBox.shrink(),

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
