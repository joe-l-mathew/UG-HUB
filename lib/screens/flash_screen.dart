import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/auth_methods.dart';
// import 'package:ug_hub/utils/color.dart';

import '../model/user_model.dart';
import '../provider/user_provider.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({Key? key}) : super(key: key);

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    getRidirectPage();

    super.initState();
  }

//select page based on responce
  getRidirectPage() async {
    // ignore: await_only_futures
    String uid = await FirebaseAuth.instance.currentUser!.uid;
    UserModel userModel = UserModel(uid: uid);
    Provider.of<UserProvider>(context, listen: false)
        .setUserModel(userModelc: userModel);
    Widget page = await AuthMethods().afterLoginPageRedirector(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (builder) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(68, 56, 202, 100),
      backgroundColor: HexColor('#4438ca'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
              scale: 0.9,
            ),
            LoadingAnimationWidget.fourRotatingDots(
                color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }
}
