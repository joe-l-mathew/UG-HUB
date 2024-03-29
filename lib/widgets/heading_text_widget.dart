import 'package:flutter/material.dart';
import 'package:ug_hub/utils/color.dart';

class HeadingTextWidget extends StatelessWidget {
  final String text;
  final double fontsize;
  const HeadingTextWidget({
    Key? key,
    required this.text,
    this.fontsize = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: primaryColor, fontSize: fontsize, fontWeight: FontWeight.w500),
    );
  }
}
