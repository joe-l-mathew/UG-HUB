import 'package:flutter/material.dart';
import 'package:ug_hub/firebase/auth_methods.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await AuthMethods().signoutUser(context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text("Home Page"),
      ),
    );
  }
}
