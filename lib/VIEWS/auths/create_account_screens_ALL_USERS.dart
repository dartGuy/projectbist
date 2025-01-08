import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:password_policy/password_policy.dart';
import 'package:project_bist/PROVIDERS/auth_provider/auth_provider.dart';
import 'package:project_bist/PROVIDERS/institutions_provider/institutions_provider.dart';
import 'package:project_bist/PROVIDERS/sectors_and_division_provider/sectors_and_division_provider.dart';
import 'package:project_bist/PROVIDERS/switch_user.dart';
import 'package:project_bist/SERVICES/endpoints.dart';
import 'package:project_bist/UTILS/constants.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/UTILS/prints.dart';
import 'package:project_bist/UTILS/launch_url.dart';
import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
import 'package:project_bist/VIEWS/auths/login_screens.dart';
import 'package:project_bist/WIDGETS/buttons.dart';
import 'package:project_bist/WIDGETS/cupertino_widget.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/input_field_dialog.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import 'package:project_bist/WIDGETS/page_indicator.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/input_field.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/THEMES/color_themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class AllUsersCreateAccountScreen extends ConsumerStatefulWidget {
  static const String allUsersCreateAccountScreen =
      "allUsersCreateAccountScreen";
  UserTypes? userTypes;

  AllUsersCreateAccountScreen(
      {this.userTypes = UserTypes.researcher, super.key});

  @override
  ConsumerState<AllUsersCreateAccountScreen> createState() =>
      _AllUsersCreateAccountScreenState();
}

