// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  final Color? titleColor;
  final String titleText;
  double titleSize;
  int? titleTextMaxLines;
  TextOverflow titleOverflow;

  TitleTextWidget({
    Key? key,
    this.titleColor,
    required this.titleText,
    this.titleSize = 0,
    this.titleTextMaxLines = 2,
    this.titleOverflow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      maxLines: titleTextMaxLines,
      overflow: titleOverflow,
      style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.w400,
          fontFamily: 'Klasik',
          fontSize: titleSize == 0 ? 20.0 : titleSize),
    );
  }
}
