
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/PROVIDERS/publications_providers/publications_providers.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/PROVIDERS/cloudinary_upload/cloudinary_upload.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/VIEWS/all_nav_screens/_all_nav_screens/all_nav_screens.dart.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/VIEWS/originality_test_flow/ai_detection_tab.dart';
import 'package:project_bist/VIEWS/originality_test_flow/palgarism_tab.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/drawer_contents.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/type_message_input_field.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/main.dart';

class OriginalityTestFlow extends ConsumerStatefulWidget {
  static const String originalityTestFlow = 'originalityTestFlow';
  const OriginalityTestFlow({super.key});

  @override
  ConsumerState<OriginalityTestFlow> createState() =>
      _OriginalityTestFlowState();
}

class _OriginalityTestFlowState extends ConsumerState<OriginalityTestFlow>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController messageInputController,
      messageInputAiDetectionController;

  String attachmentFile = "", attachmentFileFromCloudinary = "";

  @override
  void initState() {
    setState(() {
      _tabController = TabController(length: 2, vsync: this);
      messageInputController = TextEditingController();
      messageInputAiDetectionController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    messageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String inputText = "";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {});
      }
    });
    return Scaffold(
      drawer: const DrawerContents(),
      appBar: customAppBar(
        context,
        hasIcon: true,
        title: "Originality Test",
        scale: 1.25.sp,
        leading: Builder(builder: (context) {
          return InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const IconOf(Icons.menu, color: AppColors.primaryColor),
          );
        }),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.sp),
            child: InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, AllNavScreens.allNavScreens, (route) => false,
                    arguments:
                        ref.watch(switchUserProvider) == UserTypes.researcher
                            ? 1
                            : 2);
              },
              child: ImageIcon(
                AssetImage(
                  ImageOf.notificationNav,
                ),
                color: AppThemeNotifier.colorScheme(context).primary,
                size: 20.sp,
              ),
            ),
          )
        ],
        tabBar: TabBar(
            controller: _tabController,
            physics: const ClampingScrollPhysics(),
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: const EdgeInsets.all(0),
            indicatorPadding: const EdgeInsets.all(0),
            labelColor: AppThemeNotifier.colorScheme(context).primary,
            labelStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            unselectedLabelColor: AppThemeNotifier.colorScheme(context).primary,
            padding: const EdgeInsets.all(0),
            tabs: [
              "Plagiarism",
              "AI Detection",
            ]
                .map((e) => Tab(
                      height: 30.sp,
                      text: e,
                    ))
                .toList()),
      ),
      body: Builder(builder: (context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (value) {
            Scaffold.of(context).openDrawer();
          },
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 2.sp),
                  padding:
                      EdgeInsets.symmetric(vertical: 6.sp, horizontal: 10.sp),
                  color: AppColors.brown,
                  child: Center(
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white),
                              text: "Recommended for all documents: ",
                              children: [
                        TextSpan(
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white),
                            text: _tabController.index == 0
                                ? "20% Plagiarism"
                                : "15% AI")
                      ])))),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox.expand(
                        child: TabBarView(
                            controller: _tabController,
                            children: const [
                          PlagarismTab(),
                          AiDetectionTab()
                        ])),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _tabController.index == 0
                            ? TypeMessageInputField(
                                autofocus: false,
                                hasSuffix: false,
                                readOnly: true,
                                suffixIconConstraints:
                                    BoxConstraints(maxWidth: 80.sp),
                                sendEnabled:
                                    messageInputController.text.isNotEmpty,
                                suffixIcon: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    messageInputController.text.isNotEmpty
                                        ? InkWell(
                                            onTap: () {
                                              messageInputController.clear();
                                              setState(() {});
                                            },
                                            child: IconOf(Icons.close,
                                                color: isDarkTheme(context)
                                                    ? AppColors.grey2
                                                    : AppColors.grey4))
                                        : const SizedBox.shrink(),
                                    XMargin(10.sp),
                                    InkWell(
                                      onTap: () {
                                        getIt<AppModel>().uploadFile(context,
                                            allowedExtensions: [
                                              "docx",
                                              "pdf",
                                              "txt",
                                              "pptx"
                                            ]).then((value) {
                                          // setState(() {
                                          attachmentFile = value!.path;
                                          messageInputController.text =
                                              attachmentFile.split("/").last;
                                          setState(() {});
                                        });
                                      },
                                      child: ImageIcon(
                                        AssetImage(ImageOf.fileAttachmnentIcon),
                                        color: isDarkTheme(context)
                                            ? AppColors.grey1
                                            : AppColors.grey3,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  if (!attachmentFileFromCloudinary
                                      .contains("http")) {
                                    UploadToCloudinaryProvider.uploadDocument(
                                            context,
                                            localFilePath: attachmentFile,
                                            loadingMessage:
                                                "Processing uploaded document...")
                                        .then((value) {
                                      setState(() {
                                        attachmentFileFromCloudinary = value;
                                      });
                                      if (attachmentFileFromCloudinary
                                          .isNotEmpty) {
                                        PublicationsAndPlagiarismCheckProvider
                                            .plagiarismCheck(context,
                                                uploadedFileURL:
                                                    attachmentFileFromCloudinary);
                                      }
                                    });
                                  } else {
                                    PublicationsAndPlagiarismCheckProvider
                                        .plagiarismCheck(context,
                                            uploadedFileURL:
                                                attachmentFileFromCloudinary);
                                  }
                                  messageInputController.clear();
                                },
                                hintText: "Click to upload file",
                                messageInputController: messageInputController,
                              )
                            : TypeMessageInputField(
                                autofocus: false,
                                hasSuffix: false,
                                // readOnly: true,
                                suffixIconConstraints:
                                    BoxConstraints(maxWidth: 80.sp),
                                sendEnabled: messageInputAiDetectionController
                                    .text.isNotEmpty,
                                suffixIcon: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // InkWell(
                                    //     onTap: () {
                                    //       messageInputAiDetectionController.clear();
                                    //       setState(() {});
                                    //     },
                                    //     child: IconOf(Icons.edit_outlined,
                                    //         color: isDarkTheme(context)
                                    //             ? AppColors.grey2
                                    //             : AppColors.grey4))
                                  ],
                                ),
                                onTap: () async {
                                  //ai-content/check
                                  PublicationsAndPlagiarismCheckProvider
                                      .aiContentCheck(context,
                                          text:
                                              messageInputAiDetectionController
                                                  .text);
                                  messageInputAiDetectionController.clear();
                                },
                                hintText: "Enter or paste your text here",
                                messageInputController:
                                    messageInputAiDetectionController,
                              )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
