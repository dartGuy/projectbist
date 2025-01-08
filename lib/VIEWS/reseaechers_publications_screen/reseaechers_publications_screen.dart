import 'package:flutter/material.dart';
import 'package:project_bist/CORE/app_objects.dart';
import 'package:project_bist/MODELS/publication_models/publicaiton_model.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/publications_two_item.dart';
import 'package:project_bist/main.dart';

class ResearchersPublicationsScreen extends StatelessWidget {
  static const String researchersPublicationsScreen =
      "researchersPublicationsScreen";
  const ResearchersPublicationsScreen(
      {required this.publicationsList, super.key});
  final PublicationsList publicationsList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: "Publications by Researcher",
          hasIcon: true,
          hasElevation: true),
      body: SingleChildScrollView(
        padding: appPadding(),
        child: Column(
          children: List.generate(publicationsList.length, (index) {
            PublicationModel publicationModel = publicationsList[index];
            return PublicationsTwoItem(
              publicationList: publicationsList,
              publication: publicationModel,
              hasDivider: index != (publicationsList.length - 1),
            );
          }),
        ),
      ),
    );
  }
}
