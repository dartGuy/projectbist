import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/PROVIDERS/cloudinary_upload/cloudinary_upload.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/MODELS/publication_models/publication_draft.dart';
import 'package:project_bist/PROVIDERS/publications_providers/publications_providers.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/input_field_dialog.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/main.dart';

class ResearchPublishPaperScreen extends ConsumerStatefulWidget {
  static const String researchPublishPaperScreen = 'researchPublishPaperScreen';
  ResearchPublishPaperScreen({this.publicationDraft, super.key});
  PublicationDraft? publicationDraft;
  @override
  ConsumerState<ResearchPublishPaperScreen> createState() =>
      _ResearchPublishPaperScreenState();
}

class _ResearchPublishPaperScreenState
    extends ConsumerState<ResearchPublishPaperScreen> {
  late TextEditingController paperTitleController,
      selectPaperTypeController,
      copyAndPasteAbstractTextFieldController,
      attachFileController,
      associatedKeywordsController,
      doYouHaveCoWorkersController,
      numberOfReferencesController,
      addNamesOfCoWorkers,
      priceController,
      visibilityController;

  String attachmentFile = '';
  @override
  void initState() {
    setState(() {
      paperTitleController =
          TextEditingController(text: widget.publicationDraft?.title);
      selectPaperTypeController =
          TextEditingController(text: widget.publicationDraft?.type);
      attachFileController =
          TextEditingController(text: widget.publicationDraft?.attachmentFile);
      copyAndPasteAbstractTextFieldController = TextEditingController(
          text: widget.publicationDraft?.abstractText.split("/").last);
      associatedKeywordsController = TextEditingController(
          text: widget.publicationDraft?.tags
              .map((e) => "$e, ")
              .toList()
              .reduce((a, b) => a + b));
      doYouHaveCoWorkersController = TextEditingController(
          text: widget.publicationDraft?.doYouHaveCoWorkers);
      numberOfReferencesController = TextEditingController(
          text: widget.publicationDraft?.numOfRef.toString());
      addNamesOfCoWorkers = TextEditingController(
          text: widget.publicationDraft?.owners
              .map((e) => "$e, ")
              .toList()
              .reduce((a, b) => a + b));
      priceController = TextEditingController(
          text: widget.publicationDraft?.price.toString());
      visibilityController = TextEditingController();
    });
    setState(() {
      attachmentFile = attachFileController.text;
      attachFileController.text =
          attachFileController.text.split("/").toList().last;
    });

    super.initState();
  }

  @override
  void dispose() {
    paperTitleController.dispose();
    selectPaperTypeController.dispose();
    copyAndPasteAbstractTextFieldController.dispose();
    attachFileController.dispose();
    associatedKeywordsController.dispose();
    doYouHaveCoWorkersController.dispose();
    numberOfReferencesController.dispose();
    addNamesOfCoWorkers.dispose();
    priceController.dispose();
    visibilityController.dispose();
    super.dispose();
  }

  bool formIsValid() {
    return (paperTitleController.text.isNotEmpty &&
        selectPaperTypeController.text.isNotEmpty &&
        copyAndPasteAbstractTextFieldController.text.isNotEmpty &&
        attachFileController.text.isNotEmpty &&
        associatedKeywordsController.text.isNotEmpty &&
        numberOfReferencesController.text.isNotEmpty &&
        priceController.text.isNotEmpty);
  }

  File? upload;

  String attachmentFileFromCloudinary = "_";
  @override
  Widget build(BuildContext context) {
    List<String> coOwnersList = (!addNamesOfCoWorkers.text.contains(",")
        ? <String>[addNamesOfCoWorkers.text]
        : addNamesOfCoWorkers.text
            .split(",")
            .map((e) => e.trim())
            .toList()
            .where((e) => e.isNotEmpty)
            .toList());
    List<String> paperTagsList =
        (!associatedKeywordsController.text.contains(",")
            ? <String>[associatedKeywordsController.text]
            : associatedKeywordsController.text
                .split(",")
                .map((e) => e.trim())
                .toList()
                .where((e) => e.isNotEmpty)
                .toList());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
    return Scaffold(
      appBar: customAppBar(context,
          title: "Publish your paper", hasIcon: true, hasElevation: true),
      body: ValueListenableBuilder(
          valueListenable:
              Hive.box<PublicationDraft>(AppConst.PUBLICATION_DRAFT_KEY)
                  .listenable(),
          builder: (context, Box<PublicationDraft> box, _) {
            return SingleChildScrollView(
              padding: appPadding(),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        ImageOf.researcher,
                        height: 100.sp,
                        width: 119.sp,
                      ),
                    ],
                  ),
                  YMargin(40.sp),
                  InputField(
                      hintText: "Enter title here",
                      fieldTitle: "Paper title",
                      fieldController: paperTitleController),
                  YMargin(16.sp),
                  InputFieldDialog(
                      fieldController: selectPaperTypeController,
                      hintText: "Select paper type",
                      fieldTitle: "Paper type",
                      optionList: const [
                        "Student Thesis",
                        "Professional Thesis"
                      ]),
                  YMargin(16.sp),
                  InputField(
                      hintText: "Copy & paste your abstract here",
                      fieldTitle: "Abstract",
                      maxLines:
                          copyAndPasteAbstractTextFieldController.text.length >
                                  249
                              ? 10
                              : 4,
                      // maxLength: 500,
                      // showWordCount: true,
                      onChanged: (value) {
                        print("ontapp");
                        print(copyAndPasteAbstractTextFieldController.text
                            .split(" ")
                            .length);
                        print(copyAndPasteAbstractTextFieldController.text
                            .split(" "));

                        if (copyAndPasteAbstractTextFieldController.text
                                    .split(" ")
                                    .length >=
                                501 &&
                            copyAndPasteAbstractTextFieldController.text
                                        .split(" ")[
                                    copyAndPasteAbstractTextFieldController
                                            .text.length -
                                        1] ==
                                " ") {
                          //print("lllllllllllor");
                          setState(() {
                            copyAndPasteAbstractTextFieldController.text =
                                copyAndPasteAbstractTextFieldController.text
                                    .substring(
                                        0,
                                        copyAndPasteAbstractTextFieldController
                                                .text.length -
                                            1);
                          });
                        }
                      },
                      fieldController: copyAndPasteAbstractTextFieldController),
                  YMargin(4.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextOf(
                        "${copyAndPasteAbstractTextFieldController.text.isEmpty ? 0 : copyAndPasteAbstractTextFieldController.text.split(" ").length}/${500} words",
                        14.sp,
                        4,
                        color:
                            AppThemeNotifier.colorScheme(context).onSecondary,
                      )
                    ],
                  ),
                  YMargin(16.sp),
                  InputField(
                      fieldTitle: "Attach paper file",
                      onTap: () {
                        getIt<AppModel>().uploadFile(context,
                            allowedExtensions: [
                              "docx",
                              "pdf",
                              "txt",
                              "pptx",
                              "jpg"
                            ]).then((value) {
                          setState(() {
                            upload = value;
                            attachmentFile = upload!.path;
                            attachFileController.text =
                                attachmentFile.split("/").last;
                          });
                        });
                      },
                      hintText: "Attach a file here",
                      inputType: TextInputType.none,
                      showCursor: false,
                      suffixIcon: Image.asset(
                        ImageOf.fileAttachmnentIcon,
                        height: 75.sp,
                      ),
                      fieldController: attachFileController),
                  YMargin(16.sp),
                  InputField(
                      fieldTitle:
                          "Paper tags ${associatedKeywordsController.text.isEmpty ? "" : paperTagsList.isEmpty ? "" : "(${paperTagsList.length.toString()})"}",
                      hintText: "Enter at least 3 associated keywords",
                      fieldController: associatedKeywordsController),
                  paperTagsList.length < 2
                      ? Column(
                          children: [
                            YMargin(5.sp),
                            Row(
                              children: [
                                TextOf(
                                    "Paper tags should be separated by comma",
                                    10.sp,
                                    4),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  YMargin(16.sp),
                  InputFieldDialog(
                      fieldController: doYouHaveCoWorkersController,
                      hintText: "Select an option",
                      fieldTitle: "Do you have Co-owners?",
                      optionList: const ["Yes", "No"]),
                  doYouHaveCoWorkersController.text.toLowerCase() != "yes"
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            YMargin(16.sp),
                            InputField(
                                fieldTitle:
                                    "Co-owners ${addNamesOfCoWorkers.text.isEmpty ? "" : coOwnersList.isEmpty ? "" : "(${coOwnersList.length.toString()})"}",
                                hintText: "Add their names to the publication",
                                fieldController: addNamesOfCoWorkers),
                          ],
                        ),
                  (coOwnersList.length < 2 &&
                          doYouHaveCoWorkersController.text.toLowerCase() ==
                              "yes")
                      ? Column(
                          children: [
                            YMargin(5.sp),
                            Row(
                              children: [
                                TextOf(
                                    "Co-owner names should be separated by comma",
                                    10.sp,
                                    4),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  Column(
                    children: [
                      YMargin(16.sp),
                      InputField(
                          fieldTitle: "Number of References",
                          hintText: "0",
                          inputType: TextInputType.number,
                          fieldController: numberOfReferencesController),
                    ],
                  ),
                  // YMargin(16.sp),
                  // InputFieldDialog(
                  //     fieldController: visibilityController,
                  //     hintText: "Private",
                  //     fieldTitle: "Visibility",
                  //     optionList: const ["Everyone", "Private"]),
                  YMargin(16.sp),
                  InputField(
                      fieldTitle: "Price",
                      inputType: TextInputType.number,
                      prefixIcon: TextOf(AppConst.COUNTRY_CURRENCY, 16.sp,
                          priceController.text.isEmpty ? 4 : 5),
                      fieldController: priceController),
                  YMargin(24.sp),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppThemeNotifier.colorScheme(context)
                                  .onSecondary),
                          text: "NOTE: ",
                          children: [
                        TextSpan(
                            text:
                                "${AppConst.APP_NAME} charges 10% commission on publications and 5% for originality-test fee")
                      ])),
                  YMargin(32.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 10,
                          child: Button(
                            text: "Publish",
                            onPressed: () {
                              if (!attachmentFileFromCloudinary
                                  .contains("http") && attachmentFileFromCloudinary.isNotEmpty) {
                                UploadToCloudinaryProvider.uploadDocument(
                                        context,
                                        localFilePath: attachmentFile,
                                        loadingMessage:
                                            "Processing uploaded document...")
                                    .then((value) {
                                  setState(() {
                                    attachmentFileFromCloudinary = value;
                                  });
                                  PublicationsAndPlagiarismCheckProvider
                                        .researcherCreatePublication(
                                      ref: ref,
                                      context,
                                      title: paperTitleController.text,
                                      paperType: selectPaperTypeController.text,
                                      abstractText:
                                          copyAndPasteAbstractTextFieldController
                                              .text,
                                      attachmentFile:
                                          attachmentFileFromCloudinary,
                                      paperTags: paperTagsList,
                                      owners: coOwnersList,
                                      numOfRef: int.tryParse(
                                              numberOfReferencesController
                                                  .text) ??
                                          0,
                                      price:
                                          int.tryParse(priceController.text) ??
                                              0,
                                    );
                                });
                              } else {
                                print(
                                    "attachmentFileFromCloudinary: $attachmentFileFromCloudinary");
                                PublicationsAndPlagiarismCheckProvider
                                    .researcherCreatePublication(
                                  ref: ref,
                                  context,
                                  title: paperTitleController.text,
                                  paperType: selectPaperTypeController.text,
                                  abstractText:
                                      copyAndPasteAbstractTextFieldController
                                          .text,
                                  attachmentFile: attachmentFileFromCloudinary,
                                  paperTags: paperTagsList,
                                  owners: coOwnersList,
                                  numOfRef: int.tryParse(
                                          numberOfReferencesController.text) ??
                                      0,
                                  price:
                                      int.tryParse(priceController.text) ?? 0,
                                );
                              }
                            },
                            buttonType: ButtonType.blueBg,
                            // formIsValid()
                            //     ? ButtonType.blueBg
                            //     : ButtonType.disabled
                          )),
                      const Expanded(flex: 1, child: SizedBox.shrink()),
                      Expanded(
                          flex: 10,
                          child: Button(
                            text: "Save as draft",
                            onPressed: () {
                              print(box.length);

                              PublicationsAndPlagiarismCheckProvider.addToDraft(
                                  context,
                                  box: box,
                                  publicationDraft: PublicationDraft(
                                      type: selectPaperTypeController.text,
                                      currency: 'NGN',
                                      title: paperTitleController.text,
                                      abstractText:
                                          copyAndPasteAbstractTextFieldController
                                              .text,
                                      numOfRef: int.tryParse(
                                              numberOfReferencesController
                                                  .text) ??
                                          0,
                                      price:
                                          (int.tryParse(priceController.text) ??
                                                  0)
                                              .toDouble(),
                                      tags: paperTagsList,
                                      owners: coOwnersList,
                                      attachmentFile: attachmentFile,
                                      doYouHaveCoWorkers:
                                          doYouHaveCoWorkersController.text));
                            },
                            buttonType: ButtonType.whiteBg,
                          ))
                    ],
                  ),
                  YMargin(24.sp),
                ],
              ),
            );
          }),
    );
  }
}
