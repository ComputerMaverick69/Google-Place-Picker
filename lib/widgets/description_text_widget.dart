// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class DescriptionTextWidget extends StatelessWidget {
  final Color? descriptionColor;
  final String descriptionText;
  final String fontFamily;
  double descriptionSize;
  double descriptionHeight;
  TextOverflow? descriptionOverflow;
  int? descriptionMaxLines;
  TextAlign? textAlign;

  DescriptionTextWidget(
      {Key? key,
      this.descriptionColor,
      required this.descriptionText,
      this.fontFamily = 'klasik',
      this.descriptionSize = 12,
      this.descriptionHeight = 1.2,
      this.descriptionOverflow,
      this.descriptionMaxLines,
      this.textAlign = TextAlign.justify})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      descriptionText,
      overflow: descriptionOverflow,
      maxLines: descriptionMaxLines,
      style: TextStyle(
        color: descriptionColor,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        fontSize: descriptionSize,
        height: descriptionHeight,
      ),
    );
  }
}
