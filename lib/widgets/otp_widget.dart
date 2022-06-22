import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isLast;
  final bool isFirst;

  const OtpWidget(
      {Key? key,
      this.isLast = false,
      this.isFirst = false,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextFormField(
        autofocus: isFirst,
        controller: controller,
        onChanged: (value) {
          if (isLast == false) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          }
          if (isFirst == false) {
            if (value.isEmpty) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headline6,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
      ),
    );
  }
}
