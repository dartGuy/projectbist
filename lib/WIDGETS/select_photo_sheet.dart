// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:project_bist/PROVIDERS/cloudinary_upload/cloudinary_upload.dart';
import 'package:project_bist/THEMES/app_themes.dart';
import 'package:project_bist/UTILS/methods.dart';
import 'package:project_bist/WIDGETS/iconss.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';

class SelectPhotoOptions extends StatefulWidget {
  SelectPhotoOptions(
      {super.key, required this.onFileGotten, required this.onAvatarUrlGotten});
  void Function(File) onFileGotten;
  void Function(String) onAvatarUrlGotten;
  @override
  State<SelectPhotoOptions> createState() => _SelectPhotoOptionsState();
}

class _SelectPhotoOptionsState extends State<SelectPhotoOptions> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            decoration: BoxDecoration(
                color: AppThemeNotifier.themeColor(context)
                    .scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: TextOf("Select upload option", 13, 5)),
                  const YMargin(20),
                  clickOption(
                      icon: Icons.photo_camera_outlined,
                      text: "Take photo",
                      onTap: () {
                        Navigator.pop(context);
                        AppMethods.pickImage(ImageSource.camera)
                            .then((value) async {
                          if (value != null) {
                            String avatarUrl = "";
                            UploadToCloudinaryProvider.uploadDocument(context,
                                    localFilePath: value.path)
                                .then((value) {
                              setState(() {
                                avatarUrl = value;
                              });
                              print(
                                  "--profile picturrrrrrrrrrrrrrrr $avatarUrl ");
                              widget.onAvatarUrlGotten(avatarUrl);
                            });
                            widget.onFileGotten(value);
                          }
                        });
                      }),
                  const YMargin(30),
                  clickOption(
                      icon: Icons.photo_library_outlined,
                      text: "Select from gallery",
                      onTap: () {
                        Navigator.pop(context);
                        AppMethods.pickImage(ImageSource.gallery)
                            .then((value) async {
                          if (value != null) {
                            String avatarUrl = "";
                            UploadToCloudinaryProvider.uploadDocument(context,
                                    localFilePath: value.path)
                                .then((value) {
                              avatarUrl = value;
                              widget.onAvatarUrlGotten(avatarUrl);
                            });
                            widget.onFileGotten(value);
                          }
                        });
                      }),
                  const YMargin(5)
                ])));
  }
}

InkWell clickOption(
    {required IconData icon,
    required String text,
    required VoidCallback onTap}) {
  return InkWell(
    child: Row(
      children: [
        IconOf(icon, size: 20),
        const XMargin(10),
        TextOf(text, 12, 4)
      ],
    ),
    onTap: () {
      onTap();
    },
  );
}
