import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/provider/auth_provider.dart';
import 'package:ug_hub/screens/home_screen.dart';

class AuthMethods {
  final _auth = FirebaseAuth.instance;
  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => const HomeScreen()),
                (route) => false);
          });
        },
        verificationFailed: (FirebaseAuthException exp) {
          Navigator.pop(context);
          showSnackbar(context, exp.toString());
        },
        codeSent: (String verificationCode, int? resentToken) {
          Provider.of<AuthProvider>(context, listen: false).verificationCode =
              verificationCode;
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (builder) => OtpScreen(phoneNo: phoneNumber)));
        },
        codeAutoRetrievalTimeout: (String verificationCode) {
          Provider.of<AuthProvider>(context, listen: false).verificationCode =
              verificationCode;
        },
        timeout: const Duration(minutes: 2));
  }

  loginWithOtp(
      {required String verificationCode,
      required String smsCode,
      required BuildContext context}) async {
    try {
      await _auth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationCode, smsCode: smsCode))
          .then((value) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (builder) => const HomeScreen()),
              (route) => false));
    } catch (e) {
      showSnackbar(context, "Invalid OTP");
    }
  }
}
