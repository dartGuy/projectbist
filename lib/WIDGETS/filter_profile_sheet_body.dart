// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/check_box_input_getter.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/texts.dart';

class FilterProfilesSheetBody extends StatefulWidget {
  FilterProfilesSheetBody({this.onTapFilter, super.key});
  VoidCallback? onTapFilter;
  @override
  _FilterJobsSheetBodyState createState() => _FilterJobsSheetBodyState();
}

class _FilterJobsSheetBodyState extends State<FilterProfilesSheetBody> {
  String selectedSector = "", selectedDivision = '', selectedInstitution = '';
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
          ExpansionTile(
            collapsedIconColor: AppThemeNotifier.colorScheme(context).primary,
            iconColor: AppThemeNotifier.colorScheme(context).primary,
            title: Row(
              children: [
                TextOf("By Sector", 16, 5),
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
                      selectedSector = e;
                    });
                  },
                  availableOptionsList: const ["Oil & Gas", "Manufacturing"])
            ],
          ),
          ExpansionTile(
            collapsedIconColor: AppThemeNotifier.colorScheme(context).primary,
            iconColor: AppThemeNotifier.colorScheme(context).primary,
            title: Row(
              children: [
                TextOf("By Division ", 16, 5),
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
                      selectedDivision = e;
                    });
                  },
                  availableOptionsList: const [
                    "Upstream",
                    "Downstream",
                    "Mining & Refinery"
                  ])
            ],
          ),
          ExpansionTile(
            collapsedIconColor: AppThemeNotifier.colorScheme(context).primary,
            iconColor: AppThemeNotifier.colorScheme(context).primary,
            title: Row(
              children: [
                TextOf("By Institution ", 16, 5),
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
                      selectedInstitution = e;
                    });
                  },
                  availableOptionsList: const [
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
                TextOf("By Faculty/Area of Expertise", 16, 5),
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
                      selectedSector = e;
                    });
                  },
                  availableOptionsList: const ["Art", "Commercial", "Science"])
            ],
          ),
          ExpansionTile(
            collapsedIconColor: AppThemeNotifier.colorScheme(context).primary,
            iconColor: AppThemeNotifier.colorScheme(context).primary,
            title: Row(
              children: [
                TextOf("By Discipline", 16, 5),
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
                      selectedSector = e;
                    });
                  },
                  availableOptionsList: const [
                    "Biochemistry",
                    "Agric Science",
                    "Law"
                  ])
            ],
          ),
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
