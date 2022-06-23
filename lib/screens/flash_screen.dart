import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/auth_methods.dart';
import 'package:ug_hub/model/user_model.dart';
// import 'package:ug_hub/provider/auth_provider.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/utils/color.dart';

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
      body: Center(
        child: LoadingAnimationWidget.fourRotatingDots(
            color: primaryColor, size: 50),
      ),
    );
  }
}
