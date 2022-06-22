import 'package:flutter/material.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/widgets/button_filled.dart';
import 'package:ug_hub/widgets/heading_text_widget.dart';

import '../widgets/otp_widget.dart';

class OtpScreen extends StatelessWidget {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();

  final String phoneNo;
  OtpScreen({Key? key, required this.phoneNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.indigo),
        elevation: 0,
        backgroundColor: Colors.white10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingTextWidget(text: 'Verify OTP'),
            Text("We've sent it on $phoneNo ",
                style: const TextStyle(fontSize: 10)),
            const SizedBox(
              height: 10,
            ),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OtpWidget(
                    controller: _controller1,
                    isFirst: true,
                  ),
                  OtpWidget(
                    controller: _controller2,
                  ),
                  OtpWidget(controller: _controller3),
                  OtpWidget(controller: _controller4),
                  OtpWidget(controller: _controller5),
                  OtpWidget(
                    controller: _controller6,
                    isLast: true,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Resent OTP"),
            ),
            Expanded(child: Container()),
            Center(
              child: ButtonFilled(
                  text: "Submit OTP",
                  onPressed: () {
                    String finalTxt = _controller1.text +
                        _controller2.text +
                        _controller3.text +
                        _controller4.text +
                        _controller5.text +
                        _controller6.text;
                    if (finalTxt.length != 6) {
                      showSnackbar(context, "Please fill all fields!");
                    } else {
                      //get otp here
                    }
                  }),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
