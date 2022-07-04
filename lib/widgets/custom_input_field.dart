import 'package:flutter/material.dart';

import '../utils/color.dart';

// ignore: must_be_immutable
class CustomInputField extends StatelessWidget {
  final TextInputType keybordType;
  final TextEditingController inputController;
  int? maxLength;
  final String textaboveBorder;
  final String prefixText;
  final String hintText;
  final bool isFocoused;
  CustomInputField(
      {Key? key,
      required this.maxLength,
      required this.inputController,
      required this.textaboveBorder,
      required this.prefixText,
      required this.hintText,
      required this.keybordType,
      this.isFocoused = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // const primaryColor = Color(0xff4338CA);
    const secondaryColor = primaryColor;
    const accentColor = Color(0xffffffff);
    // const backgroundColor = Color(0xffffffff);
    const errorColor = Color(0xffEF4444);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   textaboveBorder,
        //   style: TextStyle(
        //       fontSize: 14,
        //       fontWeight: FontWeight.normal,
        //       color: Colors.white.withOpacity(.9)),
        // ),
        const SizedBox(
          height: 8,
        ),
        Container(
          height: 90,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: const Offset(12, 26),
                blurRadius: 50,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.1)),
          ]),
          child: TextFormField(
            autofocus: isFocoused,
            maxLength: maxLength,
            controller: inputController,
            onChanged: (value) {
              //Do something wi
            },
            keyboardType: keybordType,
            style: const TextStyle(fontSize: 15, color: Colors.black),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
              prefix: Text(
                prefixText,
                style: const TextStyle(color: Colors.black),
              ),
              label: Text(textaboveBorder),
              labelStyle: const TextStyle(color: primaryColor),
              // prefixIcon: Icon(Icons.email),
              filled: true,
              fillColor: accentColor,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
              // contentPadding:
              //     const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: errorColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
