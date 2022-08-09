import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/auth_provider.dart';
import 'package:ug_hub/provider/user_provider.dart';
// import 'package:ug_hub/screens/flash_screen.dart';
import 'package:ug_hub/screens/landing_page.dart';
import 'package:ug_hub/screens/login_screen.dart';
import 'package:ug_hub/screens/user_data_pages/enter_name_screen.dart';
import 'package:ug_hub/screens/user_data_pages/select_branch.dart';
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
          // print("auto capture success");
          // await _auth.signInWithCredential(credential).then((value) =>
          //     Provider.of<UserProvider>(context, listen: false)
          //         .setUserModel(userModelc: UserModel(uid: value.user!.uid)));
          // afterLoginPageRedirector(context);
          // Widget navWidget =
          //     await AuthMethods().afterLoginPageRedirector(context);
          // Navigator.pushAndRemoveUntil(context,
          //     MaterialPageRoute(builder: (builder) {
          //   return navWidget;
          // }), (route) => false);
        },
        verificationFailed: (FirebaseAuthException exp) {
          Navigator.pop(context);
          if (exp.code == 'invalid-phone-number') {
            showSnackbar(context, "Enter a valid phone number");
          } else {
            showSnackbar(context, exp.message!);
          }
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

//redirect after signing in datas like name, univ, etc will be analysed

  Future<Widget> afterLoginPageRedirector(BuildContext context) async {
    if (await _firestoreMethods.doesUserExist(context)) {
      if (await _firestoreMethods.doesBranchtExist(
          Provider.of<UserProvider>(context, listen: false).userModel!.uid,
          context)) {
        // print("Running success");
        // await _firestoreMethods.getUserDetail(context);
        // await _firestoreMethods.getBranchModel(context);
        return const LandingPage();
      }
      if (await _firestoreMethods.doesUniversityExist(
          Provider.of<UserProvider>(context, listen: false).userModel!.uid,
          context)) {
        // await _firestoreMethods.getUserDetail(context);
        return const SelectBranchScreen();
      }

      if (await _firestoreMethods.doesNameExist(
          Provider.of<UserProvider>(context, listen: false).userModel!.uid,
          context)) {
        print("Its running---------2");

        // await _firestoreMethods.getUserDetail(context);
        return const SelectUniversityScreen();
      } else {
        await _firestoreMethods.getUserDetail(context);
        return EnterNameScreen();
      }
    } else {
      print("Its running---------1");
      String _uid =
          Provider.of<UserProvider>(context, listen: false).userModel!.uid;
      // UserModel user = await UserModel(
      //     uid:
      //         Provider.of<UserProvider>(context, listen: false).userModel!.uid);
      UserModel user = UserModel(
          uid: _uid, expireTime: DateTime.now().add(const Duration(hours: 1)));
      await _firestoreMethods.addUserToFirestore(user);
      await _firestoreMethods.getUserDetail(context);
      return EnterNameScreen();
    }
  }

  //Signout User
  Future<void> signoutUser(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (builder) => const LoginScreen(),
        ),
        (route) => false);
  }

  Future<void> deleteCurrentUser() async {
    User? user = _auth.currentUser;
    await user!.delete();
  }
}
