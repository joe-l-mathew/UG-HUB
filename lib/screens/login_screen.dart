import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/functions/check_internet.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/provider/auth_provider.dart';
import 'package:ug_hub/provider/internet_provider.dart';
import 'package:ug_hub/screens/otp_screen.dart';

import 'package:ug_hub/widgets/button_filled.dart';

import '../widgets/heading_text_widget.dart';
import '../widgets/custom_input_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _phoneNumberController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.indigo),
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
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomInputField(
                  keybordType: TextInputType.phone,
                  maxLength: 10,
                  inputController: _phoneNumberController,
                  hintText: "Mobile number",
                  prefixText: "+91 ",
                  textaboveBorder: 'Phone'),
              Expanded(
                child: Container(),
              ),
              Center(
                child: ButtonFilled(
                    text: "Continue",
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (_phoneNumberController.text.length != 10) {
                        showSnackbar(context, "Enter a valid phone number");
                      } else {
                        Provider.of<AuthProvider>(context, listen: false)
                            .isLoadingFun(true);
                        bool isConnected = await checkInternet();
                        Provider.of<AuthProvider>(context, listen: false)
                            .isLoadingFun(false);
                        try {
                          if (isConnected) {
                            int.parse(_phoneNumberController.text);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => OtpScreen(
                                        phoneNo: _phoneNumberController.text)));
                          } else {
                            showSimpleNotification(
                                const Text(
                                  'You are offline please try after connecting to internet ',
                                  textAlign: TextAlign.center,
                                ),
                                background: Colors.red,
                                slideDismissDirection: DismissDirection.up,
                                duration: const Duration(seconds: 5));
                          }
                        } catch (e) {
                          showSnackbar(context, "Enter a valid phone number");
                        }
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
