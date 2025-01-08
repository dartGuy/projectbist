// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:project_bist/THEMES/app_themes.dart';
export "package:project_bist/SERVICES/api_service.dart";

/// ==============================[App Fonts]===================
/// ==============================[App Fonts]===================
/// ==============================[App Fonts]===================
class Fonts {
  /// =============================[New Fonts]
  static const String montserrat = "MontserratAlternates";
  static const String nunito = "Nunito";

  /// =============================[Old Fonts]
  static const String roboto = "Roboto";
  static const String inter = "Inter";
}

/// ==============================[Font Weights]===================
/// ==============================[Font Weights]===================
/// ==============================[Font Weights]===================
Map<int, FontWeight> fontWighgt = {
  0: FontWeight.normal,
  1: FontWeight.w100,
  2: FontWeight.w200,
  3: FontWeight.w300,
  4: FontWeight.w400,
  5: FontWeight.w500,
  6: FontWeight.w600,
  7: FontWeight.w700,
  8: FontWeight.w800,
  9: FontWeight.w900,
  10: FontWeight.bold,
};

/// ==============================[Text Widget]===================
/// ==============================[Text Widget]===================
/// ==============================[Text Widget]===================
class TextOf extends StatelessWidget {
  TextOf(this.text, this.size, this.weight,
      {this.align = TextAlign.center,
      this.textOverflow = TextOverflow.visible,
      this.color,
      this.fontFamily = Fonts.nunito,
      this.maxLines,
      this.height,
      this.fontStyle,
      this.decoration = TextDecoration.none,
      this.letterSpacing = 0,
      this.wordSpacing = 0,
      super.key});
  String text, fontFamily;

  Color? color;
  TextAlign align;
  double? size, height;
  TextDecoration decoration;
  FontStyle? fontStyle;
  int? weight, maxLines;
  double? wordSpacing;
  double? letterSpacing;

  TextOverflow textOverflow;
  @override
  Widget build(BuildContext context) {
    assert(fontWighgt.containsKey(weight), "Only font weight 0-10 is allowed");
    return Text(text,
        maxLines: maxLines,
        textAlign: align,
        overflow: textOverflow,
        style: TextStyle(
            wordSpacing: wordSpacing,
            height: height,
            fontStyle: fontStyle,
            decorationColor:
                color ?? AppThemeNotifier.colorScheme(context).primary,
            decoration: decoration,
            color: color ?? AppThemeNotifier.colorScheme(context).primary,
            fontSize: size!,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            fontWeight: fontWighgt[weight ?? 4]));
  }
}
