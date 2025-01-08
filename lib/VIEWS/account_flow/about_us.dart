import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/WIDGETS/custom_appbar.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/main.dart';
import 'package:project_bist/widgets/texts.dart';

class AboutUs extends StatelessWidget {
  static const String aboutUs = "aboutUs";
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: "About Us", hasIcon: true, hasElevation: true),
      body: SingleChildScrollView(
          padding: appPadding(),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              eachAboutUsSection(
                  title: "Who we are",
                  subtitle:
                      "We exist to create your ideal research project experience\nProjectBist started to address the problems observed with research undertakings getting the necessary supports needed to elevate their research experience; be it expert researchers, resources, or ethical concernss"),
              eachAboutUsSection(
                  title: "Our mission",
                  subtitle:
                      "Our mission is to create an ideal research project experience for clients in different professional fields, schools, and diverse courses of study. We do this by seamlessly connecting you with a network of savant researchers and offering a curated repository of affordable and plagiarism-free researcher materials for reference and insights"),
              eachAboutUsSection(
                  title: "Our vision",
                  subtitle:
                      "Our vision is to be the world's most trusted one-stop-shop for research projects"),
              eachAboutUsSection(
                  title: "Who we serve",
                  subtitle:
                      "We serve you; professional practitioners and students, recognizing your unique needs\nProfessionals: NGOs, Research Institutes, Foundations, Development Bodies, Companies, Government Agencies, Students: undergraduate, master, and postgraduate students\nOur purpose is to make your research projects too easy by putting them in the hands of professionals"),
              eachAboutUsSection(
                  title: "Our Focus",
                  subtitle:
                      "Any research endeavor and related.\nFor professionals, all your research, surveys, periodic updates, and more\nFor students, your thesis or research projects, group works, assignments, and mores")
            ],
          )),
    );
  }
}

Column eachAboutUsSection({required String title, required String subtitle}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
              child: TextOf(
            title,
            16.sp,
            6,
            align: TextAlign.left,
          )),
        ],
      ),
      YMargin(7.sp),
      Row(
        children: [
          Expanded(child: TextOf(subtitle, 16.sp, 4, align: TextAlign.left))
        ],
      ),
      YMargin(15.sp)
    ],
  );
}
