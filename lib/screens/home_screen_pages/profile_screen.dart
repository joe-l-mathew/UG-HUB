import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/auth_methods.dart';
import 'package:ug_hub/functions/sent_email.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/screens/login_screen.dart';
import 'package:ug_hub/screens/user_data_pages/select_branch.dart';
import 'package:ug_hub/widgets/dialouge_widget.dart';
import '../edit_profile_screen.dart';
import '../user_data_pages/select_university_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    UserModel? _user = Provider.of<UserProvider>(context).userModel;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
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
                        Column(
                          children: [
                            ListTile(
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                const EditProfile()));
                                  },
                                  icon: const Icon(Icons.edit)),
                              leading: SizedBox(
                                  width: 50,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Hero(
                                      tag: "Profile pic",
                                      child: _user!.profileUrl == null
                                          ? const CircleAvatar(
                                              child: Icon(Icons.person),
                                            )
                                          : CircleAvatar(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      179, 182, 186, 236),
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      _user.profileUrl!),
                                            ),
                                    ),
                                  )),
                              title: Text(_user.name!),
                              subtitle: Text(
                                  _auth.currentUser!.phoneNumber!.substring(3)),
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
                            _user.college == null
                                ? const SizedBox()
                                : ListTile(
                                    title: const Text("College: "),
                                    subtitle: _user.college != null
                                        ? Text(_user.college!)
                                        : const Text('Not selected'),
                                  ),
                          ],
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
                              builder: (builder) =>
                                  const SelectUniversityScreen()),
                          (route) => false);
                    },
                    leading: const Icon(Icons.edit),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    tileColor: const Color.fromARGB(179, 182, 186, 236),
                    title: const Text('Edit University'),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) =>
                                  const SelectBranchScreen()));
                    },
                    leading: const Icon(Icons.edit),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    tileColor: const Color.fromARGB(179, 182, 186, 236),
                    title: const Text('Edit Branch'),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  ListTile(
                    onTap: () {
                      setEmailToAdmin(subject: "Hello UG-HUB");
                    },
                    leading: const Icon(Icons.contact_mail),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    tileColor: const Color.fromARGB(179, 182, 186, 236),
                    title: const Text('Contact us'),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (builderContext) {
                            return DialougeWidget(
                                yesText: "Sign out",
                                noText: "Cancel",
                                onYes: () async {
                                  await AuthMethods().signoutUser(context);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              const LoginScreen()),
                                      (route) => false);
                                },
                                onNO: () {
                                  Navigator.pop(builderContext);
                                },
                                icon: const Icon(Icons.logout),
                                tittleText: "Do you want to Sign out",
                                subText: 'You have to login again');
                          });
                    },
                    leading: const Icon(
                      (Icons.logout),
                      // color: Colors.,
                    ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    tileColor: const Color.fromARGB(179, 182, 186, 236),
                    title: const Text('Logout'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
