import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_bist/MODELS/topics_model/explore_topics_model.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/UTILS/profile_image.dart';
import 'package:project_bist/VIEWS/researchers_profile_screen/researchers_profile_screen.dart';
import 'package:project_bist/WIDGETS/app_divider.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';
import "package:timeago/timeago.dart" as timeago;
import "package:project_bist/MODELS/user_profile/user_profile.dart";

// ignore: must_be_immutable
class TopicDisplayItem extends StatefulWidget {
  bool? isFromAdmin, hasDivider;
  ExploreTopicsModel? topicModel;
  TopicDisplayItem(
      {this.isFromAdmin = false,
      this.hasDivider = false,
      this.topicModel,
      super.key});

  @override
  State<TopicDisplayItem> createState() => _TopicDisplayItemState();
}

class _TopicDisplayItemState extends State<TopicDisplayItem> {
  @override
  Widget build(BuildContext context) {
    Researcher? researcher = widget.topicModel!.researcherId;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        widget.isFromAdmin == true
            ? () {}
            // String fullName;
            // String userName;
            // String email;
            // String phoneNumber;
            // String faculty;
            // String institutionName;
            // String institutionCategory;
            // String institutionOwnership;
            // String educationLevel;
            // String experience;
            // String division;
            // String sector;
            // String avatar;
            : navigate(researcher);
      },
      child: Column(
        children: [
          Row(
            children: [
              // CircleAvatar(
              //   radius: 7.5.sp,
              //   backgroundImage: AssetImage(isFromAdmin == true
              //       ? ImageOf.profileIconn
              //       : ImageOf.profilePic1),
              // ),
              widget.isFromAdmin == true
                  ? Image.asset(ImageOf.profilePic1)
                  : buildProfileImage(
                      imageUrl: widget.topicModel!.researcherId!.avatar!,
                      radius: 25,
                      fontSize: 9.sp,
                      fontWeight: 6,
                      fullNameTobSplit:
                          widget.topicModel!.researcherId!.fullName!),
              XMargin(4.sp),
              TextOf(
                  widget.isFromAdmin == true
                      ? "Submitted by Admin"
                      : widget.topicModel!.researcherId!.fullName!,
                  12,
                  6),
              XMargin(7.sp),
              TextOf(
                "●",
                5,
                5,
              ),
              XMargin(7.sp),
              IconOf(
                Icons.visibility,
                size: 15,
                color: AppThemeNotifier.colorScheme(context).primary,
              ),
              XMargin(3.sp),
              TextOf(widget.topicModel!.views.toString(), 12, 4),
              XMargin(7.sp),
              TextOf(
                "●",
                5,
                5,
              ),
              XMargin(7.sp),
              TextOf("${widget.topicModel!.likes} Likes", 12, 4),
            ],
          ),
          YMargin(12.sp),
          Row(
            children: [
              Expanded(
                  child: TextOf(
                widget.topicModel!.topic!,
                16,
                6,
                align: TextAlign.left,
              ))
            ],
          ),
          YMargin(3.sp),
          Row(
            children: [
              TextOf(
                timeago
                        .format(DateTime.parse(
                            widget.topicModel!.createdAt.toString()))[0]
                        .toUpperCase() +
                    timeago
                        .format(DateTime.parse(
                            widget.topicModel!.createdAt.toString()))
                        .substring(1),
                12,
                4,
                align: TextAlign.left,
              ),
              XMargin(7.sp),
              TextOf(
                "●",
                5,
                5,
                color: AppThemeNotifier.colorScheme(context).primary,
              ),
              XMargin(7.sp),
              IconOf(
                Icons.thumb_up_outlined,
                size: 12,
                color: AppThemeNotifier.colorScheme(context).primary,
              ),
            ],
          ),
          YMargin(4.5.sp),
          widget.hasDivider == true ? AppDivider() : const SizedBox.shrink()
        ],
      ),
    );
  }

  navigate(Researcher? researcher) {
    if (researcher != null) {
      Navigator.pushNamed(
          context, ResearchersProfileScreen.researchersProfileScreen,
          arguments: UserProfile(
            avatar: researcher.avatar,
            fullName: researcher.fullName,
            username: researcher.userName,
            email: researcher.email,
            phoneNumber: researcher.phoneNumber,
            faculty: researcher.faculty,
            institutionName: researcher.institutionName,
            institutionCategory: researcher.institutionCategory,
            institutionOwnership: researcher.institutionOwnership,
            educationalLevel: researcher.educationLevel,
            experience: researcher.experience,
            division: researcher.division,
            department: researcher.division,
            sector: researcher.sector,
          ));
    }
  }
}
