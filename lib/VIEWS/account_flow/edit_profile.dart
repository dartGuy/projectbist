// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project_bist/UTILS/json_path.dart';
import 'package:project_bist/core.dart';
import 'package:project_bist/main.dart';

class EditProfile extends ConsumerStatefulWidget {
  static const String editProfile = "editProfile";
  EditProfile({required this.userProfile, super.key});
  UserProfile userProfile = UserProfile();
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  late TextEditingController usernameController,
      phoneNumberController,
      institutionAttendedController,
      departmentAndDisciplineController,
      highestLevelOfEducationController,
      studentHighestLevelOfEducationController,
      areaOfEducationController,
      sectorOrParastatalController,
      experiencesAsAResearcherController,
      institutionCategoryController,
      emailController,
      facultyController,
      divisionController,
      institutionOwnershipController;

  // TODO:: profile image can be null hence avatarUrlPath can be null
  String? avatarUrlPath;

  List<String> fetchSectorsOptionList = [];
  List<String> fetchDivisionsOptionList = [];
  List<String> institutionAttendedOptionsList = [];
  List<String> facultyOfExperienceOptionsList = [];
  List<String> departmentOptionsList = [];

  @override
  void initState() {
    setState(() {
      usernameController =
          TextEditingController(text: widget.userProfile.username!);
      phoneNumberController =
          TextEditingController(text: widget.userProfile.phoneNumber!);
      institutionAttendedController =
          TextEditingController(text: widget.userProfile.institutionName!);
      departmentAndDisciplineController =
          TextEditingController(text: widget.userProfile.department!);
      highestLevelOfEducationController =
          TextEditingController(text: widget.userProfile.educationalLevel!);
      studentHighestLevelOfEducationController =
          TextEditingController(text: widget.userProfile.studentType);
      areaOfEducationController =
          TextEditingController(text: widget.userProfile.faculty!);
      sectorOrParastatalController =
          TextEditingController(text: widget.userProfile.sector!);
      experiencesAsAResearcherController =
          TextEditingController(text: widget.userProfile.experience!);
      institutionCategoryController =
          TextEditingController(text: widget.userProfile.institutionCategory!);
      emailController = TextEditingController(text: widget.userProfile.email!);
      facultyController =
          TextEditingController(text: widget.userProfile.faculty!);
      divisionController =
          TextEditingController(text: widget.userProfile.division!);
      institutionOwnershipController =
          TextEditingController(text: widget.userProfile.institutionOwnership!);
      avatarUrlPath = widget.userProfile.avatar;
    });
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneNumberController.dispose();
    institutionAttendedController.dispose();
    departmentAndDisciplineController.dispose();
    highestLevelOfEducationController.dispose();
    areaOfEducationController.dispose();
    sectorOrParastatalController.dispose();
    emailController.dispose();
    experiencesAsAResearcherController.dispose();
    institutionCategoryController.dispose();

    /// [Newly Added]
    facultyController.dispose();
    divisionController.dispose();
    institutionOwnershipController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  File? imageFile;
  // String? avatarUrlPath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: "Edit Profile", hasIcon: true, hasElevation: true),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: appPadding(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      SizedBox.square(
                        dimension: 100.sp,
                        child: imageFile == null
                            ? buildProfileImage(
                                imageUrl: widget.userProfile.avatar!,
                                fullNameTobSplit: widget.userProfile.fullName!)
                            : CircleAvatar(
                                backgroundImage: FileImage(imageFile!),
                              ),
                      ),
                      InkWell(
                        onTap: () {
                          appBottomSheet(
                            context,
                            body: SelectPhotoOptions(
                              onFileGotten: (fileGotten) {
                                setState(() {
                                  imageFile = fileGotten;
                                });
                              },
                              onAvatarUrlGotten: (value) {
                                setState(() {
                                  avatarUrlPath = value;
                                });
                              },
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 15.sp,
                          backgroundColor: AppColors.primaryColor,
                          child: IconOf(
                            Icons.photo_camera_outlined,
                            color: AppColors.white,
                            size: 18.sp,
                          ),
                        ),
                      )
                    ],
                  ),
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
                fieldTitle: "Phone number",
                inputType: TextInputType.phone,
                fieldController: phoneNumberController,
              ),

              /// Professional
              ref.watch(switchUserProvider) == UserTypes.professional
                  ? Column(
                      children: [
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Sector",

                          fieldTitle: "Sector/Parastatal of Expertise",
                          fieldController: sectorOrParastatalController,
                          // openDialog: fetchSectorsOptionList.isNotEmpty,
                          // openDialog: true,
                          beforeOpenDialog: () {
                            setState(() {
                              SectorAndDivisionProvider.fetchSectors()
                                  .then((value) {
                                fetchSectorsOptionList = value;
                              });

                              divisionController.clear();
                            });
                          },
                          optionList: fetchSectorsOptionList,
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Division",
                          fieldTitle: 'Division',
                          fieldController: divisionController,
                          optionList: fetchDivisionsOptionList,
                          openDialog:
                              sectorOrParastatalController.text.isNotEmpty,
                          beforeOpenDialog: () {
                            setState(() {
                              SectorAndDivisionProvider.fetchDivisions(
                                sectorOrParastatalController.text,
                              ).then(
                                (value) => {
                                  fetchDivisionsOptionList = value,
                                },
                              );
                            });
                          },
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Level of Education",
                          fieldTitle: "Highest level of education",
                          fieldController: highestLevelOfEducationController,
                          optionList: const [
                            "Doctorate",
                            "Masters",
                            "Bachelors Degree",
                            "Higher diploma",
                            "Diploma"
                          ],
                        )
                      ],
                    )
                  : const SizedBox.shrink(),

              /// Student
              ref.watch(switchUserProvider) == UserTypes.student
                  ? Column(
                      children: [
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Student Type",
                          fieldTitle: "Student Type",
                          fieldController:
                              studentHighestLevelOfEducationController,
                          optionList: const [
                            "Undergraduate",
                            "Postgraduate",
                          ],
                        ),
                        YMargin(24.sp),
                        Row(
                          children: [
                            TextOf("Education", 18.sp, 6),
                          ],
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Category",
                          fieldTitle: "Institution Category",
                          fieldController: institutionCategoryController,
                          optionList: const [
                            "University",
                            "Polytechnic",
                            "College of Education"
                          ],
                          beforeOpenDialog: () {
                            // TODO:: logic for clearing all
                            // institutionOwnershipController.clear();
                            // institutionAttendedController.clear();
                            // facultyController.clear();
                            // departmentAndDisciplineController.clear();
                          },
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Ownership",
                          fieldTitle: "Institution Ownership",
                          fieldController: institutionOwnershipController,
                          optionList: const ["Federal", "State", "Private"],
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Institution Name",
                          fieldTitle: "Institution Name",
                          fieldController: institutionAttendedController,
                          openDialog:
                              institutionOwnershipController.text.isNotEmpty &&
                                  institutionCategoryController.text.isNotEmpty,
                          optionList: institutionAttendedOptionsList,
                          beforeOpenDialog: () {
                            setState(() {
                              InstitutionsProvider.fetchInstitutions(
                                institutionType: institutionCategoryController
                                        .text
                                        .toLowerCase()
                                        .contains("education")
                                    ? "College"
                                    : institutionCategoryController.text,
                                ownership: institutionOwnershipController.text,
                              ).then((value) =>
                                  {institutionAttendedOptionsList = value});
                            });
                          },
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Faculty",
                          fieldTitle: "Faculty",
                          fieldController: facultyController,
                          optionList: facultyOfExperienceOptionsList,
                          beforeOpenDialog: () {
                            setState(() {
                              InstitutionsProvider.fetchFaculties(
                                institutionType: institutionCategoryController
                                        .text
                                        .toLowerCase()
                                        .contains("education")
                                    ? "College"
                                    : institutionCategoryController.text,
                                ownership: institutionOwnershipController.text,
                                institutionName:
                                    institutionAttendedController.text,
                              ).then((value) =>
                                  {facultyOfExperienceOptionsList = value});
                            });
                          },
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Department",
                          fieldTitle: "Department",
                          fieldController: departmentAndDisciplineController,
                          optionList: departmentOptionsList,
                          beforeOpenDialog: () {
                            setState(() {
                              InstitutionsProvider.fetchDepartments(
                                institutionType: institutionCategoryController
                                        .text
                                        .toLowerCase()
                                        .contains("education")
                                    ? "College"
                                    : institutionCategoryController.text,
                                ownership: institutionOwnershipController.text,
                                institutionName:
                                    institutionAttendedController.text,
                                faculty: facultyController.text,
                              ).then(
                                (value) => {departmentOptionsList = value},
                              );
                            });
                          },
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),

              /// Researcher
              ref.watch(switchUserProvider) == UserTypes.researcher
                  ? Column(
                      children: [
                        YMargin(24.sp),
                        Row(
                          children: [
                            TextOf("Education", 18.sp, 6),
                          ],
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Category",
                          fieldTitle: "Institution Category",
                          fieldController: institutionCategoryController,
                          optionList: const [
                            "University",
                            "Polytechnic",
                            "College of Education"
                          ],
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Ownership",
                          fieldTitle: "Institution Ownership",
                          fieldController: institutionOwnershipController,
                          optionList: const ["Federal", "State", "Private"],
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Institution Name",
                          fieldTitle: "Institution Attended",
                          fieldController: institutionAttendedController,
                          openDialog:
                              institutionOwnershipController.text.isNotEmpty &&
                                  institutionCategoryController.text.isNotEmpty,
                          optionList: institutionAttendedOptionsList,
                          beforeOpenDialog: () {
                            setState(() {});
                            setState(() {
                              InstitutionsProvider.fetchInstitutions(
                                institutionType: institutionCategoryController
                                        .text
                                        .toLowerCase()
                                        .contains("education")
                                    ? "College"
                                    : institutionCategoryController.text,
                                ownership: institutionOwnershipController.text,
                              ).then((value) => {
                                    institutionAttendedOptionsList = value,
                                  });
                            });
                          },
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Faculty",
                          fieldTitle: "Faculty",
                          fieldController: facultyController,
                          optionList: facultyOfExperienceOptionsList,
                          beforeOpenDialog: () {
                            setState(() {
                              InstitutionsProvider.fetchFaculties(
                                institutionType: institutionCategoryController
                                        .text
                                        .toLowerCase()
                                        .contains("education")
                                    ? "College"
                                    : institutionCategoryController.text,
                                ownership: institutionOwnershipController.text,
                                institutionName:
                                    institutionAttendedController.text,
                              ).then((value) =>
                                  {facultyOfExperienceOptionsList = value});
                            });
                          },
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Department",
                          fieldTitle: "Department",
                          fieldController: departmentAndDisciplineController,
                          optionList: departmentOptionsList,
                          beforeOpenDialog: () {
                            setState(() {
                              InstitutionsProvider.fetchDepartments(
                                institutionType: institutionCategoryController
                                        .text
                                        .toLowerCase()
                                        .contains("education")
                                    ? "College"
                                    : institutionCategoryController.text,
                                ownership: institutionOwnershipController.text,
                                institutionName:
                                    institutionAttendedController.text,
                                faculty: facultyController.text,
                              ).then(
                                (value) => {departmentOptionsList = value},
                              );
                            });
                          },
                        ),
                        YMargin(24.sp),
                        Row(
                          children: [
                            TextOf("Expertise", 18.sp, 6),
                          ],
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Research Area",
                          fieldTitle: "Research Area",
                          fieldController: sectorOrParastatalController,
                          beforeOpenDialog: () {
                            setState(() {
                              SectorAndDivisionProvider.fetchSectors()
                                  .then((value) {
                                fetchSectorsOptionList = value;
                              });
                              // divisionController.clear();
                            });
                          },
                          optionList: fetchSectorsOptionList,
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          hintText: "Select Research Interest",
                          fieldTitle: "Research Interest",
                          fieldController: divisionController,
                          optionList: fetchDivisionsOptionList,
                          openDialog:
                              sectorOrParastatalController.text.isNotEmpty,
                          beforeOpenDialog: () {
                            setState(() {
                              SectorAndDivisionProvider.fetchDivisions(
                                sectorOrParastatalController.text,
                              ).then(
                                (value) => {
                                  fetchDivisionsOptionList = value,
                                },
                              );
                            });
                          },
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                          fieldTitle: "Highest level of education",
                          fieldController: highestLevelOfEducationController,
                          optionList: const [
                            "Doctorate",
                            "Masters",
                            "Bachelors Degree",
                            "Higher diploma",
                            "Diploma"
                          ],
                        ),
                        YMargin(16.sp),
                        InputFieldDialog(
                            fieldTitle: "Experience as a researcher/writer",
                            fieldController: experiencesAsAResearcherController,
                            optionList: const [
                              "0-2 year",
                              "2-5 years",
                              "5-10 years",
                              "10+ years"
                            ]),
                      ],
                    )
                  : const SizedBox.shrink(),

              YMargin(30.sp),
              Button(
                text: "Save Changes",
                buttonType: ButtonType.blueBg,
                onPressed: () {
                  ProfileProvider.editProfile(
                    ref: ref,
                    context: context,
                    userType: ref.watch(switchUserProvider),
                    userProfile: UserProfile(
                      username: usernameController.text,
                      phoneNumber: phoneNumberController.text,
                      experience: experiencesAsAResearcherController.text,
                      sector: sectorOrParastatalController.text,
                      institutionName: institutionAttendedController.text,
                      institutionOwnership: institutionOwnershipController.text,
                      educationalLevel: highestLevelOfEducationController.text,
                      institutionCategory: institutionCategoryController.text,
                      faculty: facultyController.text,
                      department: departmentAndDisciplineController.text,
                      avatar: avatarUrlPath,
                      division: divisionController.text,
                      studentType:
                          studentHighestLevelOfEducationController.text,
                    ),
                  );
                  _scrollController.animateTo(
                    0.0,
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              YMargin(20.sp),
            ],
          ),
        ),
      ),
    );
  }
}
