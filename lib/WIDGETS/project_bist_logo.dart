import 'package:flutter/material.dart';
import 'package:project_bist/UTILS/images.dart';

@immutable
class ProjectBistLogo extends StatelessWidget {
  final double? size;
  final String? imageName;
  const ProjectBistLogo({this.size = 150, this.imageName, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageName ?? ImageOf.logo,
      height: size!,
    );
  }
}
