import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/VIEWS/reseaechers_publications_screen/reseaechers_publications_screen.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/publications_two_item.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';

Widget publicationsListSection(BuildContext context,
    {required PublicationsList publicationList, String? message}) {
  return Padding(
    padding: appPadding().copyWith(top: 8.sp),
    child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextOf("Publications", 14.sp, 4),
          publicationList.isEmpty
              ? const SizedBox.shrink()
              : Expanded(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context,
                              ResearchersPublicationsScreen
                                  .researchersPublicationsScreen,
                              arguments: publicationList);
                        },
                        child: TextOf(
                          "View all",
                          12,
                          4,
                          decoration: TextDecoration.underline,
                          color: AppColors.brown,
                        ),
                      ),
                      XMargin(5.sp),
                      IconOf(Icons.arrow_forward_ios_rounded,
                          color: AppColors.brown, size: 15.sp)
                    ],
                  )
                ]))
        ]),
        YMargin(16.sp),
        if (publicationList.isEmpty)
          SizedBox(
              width: 1.sw,
              height: 0.05.sh,
              child: Center(
                  child: TextOf(
                      message ?? "Publications are currently not available!",
                      16.sp,
                      5))),
        ...List.generate(publicationList.length, (index) {
          PublicationModel publication = publicationList[index];
          return PublicationsTwoItem(
              publication: publication,
              publicationList: publicationList,
              hasDivider: index != (publicationList.length - 1));
        })
      ],
    ),
  );
}
