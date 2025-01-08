// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/CORE/app_models.dart';
import 'package:project_bist/MODELS/user_profile/user_profile.dart';
import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
import 'package:project_bist/PROVIDERS/profile_provider/profile_provider.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/UTILS/launch_url.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/UTILS/profile_image.dart';
import 'package:project_bist/VIEWS/account_flow/edit_profile.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/error_page.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/WIDGETS/input_field_dialog.dart';
import 'package:project_bist/WIDGETS/loading_indicator.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:project_bist/widgets/texts.dart';

class PreviewProfile extends ConsumerStatefulWidget {
  static const String previewProfile = "previewProfile";
  const PreviewProfile({super.key});
  @override
  _PreviewProfileState createState() => _PreviewProfileState();
}

class _PreviewProfileState extends ConsumerState<PreviewProfile> {
  final ScrollController _scrollController = ScrollController();
  File? imageFile;
  String? avatarUrlPath;
  bool showEmail = false;
  @override
  Widget build(BuildContext context) {
    ResponseStatus responseStatus = ref.watch(profileProvider);
    ref.watch(profileProvider.notifier).getRequest(
        context: context, url: Endpoints.GET_PROFILE, showLoading: false);
    getIt<AppModel>().userProfile = UserProfile.fromJson(responseStatus.data);
    UserProfile userProfile = getIt<AppModel>().userProfile!;
    return Scaffold(
      appBar: customAppBar(context,
          title: "Profile", hasIcon: true, hasElevation: true),
      body: Center(
        child: switch (responseStatus.responseState!) {
          ResponseState.LOADING =>
            LoadingIndicator(message: "Getting your profile..."),
          ResponseState.ERROR => ErrorPage(
              message: responseStatus.message!,
              onPressed: () {
                ref.watch(profileProvider.notifier).getRequest(
                    context: context,
                    url: Endpoints.GET_PROFILE,
                    inErrorCase: true);
              },
            ),
          ResponseState.DATA => SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: appPadding(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildProfileImage(
                          imageUrl: userProfile.avatar!,
                          radius: 100.sp,
                          fontSize: 40.sp,
                          fullNameTobSplit: userProfile.fullName!,
                        )
                      ],
                    ),
                    YMargin(32.sp),
                    Row(
                      children: [
                        TextOf("Basic Information", 18.sp, 6),
                      ],
                    ),
                    YMargin(16.sp),
                    InputField(
                      fieldTitle: "Full name",
                      suffixIcon: const SizedBox.shrink(),
                      fieldGroupColors: AppColors.grey2,
                      fieldController:
                          TextEditingController(text: userProfile.fullName!),
                      readOnly: true,
                      showCursor: false,
                    ),
                    YMargin(16.sp),
                    InputField(
                      fieldTitle: "Username",
                      hintText: "",
                      suffixIcon: const SizedBox.shrink(),
                      readOnly: true,
                      showCursor: false,
                      fieldController:
                          TextEditingController(text: userProfile.username!),
                    ),
                    YMargin(16.sp),
                    InputField(
                      fieldTitle: "Phone number",
                      readOnly: true,
                      showCursor: false,
                      suffixIcon: const SizedBox.shrink(),
                      inputType: TextInputType.phone,
                      fieldController:
                          TextEditingController(text: userProfile.phoneNumber!),
                    ),
                    YMargin(16.sp),
                    ref.watch(switchUserProvider) == UserTypes.student
                        ? Column(
                            children: [
                              InputField(
                                fieldTitle: "Student Type",
                                readOnly: true,
                                showCursor: false,
                                suffixIcon: const SizedBox.shrink(),
                                fieldController: TextEditingController(
                                  text: userProfile.studentType!,
                                ),
                              ),
                              YMargin(16.sp),
                            ],
                          )
                        : const SizedBox.shrink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextOf(
                          "Email",
                          16,
                          5,
                          align: TextAlign.left,
                          color: AppColors.grey2,
                        ),
                        InkWell(
                          onTap: () {
                            showEmail == true
                                ? setState(() {
                                    showEmail = false;
                                  })
                                : setState(() {
                                    showEmail = true;
                                  });
                            print(showEmail);
                          },
                          child: TextOf(
                            showEmail == true ? "Unchange" : "Change",
                            16,
                            5,
                            align: TextAlign.left,
                            color: AppColors.brown,
                          ),
                        )
                      ],
                    ),
                    YMargin(8.sp),
                    InputField(
                      hintText: userProfile.email!,
                      readOnly: true,
                      fieldGroupColors: AppColors.grey2,
                      showCursor: false,
                      suffixIcon: const SizedBox.shrink(),
                      fieldController:
                          TextEditingController(text: userProfile.email!),
                    ),
                    showEmail == true
                        ? Column(children: [
                            YMargin(8.sp),
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          color: AppThemeNotifier.colorScheme(
                                                  context)
                                              .primary,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                      text: 'Contact ',
                                      children: [
                                        TextSpan(
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: AppColors.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500),
                                          text: 'support@projectbist.com',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              LaunchUrl.launchEmailAddress(
                                                  context,
                                                  emailAddress:
                                                      'support@projectbist.com',
                                                  emailSubject:
                                                      'Request for Developer Support',
                                                  emailBody:
                                                      '--[Brief Description of Your Issue]--');
                                            },
                                        )
                                      ]),
                                ),
                              ],
                            ),
                          ])
                        : const SizedBox.shrink(),
                    ref.watch(switchUserProvider) != UserTypes.professional
                        ? Column(
                            children: [
                              YMargin(32.sp),
                              Row(
                                children: [
                                  TextOf("Education", 18.sp, 6),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    YMargin(16.sp),
                    ref.watch(switchUserProvider) == UserTypes.professional
                        ? Column(
                            children: [
                              InputFieldDialog(
                                suffixIcon: const SizedBox.shrink(),
                                openDialog: false,
                                fieldTitle: "Sector/Parastatals of Expertise",
                                fieldController: TextEditingController(
                                  text: userProfile.sector!,
                                ),
                                optionList: const [],
                              ),
                              YMargin(16.sp),
                              InputFieldDialog(
                                suffixIcon: const SizedBox.shrink(),
                                openDialog: false,
                                fieldTitle: "Division ",
                                fieldController: TextEditingController(
                                  text: userProfile.division!,
                                ),
                                optionList: const [],
                              ),
                              YMargin(16.sp),
                              InputFieldDialog(
                                suffixIcon: const SizedBox.shrink(),
                                openDialog: false,
                                fieldTitle: "Highest level of education",
                                fieldController: TextEditingController(
                                  text: userProfile.educationalLevel!,
                                ),
                                optionList: const [],
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              InputFieldDialog(
                                  openDialog: false,
                                  fieldTitle: "Institution Category",
                                  suffixIcon: const SizedBox.shrink(),
                                  fieldController: TextEditingController(
                                    text: userProfile.institutionCategory!,
                                  ),
                                  optionList: const []),
                              YMargin(16.sp),
                              InputFieldDialog(
                                  openDialog: false,
                                  fieldTitle: "Institution Ownership",
                                  suffixIcon: const SizedBox.shrink(),
                                  fieldController: TextEditingController(
                                      text: userProfile.institutionOwnership!),
                                  optionList: const []),
                              YMargin(16.sp),
                              InputFieldDialog(
                                openDialog: false,
                                fieldTitle: ref.watch(switchUserProvider) ==
                                        UserTypes.researcher
                                    ? "Institution attended"
                                    : "Institution Name",
                                suffixIcon: const SizedBox.shrink(),
                                fieldController: TextEditingController(
                                  text: userProfile.institutionName!,
                                ),
                                optionList: const [],
                              ),
                              YMargin(16.sp),
                              InputFieldDialog(
                                  openDialog: false,
                                  fieldTitle: "Faculty",
                                  suffixIcon: const SizedBox.shrink(),
                                  fieldController: TextEditingController(
                                      text: userProfile.faculty!),
                                  optionList: const []),
                              YMargin(16.sp),
                              InputField(
                                readOnly: true,
                                showCursor: false,
                                suffixIcon: const SizedBox.shrink(),
                                fieldController: TextEditingController(
                                  text: userProfile.department!,
                                ),
                                fieldTitle: "Department",
                              ),
                            ],
                          ),
                    ref.watch(switchUserProvider) == UserTypes.researcher
                        ? Column(
                            children: [
                              YMargin(32.sp),
                              Row(
                                children: [TextOf("Expertise", 18.sp, 6)],
                              ),
                              YMargin(16.sp),
                              InputFieldDialog(
                                suffixIcon: const SizedBox.shrink(),
                                openDialog: false,
                                fieldTitle: "Research Area",
                                fieldController: TextEditingController(
                                    text: userProfile.division!),
                                optionList: const [],
                              ),
                              YMargin(16.sp),
                              InputFieldDialog(
                                  suffixIcon: const SizedBox.shrink(),
                                  openDialog: false,
                                  fieldTitle: "Research Interest",
                                  fieldController: TextEditingController(
                                      text: userProfile.sector!),
                                  optionList: const []),
                              YMargin(16.sp),
                              InputFieldDialog(
                                  suffixIcon: const SizedBox.shrink(),
                                  openDialog: false,
                                  fieldTitle: "Highest level of education",
                                  fieldController: TextEditingController(
                                    text: userProfile.educationalLevel!,
                                  ),
                                  optionList: const []),
                              YMargin(16.sp),
                              InputFieldDialog(
                                suffixIcon: const SizedBox.shrink(),
                                openDialog: false,
                                fieldTitle: "Experience as a researcher/writer",
                                fieldController: TextEditingController(
                                    text: userProfile.experience!),
                                optionList: const [],
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    YMargin(30.sp),
                    Button(
                      text: "Edit Profile",
                      buttonType: ButtonType.blueBg,
                      onPressed: () {
                        //   FocusScope.of(context).unfocus();
                        _scrollController.animateTo(
                          0.0,
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeInOut,
                        );
                        Navigator.pushNamed(context, EditProfile.editProfile,
                            arguments: userProfile);
                      },
                    ),
                    YMargin(20.sp),
                  ],
                ),
              ),
            ),
        },
      ),
    );
  }
}
