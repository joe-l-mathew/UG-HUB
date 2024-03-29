// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/auth_methods.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/check_internet.dart';
import 'package:ug_hub/functions/sent_email.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/screens/login_screen.dart';
import 'package:ug_hub/screens/user_data_pages/select_branch.dart';
import 'package:ug_hub/screens/view_reports.dart';
import 'package:ug_hub/widgets/dialouge_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../edit_profile_screen.dart';
import '../user_data_pages/select_university_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    UserModel? user = Provider.of<UserProvider>(context).userModel;
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
                                  onPressed: () async {
                                    bool connection =
                                        await isNetworkAvailable(context);

                                    if (connection) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  const EditProfile()));
                                    }
                                  },
                                  icon: const Icon(Icons.edit)),
                              leading: SizedBox(
                                  width: 50,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Hero(
                                      tag: "Profile pic",
                                      child: user!.profileUrl == null
                                          ? const CircleAvatar(
                                              child: Icon(Icons.person),
                                            )
                                          : CircleAvatar(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      179, 182, 186, 236),
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      user.profileUrl!),
                                            ),
                                    ),
                                  )),
                              title: Text(user.name!),
                              subtitle: Text(
                                  auth.currentUser!.phoneNumber!.substring(3)),
                            ),
                            ListTile(
                              title: const Text("University: "),
                              subtitle: user.universityName != null
                                  ? Text(user.universityName!)
                                  : const Text('Not selected'),
                            ),
                            ListTile(
                              title: const Text("Branch: "),
                              subtitle: user.branchName != null
                                  ? Text(user.branchName!)
                                  : const Text('Not selected'),
                            ),
                            user.college == null || user.college!.isEmpty
                                ? const SizedBox()
                                : ListTile(
                                    title: const Text("College: "),
                                    subtitle: user.college != null
                                        ? Text(user.college!)
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(179, 182, 186, 236),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          minVerticalPadding: 0,
                          onTap: () async {
                            bool connection = await isNetworkAvailable(context);

                            if (connection) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const SelectUniversityScreen()),
                                  (route) => false);
                            }
                          },
                          leading: const Icon(Icons.edit),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          // tileColor: const Color.fromARGB(179, 182, 186, 236),
                          title: const Text('Edit University'),
                        ),
                        const Divider(),
                        ListTile(
                          onTap: () async {
                            bool connection = await isNetworkAvailable(context);

                            if (connection) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const SelectBranchScreen()));
                            }
                          },
                          leading: const Icon(Icons.edit),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          // tileColor: const Color.fromARGB(179, 182, 186, 236),
                          title: const Text('Edit Branch'),
                        ),
                        // const SizedBox(
                        //   height: 3,
                        // ),

                        // const SizedBox(
                        //   height: 3,
                        // ),
                        const Divider(),
                        ListTile(
                          onTap: () {
                            setEmailToAdmin(subject: "Hello UG-HUB");
                          },
                          leading: const Icon(Icons.contact_mail),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          // tileColor: const Color.fromARGB(179, 182, 186, 236),
                          title: const Text('Contact us'),
                        ),
                        // const SizedBox(
                        //   height: 3,
                        // ),
                        const Divider(),
                        ListTile(
                          onTap: () {
                            try {
                              launchUrl(
                                  Uri.parse(
                                      'http://www.instagram.com/ug___hub'),
                                  mode:
                                      LaunchMode.externalNonBrowserApplication);
                            } catch (e) {
                              showSnackbar(
                                  context, "Unable to load in this device");
                            }
                          },
                          leading: const FaIcon(FontAwesomeIcons.instagram),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          // tileColor: const Color.fromARGB(179, 182, 186, 236),
                          title: const Text(
                            'Follow us on Instagram',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // const SizedBox(
                        //   height: 3,
                        // ),
                        const Divider(),
                        ListTile(
                          onTap: () async {
                            bool connection = await isNetworkAvailable(context);

                            if (connection) {
                              //view reports
                              showDialog(
                                  context: context,
                                  builder: (builderContext) {
                                    return DialougeWidget(
                                        yesText: "Delete",
                                        noText: "Cancel",
                                        onYes: () async {
                                          await Firestoremethods()
                                              .deleteUser(context);
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
                                        tittleText: "Do you want to Delete",
                                        subText:
                                            'all your uploads and chats remains');
                                  });
                            }
                          },
                          leading: const Icon(
                            (Icons.delete),
                            // color: Colors.,
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          // tileColor: const Color.fromARGB(179, 182, 186, 236),
                          title: const Text('Delete my account'),
                        ),
                        // const SizedBox(
                        //   height: 3,
                        // ),
                        const Divider(),
                        ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (builderContext) {
                                  return DialougeWidget(
                                      yesText: "Sign out",
                                      noText: "Cancel",
                                      onYes: () async {
                                        await AuthMethods()
                                            .signoutUser(context);
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          // tileColor: const Color.fromARGB(179, 182, 186, 236),
                          title: const Text('Logout'),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  ListTile(
                    isThreeLine: true,
                    onTap: () {
                      setEmailToAdmin(
                          subject:
                              "Hello UG Hub Sub:Startup idea or Collge Project assistence");
                    },
                    // leading: const Icon(Icons.assistant),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    tileColor: const Color.fromARGB(179, 182, 186, 236),
                    title: const Text(
                        'For soaftware assistence related to startup or college projects Contact us'),
                    subtitle: const Text(
                        "We provide free overhead work for potential startups, College projects will be done in sheduled time and teaching of the tool will be done."),
                  ),

                  // const SizedBox(
                  //   height: 3,
                  // ),
                  // const Divider(),
                  user.isAdmin == true
                      ? ListTile(
                          onTap: () async {
                            bool connection = await isNetworkAvailable(context);

                            if (connection) {
                              //view reports
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const ViewReportScreen()));
                            }
                          },
                          leading: const Icon(Icons.report),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          tileColor: const Color.fromARGB(179, 182, 186, 236),
                          title: const Text('View reports'),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> isNetworkAvailable(BuildContext context) async {
  bool isconnected = await checkInternet();

  if (!isconnected) {
    showSimpleNotification(
        const Text(
          'You are not connected to internet!',
          textAlign: TextAlign.center,
        ),
        background: Colors.red,
        slideDismissDirection: DismissDirection.up,
        duration: const Duration(seconds: 5));
  }
  return isconnected;
}
