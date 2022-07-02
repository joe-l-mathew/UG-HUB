import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/auth_methods.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/screens/login_screen.dart';
import 'package:ug_hub/screens/user_data_pages/select_branch.dart';

import '../user_data_pages/select_university_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    UserModel? _user = Provider.of<UserProvider>(context).userModel;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(179, 182, 186, 236),
                    borderRadius: BorderRadius.all(Radius.circular(14))),
                // height: 300,
                child: Column(
                  children: [
                    ListTile(
                      leading: SizedBox(
                        width: 50,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://profilemagazine.com/wp-content/uploads/2020/04/Ajmere-Dale-Square-thumbnail.jpg"))),
                          ),
                        ),
                      ),
                      title: Text(_user!.name!),
                      subtitle:
                          Text(_auth.currentUser!.phoneNumber!.substring(3)),
                      trailing: IconButton(
                        onPressed: () async {
                          await AuthMethods().signoutUser(context);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const LoginScreen()),
                              (route) => false);
                        },
                        icon: const Icon(Icons.logout),
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      title: const Text("University: "),
                      subtitle: _user.universityName != null
                          ? Text(_user.universityName!)
                          : const Text('Not selected'),
                    ),
                    ListTile(
                      title: const Text("Branch: "),
                      subtitle: _user.branchName != null
                          ? Text(_user.branchName!)
                          : const Text('Not selected'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              ListTile(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const SelectUniversityScreen()),
                      (route) => false);
                },
                leading: const Icon(Icons.edit),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                tileColor:const Color.fromARGB(179, 182, 186, 236),
                title:const Text('Edit University'),
              ),
              const SizedBox(
                height: 3,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => SelectBranchScreen()));
                },
                leading: Icon(Icons.edit),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                tileColor: Color.fromARGB(179, 182, 186, 236),
                title: Text('Edit Branch'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