class _AllUsersCreateAccountScreenState
    extends ConsumerState<AllUsersCreateAccountScreen> {
  List<String> institutionAttendedOptionsList = [],
      searchInstitutionAttendedOptionsList = [],
      facultyOfExperienceOptions = [],
      departmentList = [],
      highestLevelOfEducationOptions = [
        "Doctorate",
        "Masters",
        "Bachelors Degree",
        "Higher diploma",
        "Diploma"
      ],
      sectorAndResearchAreaOptionList = [],
      divisionAndResearchInterestOptionList = [],
      levelOfExperienceOptionList = [
        "0-2 year",
        "2-5 years",
        "5-10 years",
        "10+ years"
      ],
      institutionCategoryList = [
        "University",
        "Polytechnic",
        "College of Education"
      ],
      institutionOwnershipList = ["Federal", "State", "Private"],
      studentTypeOptionsList = ["Undergraduate", "Postgraduate"];
  int initialIndex = 0;
  late TextEditingController firstNameController,
      passwordController,
      confirmPasswordController,
      lastNameController,
      usernameController,
      fullNameController,
      emailController,
      phoneController,
      institutionCategoryController,
      institutionOwnershipController,
      institutionAttendedController,
      facultyOfExperienceController,
      sectorAndResearchAreaController,
      divisionAndResearchInterestController,
      departmentController,
      studentTypeController,
      highestLevelOfEducationController,
      levelOfexperienceController,
      professionalDivisionOptionListController,
      searchTopicsController;
  late PageController _pageViewController;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      ref
          .read(emailAvailabilityProvider.notifier)
          .switchState(ResponseAvailabilityState.NEUTRAL);
    });
    setState(() {
      firstNameController = TextEditingController();
      passwordController = TextEditingController();
      _pageViewController = PageController();
      confirmPasswordController = TextEditingController();
      lastNameController = TextEditingController();
      usernameController = TextEditingController();
      fullNameController = TextEditingController();
      emailController = TextEditingController();
      phoneController = TextEditingController();
      institutionCategoryController = TextEditingController();
      institutionOwnershipController = TextEditingController();
      institutionAttendedController = TextEditingController();
      facultyOfExperienceController = TextEditingController();
      studentTypeController = TextEditingController();
      sectorAndResearchAreaController = TextEditingController();
      departmentController = TextEditingController();
      highestLevelOfEducationController = TextEditingController();
      levelOfexperienceController = TextEditingController();
      professionalDivisionOptionListController = TextEditingController();
      divisionAndResearchInterestController = TextEditingController();
      searchTopicsController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    firstNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    institutionCategoryController.dispose();
    institutionOwnershipController.dispose();
    institutionAttendedController.dispose();
    facultyOfExperienceController.dispose();
    studentTypeController.dispose();
    sectorAndResearchAreaController.dispose();
    departmentController.dispose();
    highestLevelOfEducationController.dispose();
    levelOfexperienceController.dispose();
    professionalDivisionOptionListController.dispose();
    searchTopicsController.dispose();
    divisionAndResearchInterestController.dispose();
    super.dispose();
  }

  bool hasAcceptedTerms = false;
  final _physics = null;
  @override
  Widget build(BuildContext context) {
    List<Widget> allPageViewBody = [
      ref.watch(switchUserProvider) == UserTypes.professional
          ? professionalFirstPage()
          : researcherAndStudentFirstPage(),
      ref.watch(switchUserProvider) == UserTypes.student
          ? studentSecondPage()
          : ref.watch(switchUserProvider) == UserTypes.researcher
              ? researcherSecondPage()
              : professionalSecondPage(),
      if (ref.watch(switchUserProvider) == UserTypes.researcher)
        researcherSecondSecondPage(),
      generalThirdPage()
    ];

    bool nextButtonValidator() {
      return (((ref.watch(switchUserProvider) == UserTypes.researcher &&
                  initialIndex == 0)
              ? (firstNameController.text.isEmpty ||
                  lastNameController.text.isEmpty ||
                  usernameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  phoneController.text.isEmpty)
              : ref.watch(switchUserProvider) == UserTypes.researcher &&
                      initialIndex == 1
                  ? (departmentController.text.isEmpty ||
                      facultyOfExperienceController.text.isEmpty ||
                      institutionAttendedController.text.isEmpty ||
                      institutionOwnershipController.text.isEmpty ||
                      institutionCategoryController.text.isEmpty)
                  : ref.watch(switchUserProvider) == UserTypes.researcher &&
                          initialIndex == 2
                      ? (levelOfexperienceController.text.isEmpty ||
                          highestLevelOfEducationController.text.isEmpty ||
                          divisionAndResearchInterestController.text.isEmpty ||
                          sectorAndResearchAreaController.text.isEmpty)
                      : (ref.watch(switchUserProvider) == UserTypes.student &&
                              initialIndex == 0)
                          ? (firstNameController.text.isEmpty ||
                              lastNameController.text.isEmpty ||
                              usernameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              phoneController.text.isEmpty)
                          : (ref.watch(switchUserProvider) ==
                                      UserTypes.student &&
                                  initialIndex == 1)
                              ? (institutionAttendedController.text.isEmpty ||
                                  facultyOfExperienceController.text.isEmpty ||
                                  institutionCategoryController.text.isEmpty ||
                                  institutionOwnershipController.text.isEmpty ||
                                  studentTypeController.text.isEmpty ||
                                  departmentController.text.isEmpty)
                              : (ref.watch(
                                              switchUserProvider) ==
                                          UserTypes.professional &&
                                      initialIndex == 0)
                                  ? (fullNameController.text.isEmpty ||
                                      usernameController.text.isEmpty ||
                                      emailController.text.isEmpty ||
                                      phoneController.text.isEmpty)
                                  : (ref.watch(
                                                  switchUserProvider) ==
                                              UserTypes.professional &&
                                          initialIndex == 1)
                                      ? (sectorAndResearchAreaController
                                              .text.isEmpty ||
                                          professionalDivisionOptionListController
                                              .text.isEmpty ||
                                          emailController.text.isEmpty ||
                                          highestLevelOfEducationController
                                              .text.isEmpty)
                                      : false) ||
          ref.watch(emailAvailabilityProvider).responseState !=
              ResponseAvailabilityState.DATA);
    }

    double keyboardSpace =
        MediaQuery.of(context).viewInsets.bottom > 0 ? 0.045.sw : 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });

    return Scaffold(
      appBar: customAppBar(context, hasIcon: true, onTap: () {
        initialIndex != 0
            ? _pageViewController.animateToPage(initialIndex - 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut)
            : Navigator.pop(context);
      }),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: appPadding(),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      height: 0.2.sh,
                      switch (ref.watch(switchUserProvider)) {
                        UserTypes.researcher => ImageOf.researcher,
                        _ => ImageOf.client,
                      }),
                ],
              ),
              YMargin(24.sp),
              PageIndicator(
                initialIndex: initialIndex,
                length: ref.watch(switchUserProvider) == UserTypes.researcher
                    ? 4
                    : 3,
              ),
              YMargin(24.sp),
              TextOf(
                "Create new account",
                26.sp,
                5,
                fontFamily: Fonts.nunito,
              ),
              YMargin(12.sp),
              SizedBox(
                height: ((ref.watch(switchUserProvider) != UserTypes.professional &&
                            initialIndex == 0)
                        ? (0.52.sh -
                            (ref.watch(emailAvailabilityProvider).responseState ==
                                    ResponseAvailabilityState.NEUTRAL
                                ? 0.055.sh
                                : 0))
                        : (ref.watch(switchUserProvider) == UserTypes.professional &&
                                initialIndex == 0)
                            ? (0.39.sh +
                                (ref.watch(emailAvailabilityProvider).responseState ==
                                        ResponseAvailabilityState.NEUTRAL
                                    ? 0
                                    : 0.055.sh))
                            : (ref.watch(switchUserProvider) == UserTypes.professional &&
                                    initialIndex == 1)
                                ? 0.25.sh
                                : (ref.watch(switchUserProvider) == UserTypes.student &&
                                        initialIndex == 1)
                                    ? 0.5.sh
                                    : initialIndex == 1
                                        ? 0.42.sh
                                        : (ref.watch(switchUserProvider) ==
                                                    UserTypes.researcher &&
                                                initialIndex == 2)
                                            ? 0.335.sh
                                            : ((ref.watch(switchUserProvider) !=
                                                            UserTypes.researcher &&
                                                        initialIndex == 2) ||
                                                    (initialIndex == 3))
                                                ? 0.4.sh
                                                : 0.42.sh) +
                    keyboardSpace,
                child: PageView(
                  controller: _pageViewController,
                  //  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (value) {
                    setState(() {
                      initialIndex = value;
                    });
                  },
                  children: allPageViewBody,
                ),
              ),
              // YMargin(14.sp),
              ((ref.watch(switchUserProvider) != UserTypes.researcher &&
                          initialIndex == 2) ||
                      (ref.watch(switchUserProvider) == UserTypes.researcher &&
                          initialIndex == 3))
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        YMargin(0.03.sh),
                        Row(children: [
                          InkWell(
                            onTap: () {
                              setState(
                                  () => hasAcceptedTerms = !hasAcceptedTerms);
                            },
                            child: IconOf(
                              hasAcceptedTerms == false
                                  ? Icons.check_box_outline_blank
                                  : Icons.check_box_outlined,
                              color: AppThemeNotifier.colorScheme(context)
                                  .onSecondary,
                            ),
                          ),
                          XMargin(10.sp),
                          RichText(
                              text: TextSpan(
                                  text: "I agree with ",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          AppThemeNotifier.colorScheme(context)
                                              .onSecondary,
                                      fontFamily: Fonts.nunito),
                                  children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      LaunchUrl.launchWebsite(context,
                                          websiteLink:
                                              AppConst.TERMS_OF_SERVICE);
                                    },
                                  text: "Terms & conditions",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      color: AppColors.primaryColor,
                                      fontFamily: Fonts.nunito),
                                )
                              ]))
                        ]),
                        YMargin(20.sp),
                        Button(
                          text: "Sign up",
                          buttonType: ((passwordController.text ==
                                      confirmPasswordController.text) &&
                                  passwordController.text.length > 5 &&
                                  passwordCheck.isValid &&
                                  hasAcceptedTerms == true)
                              ? ButtonType.blueBg
                              : ButtonType.disabled,
                          onPressed: () {
                            if (ref.watch(switchUserProvider) ==
                                UserTypes.researcher) {
                              AuthProviders.researcherSignup(context,
                                  fullName:
                                      "${firstNameController.text} ${lastNameController.text}",
                                  userName: usernameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phoneNumber: phoneController.text,
                                  faculty: facultyOfExperienceController.text,
                                  educationLevel:
                                      highestLevelOfEducationController.text,
                                  experience:
                                      sectorAndResearchAreaController.text,
                                  institutionCategory:
                                      institutionCategoryController.text,
                                  institutionOwnership:
                                      institutionOwnershipController.text,
                                  institutionName:
                                      institutionAttendedController.text,
                                  division:
                                      divisionAndResearchInterestController
                                          .text,
                                  sector: sectorAndResearchAreaController.text,
                                  department: departmentController.text);
                            } else if (ref.watch(switchUserProvider) ==
                                UserTypes.professional) {
                              AuthProviders.professionalSignup(context,
                                  fullName: fullNameController.text,
                                  userName: usernameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phoneNumber: phoneController.text,
                                  educationLevel:
                                      highestLevelOfEducationController.text,
                                  division:
                                      professionalDivisionOptionListController
                                          .text,
                                  sector: sectorAndResearchAreaController.text);
                            } else if (ref.watch(switchUserProvider) ==
                                UserTypes.student) {
                              AuthProviders.studentSignup(context,
                                  fullName:
                                      "${firstNameController.text} ${lastNameController.text}",
                                  userName: usernameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phoneNumber: phoneController.text,
                                  institutionCategory:
                                      institutionCategoryController.text,
                                  institutionOwnership:
                                      institutionOwnershipController.text,
                                  institutionName:
                                      institutionAttendedController.text,
                                  studentType: studentTypeController.text,
                                  department: departmentController.text,
                                  faculty: facultyOfExperienceController.text);
                            }

                            prints(((passwordController.text ==
                                    confirmPasswordController.text) &&
                                passwordController.text.isNotEmpty));
                          },
                        ),

                        // Button(text: "Sign up", isEnabled: false)
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          InkWell(
                            onTap: () {
                              if (initialIndex != 0) {
                                _pageViewController.animateToPage(
                                    initialIndex - 1,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOut);
                              }
                            },
                            child: TextOf(
                              "PREVIOUS",
                              16.sp,
                              5,
                              fontFamily: Fonts.nunito,
                              color: initialIndex == 0
                                  ? AppColors.secondaryColor
                                  : AppColors.primaryColor,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (!nextButtonValidator()) {
                                _pageViewController.animateToPage(
                                    initialIndex + 1,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOut);
                              }
                            },
                            child: TextOf(
                              "NEXT",
                              16.sp,
                              5,
                              fontFamily: Fonts.nunito,
                              color: nextButtonValidator()
                                  ? AppColors.secondaryColor
                                  : AppColors.primaryColor,
                            ),
                          )
                        ]),
              YMargin(17.sp),
              initialIndex != 0
                  ? const SizedBox.shrink()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextOf(
                          "Already have an account?",
                          16.sp,
                          5,
                          fontFamily: Fonts.nunito,
                        ),
                        XMargin(5.sp),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, LoginScreen.loginScreen);
                          },
                          child: TextOf(
                            "Login",
                            16.sp,
                            5,
                            fontFamily: Fonts.nunito,
                            color: AppColors.primaryColor,
                          ),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  /// =================================[RESEARCHER & STUDENT First pages]======================
  /// =================================[RESEARCHER & STUDENT First pages]======================
  /// =================================[RESEARCHER & STUDENT First pages]======================

  researcherAndStudentFirstPage() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputField(
              hintText: "First name",
              onChanged: (e) => e,
              fieldController: firstNameController),
          YMargin(5.sp),
          Row(
            children: [
              Expanded(
                child: TextOf(
                    "Use the first name as it is on your NIN", 12.sp, 4,
                    align: TextAlign.left),
              ),
            ],
          ),
          YMargin(16.sp),
          InputField(
              hintText: "Last name",
              onChanged: (e) => e,
              fieldController: lastNameController),
          YMargin(5.sp),
          Row(
            children: [
              Expanded(
                child: TextOf(
                    "Use your last name as it is on your NIN", 12.sp, 4,
                    align: TextAlign.left),
              ),
            ],
          ),
          YMargin(16.sp),
          InputField(
              hintText: "Username",
              onChanged: (e) {
                usernameController.text = usernameController.text.trim();
                handleEmailUsernameVerifier();
              },
              fieldController: usernameController),
          emailUsernameVerifiedIndicator(
            "Username",
            "Email",
          ),
          YMargin(16.sp),
          InputField(
              hintText: "Email",
              inputType: TextInputType.emailAddress,
              onChanged: (e) {
                handleEmailUsernameVerifier();
              },
              fieldController: emailController),
          emailUsernameVerifiedIndicator("Email", "Username"),
          YMargin(16.sp),
          InputField(
              hintText: "Phone",
              inputType: TextInputType.phone,
              onChanged: (e) => e,
              fieldController: phoneController),
          YMargin(16.sp),
        ],
      ),
    );
  }

  Column emailUsernameVerifiedIndicator(String mainField, String nextField) {
    String massage = "",
        responseMessage = (ref.watch(emailAvailabilityProvider).message ?? "");
    if (responseMessage.toLowerCase().contains(mainField.toLowerCase()) &&
            responseMessage.toLowerCase().contains(nextField.toLowerCase()) ||
        !responseMessage.toLowerCase().contains(mainField.toLowerCase()) &&
            !responseMessage.toLowerCase().contains(nextField.toLowerCase())) {
      massage = responseMessage;
    } else if (responseMessage
        .toLowerCase()
        .contains(mainField.toLowerCase())) {
      massage = responseMessage;
    }
    return Column(
      children: [
        YMargin(ref.watch(emailAvailabilityProvider).responseState ==
                ResponseAvailabilityState.NEUTRAL
            ? 0
            : 2.sp),
        Row(
          children: [
            switch (ref.watch(emailAvailabilityProvider).responseState!) {
              ResponseAvailabilityState.NEUTRAL => const SizedBox.shrink(),
              _ => switch (
                    ref.watch(emailAvailabilityProvider).responseState!) {
                  ResponseAvailabilityState.LOADING =>
                    const CupertinoWidget(child: CupertinoActivityIndicator()),
                  _ => IconOf(
                      switch (
                          ref.watch(emailAvailabilityProvider).responseState!) {
                        ResponseAvailabilityState.DATA =>
                          Icons.check_circle_rounded,
                        _ => massage.isEmpty
                            ? Icons.check_circle_rounded
                            : Icons.error_rounded
                      },
                      color: switch (
                          ref.watch(emailAvailabilityProvider).responseState!) {
                        ResponseAvailabilityState.DATA => AppColors.green,
                        _ => massage.isEmpty ? AppColors.green : AppColors.red
                      }),
                },
            },
            XMargin(5.sp),
            TextOf(
                switch (ref.watch(emailAvailabilityProvider).responseState!) {
                  ResponseAvailabilityState.NEUTRAL => "",
                  ResponseAvailabilityState.LOADING =>
                    "Checking $mainField availability...",
                  ResponseAvailabilityState.ERROR =>
                    massage.isEmpty ? "$mainField available" : massage,
                  ResponseAvailabilityState.DATA => "$mainField available"
                },
                ref.watch(emailAvailabilityProvider).responseState ==
                        ResponseAvailabilityState.NEUTRAL
                    ? 0
                    : 12.sp,
                3)
          ],
        ),
      ],
    );
  }

  /// =================================[RESEARCHER SECOND Page]======================
  /// =================================[RESEARCHER SECOND Page]======================
  /// =================================[RESEARCHER SECOND Page]======================
  researcherSecondPage() {
    return StatefulBuilder(builder: (context, changeState) {
      return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          InputFieldDialog(
              fieldController: institutionCategoryController,
              hintText: "Institution Category",
              beforeOpenDialog: () {
                institutionAttendedController.clear();
                facultyOfExperienceController.clear();
                departmentController.clear();
              },
              optionList: institutionCategoryList),
          YMargin(16.sp),
          InputFieldDialog(
              fieldController: institutionOwnershipController,
              hintText: "Institution Ownership",
              beforeOpenDialog: () {
                institutionAttendedController.clear();
                facultyOfExperienceController.clear();
                departmentController.clear();
              },
              optionList: institutionOwnershipList),
          YMargin(16.sp),
          InputFieldDialog(
            fieldController: institutionAttendedController,
            optionList: institutionAttendedOptionsList,
            hintText: "Institution attended",
            openDialog: institutionCategoryController.text.isNotEmpty &&
                institutionOwnershipController.text.isNotEmpty,
            shouldExpand: true,
            topContent: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 10.sp).copyWith(top: 10),
              child: InputField(
                hintText: "Search bank...",
                fieldController: searchTopicsController,
                fillColor: AppColors.brown1(context),
                radius: 10.r,
                hintColor: AppThemeNotifier.colorScheme(context).primary ==
                        AppColors.white
                    ? AppColors.grey1
                    : AppColors.grey3,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
                enabledBorderColor: AppColors.brown1(context),
                focusedBorderColor: AppColors.brown1(context),
                prefixIcon: IconOf(
                  Icons.search,
                  size: 23.sp,
                  color: AppThemeNotifier.colorScheme(context).primary ==
                          AppColors.white
                      ? AppColors.grey1
                      : AppColors.grey3,
                ),
              ),
            ),
            beforeOpenDialog: () {
              InstitutionsProvider.fetchInstitutions(
                      institutionType: institutionCategoryController.text
                              .toLowerCase()
                              .contains("education")
                          ? "College"
                          : institutionCategoryController.text,
                      ownership: institutionOwnershipController.text)
                  .then((value) => changeState(() {
                        institutionAttendedOptionsList = value;
                        //   print("LENGTH; ${institutionAttendedOptionsList.LENGTH}");
                      }));
              facultyOfExperienceController.clear();
              departmentController.clear();
            },
          ),
          YMargin(16.sp),
          InputFieldDialog(
            fieldController: facultyOfExperienceController,
            hintText: "Faculty of Expertise",
            optionList: facultyOfExperienceOptions,
            openDialog: institutionCategoryController.text.isNotEmpty &&
                institutionOwnershipController.text.isNotEmpty &&
                institutionAttendedController.text.isNotEmpty,
            shouldExpand: false,
            beforeOpenDialog: () {
              InstitutionsProvider.fetchFaculties(
                      institutionType: institutionCategoryController.text
                              .toLowerCase()
                              .contains("education")
                          ? "College"
                          : institutionCategoryController.text,
                      ownership: institutionOwnershipController.text,
                      institutionName: institutionAttendedController.text)
                  .then((value) => changeState(() {
                        facultyOfExperienceOptions = value;
                        //   print("LENGTH; ${institutionAttendedOptionsList.LENGTH}");
                      }));
              departmentController.clear();
            },
          ),
          YMargin(16.sp),
          InputFieldDialog(
            fieldController: departmentController,
            optionList: departmentList,
            hintText: "Department",
            openDialog: institutionCategoryController.text.isNotEmpty &&
                institutionOwnershipController.text.isNotEmpty &&
                institutionAttendedController.text.isNotEmpty &&
                facultyOfExperienceController.text.isNotEmpty,
            shouldExpand: false,
            beforeOpenDialog: () {
              InstitutionsProvider.fetchDepartments(
                      institutionType: institutionCategoryController.text
                              .toLowerCase()
                              .contains("education")
                          ? "College"
                          : institutionCategoryController.text,
                      ownership: institutionOwnershipController.text,
                      institutionName: institutionAttendedController.text,
                      faculty: facultyOfExperienceController.text)
                  .then((value) => changeState(() {
                        departmentList = value;
                        //   print("LENGTH; ${institutionAttendedOptionsList.LENGTH}");
                      }));
            },
          ),
          YMargin(16.sp),
        ]),
      );
    });
  }

  /// =================================[RESEARCHER SECOND-SECOND Page]======================
  /// =================================[RESEARCHER SECOND-SECOND Page]======================
  /// =================================[RESEARCHER SECOND-SECOND Page]======================
  researcherSecondSecondPage() {
    return StatefulBuilder(builder: (context, changeState) {
      return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          InputFieldDialog(
            hintText: "Research Area",
            fieldController: sectorAndResearchAreaController,
            shouldExpand: true,
            beforeOpenDialog: () {
              SectorAndDivisionProvider.fetchSectors()
                  .then((value) => changeState(() {
                        sectorAndResearchAreaOptionList = value;
                      }));
              divisionAndResearchInterestController.clear();
            },
            optionList: sectorAndResearchAreaOptionList,
          ),
          YMargin(16.sp),
          InputFieldDialog(
              fieldController: divisionAndResearchInterestController,
              hintText: "Research Interest",
              shouldExpand: true,
              openDialog: sectorAndResearchAreaController.text.isNotEmpty,
              beforeOpenDialog: () {
                SectorAndDivisionProvider.fetchDivisions(
                        sectorAndResearchAreaController.text)
                    .then((value) => changeState(() {
                          divisionAndResearchInterestOptionList = value;
                        }));
              },
              optionList: divisionAndResearchInterestOptionList),
          YMargin(16.sp),
          InputFieldDialog(
              fieldController: highestLevelOfEducationController,
              hintText: "Highest Level of Education",
              optionList: highestLevelOfEducationOptions),
          YMargin(16.sp),
          InputFieldDialog(
              fieldController: levelOfexperienceController,
              hintText: "Level of Experience",
              optionList: levelOfExperienceOptionList),
        ]),
      );
    });
  }

  /// =================================[STUDENT SECOND Page]======================
  /// =================================[STUDENT SECOND Page]======================
  /// =================================[STUDENT SECOND Page]======================
  studentSecondPage() {
    return StatefulBuilder(builder: (context, changeState) {
      return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          InputFieldDialog(
              fieldController: institutionCategoryController,
              hintText: "Institution Category",
              optionList: institutionCategoryList),
          YMargin(16.sp),
          InputFieldDialog(
              fieldController: institutionOwnershipController,
              hintText: "Institution Ownership",
              optionList: institutionOwnershipList),
          YMargin(16.sp),
          InputFieldDialog(
            fieldController: institutionAttendedController,
            optionList: institutionAttendedOptionsList,
            hintText: "Institution attended",
            openDialog: institutionCategoryController.text.isNotEmpty &&
                institutionOwnershipController.text.isNotEmpty,
            shouldExpand: true,
            topContent: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 10.sp).copyWith(top: 10),
              child: InputField(
                hintText: "Search bank...",
                fieldController: searchTopicsController,
                fillColor: AppColors.brown1(context),
                radius: 10.r,
                hintColor: AppThemeNotifier.colorScheme(context).primary ==
                        AppColors.white
                    ? AppColors.grey1
                    : AppColors.grey3,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
                enabledBorderColor: AppColors.brown1(context),
                focusedBorderColor: AppColors.brown1(context),
                prefixIcon: IconOf(
                  Icons.search,
                  size: 23.sp,
                  color: AppThemeNotifier.colorScheme(context).primary ==
                          AppColors.white
                      ? AppColors.grey1
                      : AppColors.grey3,
                ),
              ),
            ),
            beforeOpenDialog: () {
              InstitutionsProvider.fetchInstitutions(
                      institutionType: institutionCategoryController.text
                              .toLowerCase()
                              .contains("education")
                          ? "College"
                          : institutionCategoryController.text,
                      ownership: institutionOwnershipController.text)
                  .then((value) => changeState(() {
                        institutionAttendedOptionsList = value;
                        //   print("LENGTH; ${institutionAttendedOptionsList.LENGTH}");
                      }));
              facultyOfExperienceController.clear();
              departmentController.clear();
            },
          ),
          YMargin(16.sp),
          InputFieldDialog(
            fieldController: facultyOfExperienceController,
            hintText: "Faculty",
            optionList: facultyOfExperienceOptions,
            openDialog: institutionCategoryController.text.isNotEmpty &&
                institutionOwnershipController.text.isNotEmpty &&
                institutionAttendedController.text.isNotEmpty,
            shouldExpand: false,
            beforeOpenDialog: () {
              InstitutionsProvider.fetchFaculties(
                      institutionType: institutionCategoryController.text
                              .toLowerCase()
                              .contains("education")
                          ? "College"
                          : institutionCategoryController.text,
                      ownership: institutionOwnershipController.text,
                      institutionName: institutionAttendedController.text)
                  .then((value) => changeState(() {
                        facultyOfExperienceOptions = value;
                        //   print("LENGTH; ${institutionAttendedOptionsList.LENGTH}");
                      }));
              departmentController.clear();
            },
          ),
          YMargin(16.sp),
          InputFieldDialog(
            fieldController: departmentController,
            optionList: departmentList,
            hintText: "Department",
            openDialog: institutionCategoryController.text.isNotEmpty &&
                institutionOwnershipController.text.isNotEmpty &&
                institutionAttendedController.text.isNotEmpty &&
                facultyOfExperienceController.text.isNotEmpty,
            shouldExpand: false,
            beforeOpenDialog: () {
              InstitutionsProvider.fetchDepartments(
                      institutionType: institutionCategoryController.text
                              .toLowerCase()
                              .contains("education")
                          ? "College"
                          : institutionCategoryController.text,
                      ownership: institutionOwnershipController.text,
                      institutionName: institutionAttendedController.text,
                      faculty: facultyOfExperienceController.text)
                  .then((value) => changeState(() {
                        departmentList = value;
                        //   print("LENGTH; ${institutionAttendedOptionsList.LENGTH}");
                      }));
            },
          ),
          YMargin(16.sp),
          InputFieldDialog(
              hintText: "Student Type",
              fieldController: studentTypeController,
              optionList: studentTypeOptionsList),
          YMargin(16.sp),
        ]),
      );
    });
  }

  /// =================================[Professional First Page and Second Page]======================
  /// =================================[Professional First Page and Second Page]======================
  professionalFirstPage() {
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        InputField(
            hintText: "Full name",
            onChanged: (e) => e,
            fieldController: fullNameController),
        YMargin(5.sp),
        Row(
          children: [
            Expanded(
              child: TextOf(
                  "First name and last name should match exactly the way they're in your NIN",
                  12.sp,
                  4,
                  align: TextAlign.left),
            ),
          ],
        ),
        YMargin(16.sp),
        InputField(
            hintText: "Username",
            onChanged: (e) {
              handleEmailUsernameVerifier();
            },
            fieldController: usernameController),
        emailUsernameVerifiedIndicator(
          "Username",
          "Email",
        ),
        YMargin(16.sp),
        InputField(
            hintText: "Email",
            inputType: TextInputType.emailAddress,
            onChanged: (e) {
              handleEmailUsernameVerifier();
            },
            fieldController: emailController),
        Row(
          children: [
            TextOf(
              "Recommended: Use your corporate email ",
              14.sp,
              4,
              color: isDarkTheme(context) ? AppColors.grey1 : AppColors.grey3,
            ),
          ],
        ),
        emailUsernameVerifiedIndicator("Email", "Username"),
        YMargin(16.sp),
        InputField(
            hintText: "Phone",
            inputType: TextInputType.phone,
            onChanged: (e) => e,
            fieldController: phoneController),
      ]),
    );
  }

  professionalSecondPage() {
    return StatefulBuilder(builder: (context, changeState) {
      return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          InputFieldDialog(
            fieldController: sectorAndResearchAreaController,
            hintText: "Sector/Parastatal of Expertise",
            optionList: sectorAndResearchAreaOptionList,
            shouldExpand: true,
            beforeOpenDialog: () {
              SectorAndDivisionProvider.fetchSectors()
                  .then((value) => changeState(() {
                        sectorAndResearchAreaOptionList = value;
                      }));
              professionalDivisionOptionListController.clear();
            },
          ),
          YMargin(16.sp),
          InputFieldDialog(
            fieldController: professionalDivisionOptionListController,
            hintText: "Division",
            optionList: divisionAndResearchInterestOptionList,
            shouldExpand: true,
            openDialog: sectorAndResearchAreaController.text.isNotEmpty,
            beforeOpenDialog: () {
              SectorAndDivisionProvider.fetchDivisions(
                      sectorAndResearchAreaController.text)
                  .then((value) => changeState(() {
                        divisionAndResearchInterestOptionList = value;
                      }));
            },
          ),
          YMargin(16.sp),
          InputFieldDialog(
              fieldController: highestLevelOfEducationController,
              hintText: "Highest Level of Education",
              optionList: highestLevelOfEducationOptions),
        ]),
      );
    });
  }

  late PasswordCheck passwordCheck;
  PasswordPolicy passwordPolicy = PasswordPolicy(
    minimumScore: 1,
    validationRules: [
      UpperCaseRule(),
      LowerCaseRule(),
      DigitRule(),
      NoSpaceRule(),
      SpecialCharacterRule(),
    ],
  );

  /// =================================[GENERAL THIRD PAGE ==>> Password Fields]======================
  /// =================================[GENERAL THIRD PAGE ==>> Password Fields]======================
  /// =================================[GENERAL THIRD PAGE ==>> Password Fields]======================
  Widget generalThirdPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          passwordCheck = PasswordCheck(
              password: passwordController.text,
              passwordPolicy: passwordPolicy);
        });
      }
    });
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PasswordField(
              hintText: "Password",
              onChanged: (e) => e,
              isPassword: true,
              fieldController: passwordController),
          YMargin(16.sp),
          PasswordField(
              hintText: "Confirm password",
              onChanged: (e) => e,
              isPassword: true,
              fieldController: confirmPasswordController),
          YMargin(20.sp),
          ...List.generate(6, (index) {
            bool thisConditionFilled = switch (index) {
              0 => passwordController.text.length > 5,
              _ => passwordPolicy.validationRules[index - 1]
                      .computeRuleScore(passwordController.text) ==
                  1.0
            };
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  IconOf(
                    thisConditionFilled == true
                        ? Icons.check_circle_outline_rounded
                        : Icons.radio_button_off,
                    color: thisConditionFilled ? AppColors.green : null,
                  ),
                  XMargin(10.sp),
                  TextOf(
                      switch (index) {
                        0 => "Minimum of 6 characters",
                        1 => "Must contain upper case letter",
                        2 => "Must contain lower case letter",
                        3 => "Must contain digit(s)",
                        4 => "No space(s) between",
                        5 => "Must contain special character",
                        _ => ""
                      },
                      14.sp,
                      thisConditionFilled ? 6 : 4)
                ]),
                YMargin(10.sp)
              ],
            );
          }),
        ],
      ),
    );
  }

  Timer? _timer;
  void handleEmailUsernameVerifier() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel any existing timer
    }

    if (usernameController.text.length > 2 &&
        AppMethods.isEmailValid(emailController.text)) {
      ref
          .read(emailAvailabilityProvider.notifier)
          .switchState(ResponseAvailabilityState.LOADING);

      _timer = Timer(const Duration(seconds: 3), () {
        ref
            .read(emailAvailabilityProvider.notifier)
            .request(context, ref,
                endpoint: Endpoints.EMAIL_USERNAME_AVAILABILITY(
                    ref.watch(switchUserProvider) == UserTypes.researcher
                        ? "researchers"
                        : "client",
                    email: emailController.text,
                    username: usernameController.text))
            .then((result) {
          ref
              .read(emailAvailabilityProvider.notifier)
              .switchState(ResponseAvailabilityState.NEUTRAL);
        });
      });
    } else {
      ref
          .read(emailAvailabilityProvider.notifier)
          .switchState(ResponseAvailabilityState.NEUTRAL);
    }
  }
}
