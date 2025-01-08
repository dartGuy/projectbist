
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/main.dart';

import '../../core.dart';

class ResearchSuggestTopicPage extends ConsumerStatefulWidget {
  static const String researchSuggestTopicPage = 'researchSuggestTopicPage';
  const ResearchSuggestTopicPage({super.key});

  @override
  ConsumerState<ResearchSuggestTopicPage> createState() =>
      _ResearchSuggestTopicPageState();
}

class _ResearchSuggestTopicPageState
    extends ConsumerState<ResearchSuggestTopicPage> {
  late TextEditingController selectTopicTypeController,
      selectFacultyController,
      writeATopicController,
      selectDesciplineController,
      sectorController,
      professionalDivisionOptionListController;
  @override
  void initState() {
    setState(() {
      sectorController = TextEditingController();
      selectTopicTypeController = TextEditingController();
      selectFacultyController = TextEditingController();
      writeATopicController = TextEditingController();
      selectDesciplineController = TextEditingController();
      professionalDivisionOptionListController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    selectTopicTypeController.dispose();
    selectFacultyController.dispose();
    writeATopicController.dispose();
    selectDesciplineController.dispose();
    sectorController.dispose();
    professionalDivisionOptionListController.dispose();
    super.dispose();
  }

  bool formIsValid() {
    return (selectTopicTypeController.text.isNotEmpty &&
        //  selectFacultyController.text.isNotEmpty &&
        writeATopicController.text.isNotEmpty);
  }

  List<String> sectorAndParastatalsOfExperienceOptionsList = [];
  List<String> professionalDivisionOptionList = [];
  List<String> selectFacultyOptionList = [];
  List<String> selectDepartmentOptionList = [];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    return Scaffold(
      appBar: customAppBar(context, title: "Suggest Topic", hasElevation: true,
          leading: Builder(builder: (context) {
        return InkWell(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const IconOf(Icons.menu, color: AppColors.primaryColor),
        );
      }), hasIcon: true, scale: 1.25.sp),
      drawer: const DrawerContents(),
      body: Builder(builder: (context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (_) {
            Scaffold.of(context).openDrawer();
          },
          child: Padding(
            padding: appPadding().copyWith(bottom: 20.sp),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox.expand(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: TextOf(
                              "Get more jobs through your rich research topic. Interested clients can contact you through topics submitted to the market place.",
                              16,
                              4,
                              align: TextAlign.left,
                            ))
                          ],
                        ),
                        YMargin(24.sp),
                        InputFieldDialog(
                          fieldController: selectTopicTypeController,
                          hintText: "Select topic type",
                          fieldTitle: "Topic type",
                          optionList: const [
                            "Student",
                            "Professional",
                          ],
                          onChanged: () {
                            setState(() {
                              selectFacultyController.clear();
                              sectorController.clear();
                              selectDesciplineController.clear();
                              professionalDivisionOptionListController.clear();
                            });
                          },
                        ),
                        YMargin(16.sp),
                        selectTopicTypeController.text.toLowerCase() ==
                                "professional"
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InputFieldDialog(
                                    fieldController: sectorController,
                                    hintText: "Select Sector",
                                    fieldTitle: "Sector",
                                    optionList:
                                        sectorAndParastatalsOfExperienceOptionsList,
                                    beforeOpenDialog: () {
                                      setState(() {
                                        SectorAndDivisionProvider.fetchSectors()
                                            .then(
                                          (value) {
                                            sectorAndParastatalsOfExperienceOptionsList =
                                                value;
                                          },
                                        );
                                      });
                                    },
                                  ),
                                  YMargin(16.sp),
                                  InputFieldDialog(
                                    fieldController:
                                        professionalDivisionOptionListController,
                                    hintText: "Division",
                                    fieldTitle: "Division",
                                    optionList: professionalDivisionOptionList,
                                    beforeOpenDialog: () {
                                      setState(() {
                                        SectorAndDivisionProvider
                                            .fetchDivisions(
                                          sectorController.text,
                                        ).then(
                                          (value) => {
                                            professionalDivisionOptionList =
                                                value,
                                          },
                                        );
                                      });
                                    },
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InputFieldDialog(
                                    fieldController: selectFacultyController,
                                    hintText: "Select faculty",
                                    fieldTitle: "Faculty",
                                    optionList: selectFacultyOptionList,
                                    beforeOpenDialog: () {
                                      setState(() {
                                        FacultyAndDepartmentProvider
                                                .fetchFaculties()
                                            .then(
                                          (value) => {
                                            selectFacultyOptionList = value,
                                          },
                                        );
                                      });
                                    },
                                  ),
                                  YMargin(16.sp),
                                  InputFieldDialog(
                                    fieldController: selectDesciplineController,
                                    hintText: "Select discipline",
                                    fieldTitle: "Discipline",
                                    optionList: selectDepartmentOptionList,
                                    beforeOpenDialog: () {
                                      setState(() {
                                        FacultyAndDepartmentProvider
                                                .fetchDepartments(
                                                    selectFacultyController
                                                        .text)
                                            .then(
                                          (value) => {
                                            selectDepartmentOptionList = value,
                                          },
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                        YMargin(16.sp),
                        InputField(
                          fieldController: writeATopicController,
                          fieldTitle: "Write Topic",
                          hintText: "Type the topic here",
                          maxLines: 3,
                        ),
                        YMargin(0.1.sh)
                      ],
                    ),
                  ),
                ),
                Button(
                    text: "Submit",
                    onPressed: () {
                      TopicsProvider.suggestTopic(context, ref,
                          type: "${selectTopicTypeController.text} Thesis",
                          faculty: selectFacultyController.text,
                          discipline: selectDesciplineController.text,
                          topic: writeATopicController.text);
                    },
                    buttonType:
                        formIsValid() ? ButtonType.blueBg : ButtonType.disabled)
              ],
            ),
          ),
        );
      }),
    );
  }
}
