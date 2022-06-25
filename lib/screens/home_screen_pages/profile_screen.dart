import 'package:flutter/material.dart';
import 'package:ug_hub/firebase/auth_methods.dart';
import 'package:ug_hub/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
            onPressed: () async {
              await AuthMethods().signoutUser(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => LoginScreen()),
                  (route) => false);
            },
            icon: Icon(Icons.logout)),
      ),
    );
  }
}
