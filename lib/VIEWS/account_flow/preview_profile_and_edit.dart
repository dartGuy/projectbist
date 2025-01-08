// // ignore_for_file: library_private_types_in_public_api
// import 'dart:convert';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project_bist/MODELS/user_profile/user_profile.dart';
// import 'package:project_bist/PROVIDERS/_base_provider/base_provider.dart';
// import 'package:project_bist/PROVIDERS/_base_provider/response_status.dart';
// import 'package:project_bist/PROVIDERS/profile_provider/profile_provider.dart';
// import 'package:project_bist/PROVIDERS/switch_user.dart';
// import 'package:project_bist/SERVICES/api_respnse.dart';
// import 'package:project_bist/SERVICES/api_service.dart';
// import 'package:project_bist/SERVICES/endpoints.dart';
// import 'package:project_bist/UTILS/constants.dart';
// import 'package:project_bist/UTILS/images.dart';
// import 'package:project_bist/VIEWS/auths/_user_DETERMINATION_screens.dart';
// import 'package:project_bist/WIDGETS/buttons.dart';
// import 'package:project_bist/WIDGETS/custom_appbar.dart';
// import 'package:project_bist/WIDGETS/error_page.dart';
// import 'package:project_bist/WIDGETS/iconss.dart';
// import 'package:project_bist/WIDGETS/input_field.dart';
// import 'package:project_bist/WIDGETS/input_field_dialog.dart';
// import 'package:project_bist/WIDGETS/loading_indicator.dart';
// import 'package:project_bist/WIDGETS/spacing.dart';
// import 'package:project_bist/main.dart';
// import 'package:project_bist/THEMES/app_themes.dart';
// import 'package:project_bist/THEMES/color_themes.dart';
// import 'package:project_bist/widgets/texts.dart';

// final profileProvider =
//     StateNotifierProvider<BaseProvider<UserProfile>, ResponseStatus>(
//         (ref) => BaseProvider<UserProfile>());

// class PreviewProfileAndEdit extends ConsumerStatefulWidget {
//   static const String previewProfileAndEdit = "previewProfileAndEdit";
//   const PreviewProfileAndEdit({super.key});
//   @override
//   _PreviewProfileAndEditState createState() => _PreviewProfileAndEditState();
// }

// class _PreviewProfileAndEditState extends ConsumerState<PreviewProfileAndEdit> {
//   bool editStarted = false;
//   String? username,
//       phoneNumber,
//       experience,
//       sector,
//       institutionName,
//       institutionCategory,
//       faculty,
//       educationalLevel,
//       division,
//       institutionOwnership,
//       department,
//       avatar;

//   // @override
//   // void initState() {
//   //   setState(() {
//   //     fullNameConstroller = TextEditingController();
//   //     usernameController = TextEditingController();
//   //     phoneNumberController = TextEditingController();
//   //     institutionAttendedController = TextEditingController();
//   //     departmentAndDesciplineController = TextEditingController();
//   //     highestLevelOfEducation = TextEditingController();
//   //     areaOfEducationController = TextEditingController();
//   //     secotorOrParastatalCpntroller = TextEditingController();
//   //     experiencesAsAResearcherController = TextEditingController();
//   //     institutionCategoryController = TextEditingController();
//   //     emailController = TextEditingController();

//   //     /// [Newly Added]
//   //     facultyController = TextEditingController();
//   //     divisionController = TextEditingController();
//   //     institutionOwnershipController = TextEditingController();
//   //   });
//   //   super.initState();
//   // }

//   // @override
//   // void dispose() {
//   //   fullNameConstroller.dispose();
//   //   usernameController.dispose();
//   //   phoneNumberController.dispose();
//   //   institutionAttendedController.dispose();
//   //   departmentAndDesciplineController.dispose();
//   //   highestLevelOfEducation.dispose();
//   //   areaOfEducationController.dispose();
//   //   secotorOrParastatalCpntroller.dispose();
//   //   emailController.dispose();
//   //   experiencesAsAResearcherController.dispose();
//   //   institutionCategoryController.dispose();

