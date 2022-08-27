// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/auth_methods.dart';
import 'package:ug_hub/functions/check_internet.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/provider/auth_provider.dart';
import 'package:ug_hub/utils/color.dart';
import 'package:ug_hub/widgets/button_filled.dart';
import 'package:ug_hub/widgets/heading_text_widget.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNo;
  const OtpScreen({Key? key, required this.phoneNo}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  callAuthMethods() async {
    await AuthMethods().verifyPhoneNumber(widget.phoneNo, context);
  }

  @override
  void initState() {
    callAuthMethods();
    super.initState();
  }

  final TextEditingController otpController = TextEditingController();

  final FocusNode _pinPutFocusNode = FocusNode();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      color: const Color.fromARGB(136, 226, 223, 223),
      border: Border.all(color: primaryColor),
      borderRadius: BorderRadius.circular(7),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: primaryColor),
        elevation: 0,
        backgroundColor: Colors.white10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingTextWidget(text: 'Verify OTP'),

            Text("We've sent it on ${widget.phoneNo} ",
                style: const TextStyle(fontSize: 10)),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 15,
            ),
            //Add otp field here
            Pinput(
              androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsRetrieverApi,
              focusNode: _pinPutFocusNode,
              // errorText: "fff",
              defaultPinTheme: defaultPinTheme,
              // forceErrorState: true,
              controller: otpController,
              autofocus: true,
              length: 6,
              onCompleted: (pin) async {
                await tryOtp(context, otpController);
              },
            ),
            TextButton(
              onPressed: () {
                showSnackbar(
                    context, "Another OTP will be sent after two minutes");
              },
              child: const Text("Resent OTP"),
            ),
            Expanded(child: Container()),
            Consumer<AuthProvider>(builder: (buildContext, value, widget) {
              return Center(
                  child: value.verificationCode != null
                      ? ButtonFilled(
                          text: "Submit OTP",
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            String finalTxt = otpController.text;
                            if (finalTxt.length != 6) {
                              showSnackbar(context, "Please fill all fields!");
                            } else {
                              tryOtp(context, otpController);
                              //get otp here
                            }
                          })
                      : ButtonFilled(
                          text: '',
                          widget: LoadingAnimationWidget.waveDots(
                              color: Colors.white, size: 14),
                          onPressed: () {}));
            }),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}

Future<void> tryOtp(
    BuildContext context, TextEditingController otpController) async {
  if (Provider.of<AuthProvider>(context, listen: false).verificationCode !=
      null) {
    Provider.of<AuthProvider>(context, listen: false).isLoadingFun(true);
    bool isConnected = await checkInternet();
    if (isConnected) {
      await AuthMethods().loginWithOtp(
          context: context,
          verificationCode: Provider.of<AuthProvider>(context, listen: false)
              .verificationCode!,
          smsCode: otpController.text);
    } else {
      showSimpleNotification(
          const Text(
            'You are offline please try after connecting to internet ',
            textAlign: TextAlign.center,
          ),
          background: Colors.red,
          slideDismissDirection: DismissDirection.up,
          duration: const Duration(seconds: 5));
      Navigator.pop(context);
    }

    Provider.of<AuthProvider>(context, listen: false).isLoadingFun(false);
  } else {
    showSnackbar(context, "Please wait for the OTP");
  }
}
