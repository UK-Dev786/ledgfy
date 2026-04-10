import 'package:flutter/material.dart';

enum AppFont { inter, sourceSans, urdu }

class MyText extends StatelessWidget {
  final String text;
  final AppFont font;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;

  const MyText(
    this.text, {
    super.key,
    this.font = AppFont.inter,
    this.size,
    this.color,
    this.weight,
    this.align,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
  });

  String get _fontFamily {
    switch (font) {
      case AppFont.inter:
        return 'Inter';
      case AppFont.sourceSans:
        return 'SourceSans3';
      case AppFont.urdu:
        return 'NotoNastaliqUrdu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      textDirection: font == AppFont.urdu ? TextDirection.rtl : TextDirection.ltr,
      style: TextStyle(
        fontFamily: _fontFamily,
        fontSize: size,
        color: color,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        height: height,
      ),
    );
  }
}