//   //   /// [Newly Added]
//   //   facultyController.dispose();
//   //   divisionController.dispose();
//   //   institutionOwnershipController.dispose();
//   //   super.dispose();
//   // }

//   final ScrollController _scrollController = ScrollController();
//   @override
//   Widget build(BuildContext context) {
//     // final AsyncValue<ApiResponse> responseValue = ref.watch(buildProvider
//     //     .call(ApiParameter(url: Endpoints.GET_PROFILE, context: context)));

//     ref
//         .watch(profileProvider.notifier)
//         .getRequest(context: context, url: Endpoints.GET_PROFILE);
//     ResponseStatus? responseStatus;
//     responseStatus = ref.watch(profileProvider);
//     UserProfile? userProfile;
//     userProfile = UserProfile.fromJson(responseStatus!.data);
//     // if (responseStatus.responseState == ResponseState.DATA) {
//     //   setState(() {
//     //     fullNameConstroller.text = userProfile.fullName!;
//     //     usernameController.text = userProfile.username!;
//     //     phoneNumberController.text = userProfile.phoneNumber!;
//     //     institutionAttendedController.text = userProfile.institutionName!;
//     //     departmentAndDesciplineController.text =
//     //         ref.watch(switchUserProvider) == UserTypes.researcher
//     //             ? userProfile.division!
//     //             : userProfile.department!;
//     //     highestLevelOfEducation.text = userProfile.educationalLevel!;
//     //     areaOfEducationController.text = userProfile.faculty!;
//     //     secotorOrParastatalCpntroller.text = userProfile.sector!;
//     //     emailController.text = userProfile.email!;
//     //     experiencesAsAResearcherController.text = userProfile.experience!;
//     //     institutionCategoryController.text = userProfile.institutionCategory!;
//     //     facultyController.text = userProfile.faculty!;
//     //     divisionController.text = userProfile.division!;
//     //     institutionOwnershipController.text = userProfile.institutionOwnership!;
//     //   });
//     // }

//     return Scaffold(
//         appBar: customAppBar(context,
//             title: "${editStarted == true ? "Edit " : ""}Profile",
//             hasIcon: true,
//             hasElevation: true),
//         body: Center(
//           child: switch (responseStatus.responseState!) {
//             ResponseState.LOADING =>
//               LoadingIndicator(message: "Getting your profile..."),
//             ResponseState.ERROR => ErrorPage(
//                 message: responseStatus.message ==
//                         AppConst.INTERTET_CONNECTION_ERROR
//                     ? "Poor intgernet connection. Please ensure you are connected and try again!"
//                     : responseStatus.message!,
//                 onPressed: () {
//                   ref
//                       .watch(profileProvider.notifier)
//                       .getRequest(context: context, url: Endpoints.GET_PROFILE);
//                   responseStatus = ref.watch(profileProvider);
//                   userProfile = UserProfile.fromJson(responseStatus!.data);
//                 },
//               ),
//             ResponseState.DATA => SafeArea(
//                 child: SingleChildScrollView(
//                   controller: _scrollController,
//                   physics: const BouncingScrollPhysics(),
//                   padding: appPadding(),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Stack(
//                             alignment: Alignment.bottomRight,
//                             children: [
//                               SizedBox.square(
//                                 dimension: 100.sp,
//                                 child: CircleAvatar(
//                                   backgroundImage:
//                                       AssetImage(ImageOf.profilePic4),
//                                 ),
//                               ),
//                               CircleAvatar(
//                                 radius: 15.sp,
//                                 backgroundColor: AppColors.primaryColor,
//                                 child: IconOf(
//                                   Icons.photo_camera_outlined,
//                                   color: AppColors.white,
//                                   size: 18.sp,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                       YMargin(32.sp),
//                       Row(
//                         children: [TextOf("Basic Information", 18.sp, 6)],
//                       ),
//                       YMargin(16.sp),
//                       InputField(
//                         fieldTitle: "Full name",
//                         fieldGroupColors: AppColors.grey2,
//                         fieldController:
//                             TextEditingController(text: userProfile.fullName!),
//                         readOnly: true,
//                         showCursor: false,
//                       ),
//                       YMargin(16.sp),
//                       InputField(
//                         fieldTitle: "Username",
//                         hintText: "",
//                         onChanged: (e) {
//                           setState(() {
//                             username = e;
//                           });
//                         },
//                         readOnly: !editStarted,
//                         showCursor: editStarted,
//                         fieldController:
//                             TextEditingController(text: userProfile.username!),
//                       ),
//                       YMargin(16.sp),
//                       InputField(
//                         fieldTitle: "Phone number",
//                         readOnly: !editStarted,
//                         showCursor: editStarted,
//                         onChanged: (e) {
//                           setState(() {
//                             phoneNumber = e;
//                           });
//                         },
//                         inputType: TextInputType.phone,
//                         fieldController: TextEditingController(
//                             text: userProfile.phoneNumber!),
//                       ),
//                       editStarted == true
//                           ? const SizedBox.shrink()
//                           : Column(
//                               children: [
//                                 YMargin(16.sp),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     TextOf(
//                                       "Email",
//                                       16,
//                                       5,
//                                       align: TextAlign.left,
//                                       color: AppColors.grey2,
//                                     ),
//                                     TextOf(
//                                       "Change",
//                                       16,
//                                       5,
//                                       align: TextAlign.left,
//                                       color: AppColors.brown,
//                                     ),
//                                   ],
//                                 ),
//                                 YMargin(8.sp),
//                                 InputField(
//                                   hintText: userProfile.email!,
//                                   readOnly: true,
//                                   fieldGroupColors: AppColors.grey2,
//                                   showCursor: false,
//                                   fieldController: TextEditingController(
//                                       text: userProfile.email!),
//                                 ),
//                                 // YMargin(16.sp),
//                                 YMargin(8.sp),

