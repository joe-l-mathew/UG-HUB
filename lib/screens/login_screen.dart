import 'package:flutter/material.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/screens/otp_screen.dart';
import 'package:ug_hub/widgets/button_filled.dart';
import '../widgets/heading_text_widget.dart';
import '../widgets/login_screen_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _phoneNumberController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        iconTheme:const  IconThemeData(color: Colors.indigo),
        elevation: 0,
        backgroundColor: Colors.white10,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 0,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: HeadingTextWidget(
                  text: "Enter mobile number",
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 8),
                child: Text(
                  "We'll sent an OTP for verification",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              PhoneInputField(inputController: _phoneNumberController),
              Expanded(
                child: Container(),
              ),
              Center(
                child: ButtonFilled(
                    text: "Continue",
                    onPressed: () {
                      if (_phoneNumberController.text.length != 10) {
                        showSnackbar(context, "Enter a valid phone number");
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) =>
                                OtpScreen(phoneNo: _phoneNumberController.text),
                          ),
                        );
                      }
                    }),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
