import 'package:flutter/material.dart';

class HeadingTextWidget extends StatelessWidget {
  final String text;
  const HeadingTextWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: Color(0xff4338CA), fontSize: 30, fontWeight: FontWeight.w500),
    );
  }
}
