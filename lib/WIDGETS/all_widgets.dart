// import 'package:flutter/material.dart';
// import 'package:project_bist/WIDGETS/buttons.dart';
// import 'package:project_bist/WIDGETS/drop_down.dart';
// import 'package:project_bist/WIDGETS/input_field.dart';
// import 'package:project_bist/WIDGETS/job_item.dart';
// import 'package:project_bist/WIDGETS/spacing.dart';
// import 'package:project_bist/WIDGETS/what_best_describes_option_item.dart';

// class AppWidgetsScreen extends StatefulWidget {
//   static const String appWidgetsScreen = "appWidgetsScreen";
//   const AppWidgetsScreen({super.key});

//   @override
//   State<AppWidgetsScreen> createState() => _AppWidgetsScreenState();
// }

// class _AppWidgetsScreenState extends State<AppWidgetsScreen> {
//   late TextEditingController fieldController, passwordController;
//   @override
//   void initState() {
//     fieldController = TextEditingController();
//     passwordController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     fieldController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   List<String> fieldsOfStudy = [
//     'Psychology',
//     'Computer Science',
//     'Biology',
//     'Economics',
//     'Political Science',
//     'Sociology',
//     'Environmental Science',
//     'Linguistics',
//     'Astrophysics',
//     'Fine Arts',
//   ];
//   String? selectedValue;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             const Button(
//               text: "Login",
//             ),
//             const YMargin(20),
//             const Button(
//               text: "Login",
//               isEnabled: false,
//             ),
//             const YMargin(20),
//             const Button(
//               text: "Login",
//               isOther: true,
//             ),
//             const YMargin(20),
//             InputField(
//                 hintText: "Username",
//                 onChanged: (e) => e,
//                 fieldController: fieldController),
//             const YMargin(20),
//             InputField(
//                 hintText: "Password",
//                 onChanged: (e) => e,
//                 isPassword: true,
//                 fieldController: passwordController),
//             const YMargin(20),
//             DropDownField(
//                 selectedValue: selectedValue,
//                 fieldsOfStudy: fieldsOfStudy,
//                 hintText: "Sector/Parastatals of study"),
//             const YMargin(20),
//             const WhatBestDescribesOptionItem(),
//             const YMargin(20),
//             const JobItem()
//           ],
//         ),
//       ),
//     ));
//   }
// }
