import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/auth_provider.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/screens/home_screen.dart';
import 'package:ug_hub/screens/login_screen.dart';
import 'package:ug_hub/screens/user_data_pages/enterName_screen.dart';
import 'package:ug_hub/screens/user_data_pages/select_university_screen.dart';

class AuthMethods {
  final _auth = FirebaseAuth.instance;
  final _firestoreMethods = Firestoremethods();

  //Login or Signup using phonenumber
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
          Provider.of<AuthProvider>(context, listen: false)
              .setVerification(verificationCode);
        },
        codeAutoRetrievalTimeout: (String verificationCode) {
          Provider.of<AuthProvider>(context, listen: false)
              .setVerification(verificationCode);
        },
        timeout: const Duration(minutes: 2));
  }

//redirect after signing in datas like name, univ, etc will be analysed
  Future<Widget> afterLoginPageRedirector(BuildContext context) async {
    if (await _firestoreMethods.doesUserExist(
        Provider.of<UserProvider>(context, listen: false).userModel!.uid)) {
      if (await _firestoreMethods.doesUniversityExist(
          Provider.of<UserProvider>(context, listen: false).userModel!.uid)) {
        return HomeScreen();
      }

      if (await _firestoreMethods.doesNameExist(
          Provider.of<UserProvider>(context, listen: false).userModel!.uid)) {
        return SelectUniversityScreen();
      } else {
        return EnterNameScreen();
      }
    } else {
      UserModel user = UserModel(
          uid:
              Provider.of<UserProvider>(context, listen: false).userModel!.uid);
      await _firestoreMethods.addUserToFirestore(user);
      return EnterNameScreen();
    }
  }

//login code
  loginWithOtp(
      {required String verificationCode,
      required String smsCode,
      required BuildContext context}) async {
    try {
      await _auth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationCode, smsCode: smsCode))
          .then((value) => Provider.of<UserProvider>(context, listen: false)
              .setUserModel(userModelc: UserModel(uid: value.user!.uid)));

      afterLoginPageRedirector(context);
      Widget navWidget = await AuthMethods().afterLoginPageRedirector(context);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (builder) {
        return navWidget;
      }), (route) => false);

      //  Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (builder) => const HomeScreen()),
      //     (route) => false)

    } catch (e) {
      showSnackbar(context, 'Invalid OTP');
    }
  }

  //Signout User
  Future<void> signoutUser(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (builder) => LoginScreen()),
        (route) => false);
  }
}
