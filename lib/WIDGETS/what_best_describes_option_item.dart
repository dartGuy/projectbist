import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_bist/UTILS/images.dart';
import 'package:project_bist/WIDGETS/spacing.dart';
import 'package:project_bist/WIDGETS/texts.dart';

class WhatBestDescribesOptionItem extends StatelessWidget {
  const WhatBestDescribesOptionItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      width: double.infinity,
      height: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          SvgPicture.asset(
            ImageOf.researcher,
            semanticsLabel: 'My SVG Image',
            height: 100,
            width: 70,
          ),
          const YMargin(20),
          Row(
            children: [TextOf("Client", 18, 6)],
          )
        ],
      ),
    );
  }
}