//                                 Row(
//                                   children: [
//                                     RichText(
//                                       text: TextSpan(
//                                           style: TextStyle(
//                                               color:
//                                                   AppThemeNotifier.colorScheme(
//                                                           context)
//                                                       .primary,
//                                               fontSize: 14.sp,
//                                               fontWeight: FontWeight.w500),
//                                           text: 'Contact ',
//                                           children: [
//                                             TextSpan(
//                                               style: TextStyle(
//                                                   decoration:
//                                                       TextDecoration.underline,
//                                                   color: AppColors.primaryColor,
//                                                   fontSize: 14.sp,
//                                                   fontWeight: FontWeight.w500),
//                                               text: 'support@projectbist.com',
//                                               recognizer: TapGestureRecognizer()
//                                                 ..onTap = () =>
//                                                     print('Tap Here onTap'),
//                                             )
//                                           ]),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                       YMargin(24.sp),
//                       Row(
//                         children: [TextOf("Education", 18.sp, 6)],
//                       ),
//                       YMargin(16.sp),
//                       InputFieldDialog(
//                           openDialog: editStarted,
//                           fieldTitle: "Institution attended",
//                           fieldController: TextEditingController(
//                               text: userProfile.institutionName!),
//                           onChanged: (e) {
//                             setState(() {
//                               institutionName = e;
//                             });
//                           },
//                           optionList: const [
//                             "University of Lagos",
//                             "Obafemi Awolowo University",
//                             "Ahmadu Bello University",
//                             "Ilaro Polythecnic",
//                             "University of Ilorin",
//                             "University of Ibadan",
//                             "Federal University of Oye Ekiti",
//                             "Federal University of Technology, Minna",
//                             "Federal Polythecnic, Ede"
//                           ]),
//                       YMargin(16.sp),
//                       InputFieldDialog(
//                           openDialog: editStarted,
//                           onChanged: (e) {
//                             setState(() {
//                               institutionCategory = e;
//                             });
//                           },
//                           fieldTitle: "Institution Category",
//                           fieldController: TextEditingController(
//                               text: userProfile.institutionCategory!),
//                           optionList: const [
//                             "University",
//                             "Polytechnic",
//                             "College of Education"
//                           ]),
//                       YMargin(16.sp),
//                       InputFieldDialog(
//                           openDialog: editStarted,
//                           fieldTitle: "Area of Expertise",
//                           onChanged: (e) {
//                             setState(() {
//                               faculty = e;
//                             });
//                           },
//                           fieldController:
//                               TextEditingController(text: userProfile.faculty!),
//                           optionList: const ["Science", "Commercial", "Art"]),
//                       YMargin(16.sp),
//                       InputField(
//                         readOnly: !editStarted,
//                         showCursor: editStarted,
//                         onChanged: (e) {
//                           setState(() {
//                             institutionCategory = e;
//                           });
//                         },
//                         fieldController: TextEditingController(
//                             text: ref.watch(switchUserProvider) ==
//                                     UserTypes.researcher
//                                 ? userProfile.division
//                                 : userProfile.department!),
//                         fieldTitle: "Discipline",
//                       ),
//                       YMargin(16.sp),
//                       InputFieldDialog(
//                           openDialog: editStarted,
//                           fieldTitle: "Highest level of education",
//                           fieldController: TextEditingController(
//                               text: userProfile.educationalLevel!),
//                           optionList: const [
//                             "Doctorate",
//                             "Masters",
//                             "Bachelors Degree",
//                             "Higher diploma",
//                             "Diploma"
//                           ]),
//                       YMargin(16.sp),
//                       InputFieldDialog(
//                           openDialog: editStarted,
//                           fieldTitle: "Sector/Parastatals of Expertise",
//                           fieldController:
//                               TextEditingController(text: userProfile.sector!),
//                           optionList: const ["Agriculture", "Law", "Finance"]),
//                       YMargin(16.sp),
//                       InputFieldDialog(
//                           openDialog: editStarted,
//                           fieldTitle: "Experience as a researcher/writer",
//                           fieldController: TextEditingController(
//                               text: userProfile.experience!),
//                           optionList: const [
//                             "0-1 year",
//                             "1-3 years",
//                             "More than 4 years"
//                           ]),
//                       YMargin(30.sp),
//                       Button(
//                         text: editStarted == false
//                             ? "Edit Profile"
//                             : "Save Changes",
//                         buttonType: ButtonType.blueBg,
//                         onPressed: () {
//                           //   FocusScope.of(context).unfocus();
//                           _scrollController.animateTo(
//                             0.0,
//                             duration: const Duration(milliseconds: 700),
//                             curve: Curves.easeInOut,
//                           );
//                           setState(() {
//                             if (editStarted == false) {
//                               editStarted = true;
//                             } else {
//                               ProfileProvider.editProfile(
//                                   context: context,
//                                   userType: ref.watch(switchUserProvider),
//                                   userProfile: UserProfile(
//                                     username: username!,
//                                     phoneNumber: phoneNumber!,
//                                     experience: experience!,
//                                     sector: sector!,
//                                     institutionName: institutionName!,
//                                     institutionOwnership: institutionOwnership!,
//                                     educationalLevel: educationalLevel,
//                                     institutionCategory: institutionCategory!,
//                                     faculty: faculty!,
//                                     department: department!,
//                                     avatar: "avatar.png",
//                                     division: division,
//                                   ));

//                               editStarted = false;
//                               // 'experience': userProfile.experience,
//                               // 'sector': userProfile.sector,
//                               // 'faculty': userProfile.faculty,
//                               // 'educationalLevel': userProfile.educationalLevel,
//                               // 'division': userProfile.division,
//                               // 'institutionName': userProfile.institutionName,
//                               // 'institutionCategory': userProfile.institutionCategory,
//                               // 'institutionOwnership': userProfile.institutionOwnership,
//                               // 'department': userProfile.department,
//                               // 'avatar': userProfile.avatar,
//                               // 'username': userProfile.username,
//                               // 'phoneNumber': userProfile.phoneNumber,
//                             }
//                           });
//                         },
//                       ),
//                       YMargin(20.sp),
//                     ],
//                   ),
//                 ),
//               ),
//           },
//         ));
//   }
// }
