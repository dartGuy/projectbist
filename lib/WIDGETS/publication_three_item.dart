// ignore_for_file: must_be_immutable

import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/PROVIDERS/publications_providers/publications_providers.dart';
import 'package:project_bist/VIEWS/publication_detail/view_publication_to_download.dart';
import 'package:project_bist/WIDGETS/components/app_components.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/THEMES/color_themes.dart';

class PublicationThreeItem extends StatefulWidget {
  PublicationThreeItem({
    required this.title,
    required this.subtitle,
    this.titleColor,
    this.routeName,
    this.backgroundColor,
    required this.ref,
    required this.index,
    required this.publicationId,
    this.onTriggered,
    this.arguments,
    super.key,
    this.width,
  });
  Color? titleColor, backgroundColor;
  double? width;
  void Function()? onTriggered;
  String? routeName;
  final String title, publicationId;
  final Widget subtitle;
  final WidgetRef ref;
  final int index;

  dynamic arguments;

  @override
  State<PublicationThreeItem> createState() => _PublicationThreeItemState();
}

class _PublicationThreeItemState extends State<PublicationThreeItem> {
  late ElTooltipController elTooltipController;
  @override
  void initState() {
    super.initState();
    elTooltipController = ElTooltipController();
  }

  @override
  void dispose() {
    elTooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10.r)),
        width: double.infinity,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              flex: 11,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                      context,
                      widget.routeName ??
                          ViewPublicationToDownload.viewPublicationToDownload,
                      arguments: widget.arguments);
                },
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextOf(widget.title, 16, 6,
                              color: widget.titleColor ?? AppColors.white,
                              align: TextAlign.left,
                              textOverflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                    YMargin(16.sp),
                    widget.subtitle
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: const IconOf(
                      Icons.more_vert_outlined,
                      color: AppColors.white,
                    ),
                    onTap: () {
                      AppComponents.confirmDeleteInListPopup(
                          context, widget.index, widget.ref,
                          popupTitle: "Delete publication",
                          deletionButtonText: "Delete This Publication",
                          textColor: AppColors.white,
                          backgroundColor: AppColors.red,
                          onPrimaryDeletePressed: () {
                        if (widget.onTriggered == null) {
                          Navigator.pop(context);
                          PublicationsAndPlagiarismCheckProvider
                              .deletePublication(context,
                                  publicationId: widget.publicationId,
                                  ref: widget.ref);
                        } else {
                          widget.onTriggered!();
                        }
                      },
                          deletionDescriptionText:
                              "Clicking the delete button will remove this publication from your list and the this can't be undone. So please, proceed with caution");
                    },
                  ),

                  // ElTooltip(
                  //   color: AppThemeNotifier.themeColor(context)
                  //       .scaffoldBackgroundColor,
                  //   controller: elTooltipController,
                  //   position: ElTooltipPosition.bottomCenter,
                  //   showArrow: true,
                  //   content: InkWell(

                  //       onTap: () async {
                  //         widget.onTriggered != null
                  //             ? await onTabTriggered()
                  //             : () {};
                  //       },
                  //       child: TextOf("Delete Job", 10.sp, 4)),
                  // child: const IconOf(
                  //   Icons.more_vert_outlined,
                  //   color: AppColors.white,
                  // ),
                  // ),
                ],
              ),
            ),
          ]),
        ]));
  }

  // Future onTabTriggered() async {
  //   await elTooltipController.hide();
  //   widget.onTriggered!();
  // }
}
