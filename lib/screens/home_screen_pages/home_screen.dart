import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/screens/home_screen_pages/profile_screen.dart';
import 'package:ug_hub/utils/color.dart';
import 'package:ug_hub/widgets/subject_banner.dart';
import '../../admin/add_subject.dart';
import '../../admob/admob_class.dart';
import '../../functions/show_select_semester_bottom_sheet.dart';
import '../../widgets/please_select_semester.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Firestoremethods().getSemesterList(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<UserProvider>(context, listen: false)
          .userModel!
          .expireTime!
          .isBefore(DateTime.now())) {
        AdManager().loadRewardedAd(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _userModel = Provider.of<UserProvider>(context).userModel;
    return Scaffold(
        // backgroundColor: primaryColor,
        floatingActionButton:
            Provider.of<UserProvider>(context).userModel!.isAdmin != null
                ? FloatingActionButton(
                    onPressed: () {
                      addSubject(context);
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
        body: Stack(
          children: [
            Provider.of<UserProvider>(context).userModel!.semester == null
                ? const Center(
                    child: Center(child: PleaseSelectSemester()),
                  )
                : Stack(
                    children: [
                      Container(
                        height: 180,
                        color: primaryColor,
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Welcome back,",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 16),
                                        ),
                                        Text(
                                          _userModel!.name!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    //actons here
                                  ],
                                ),
                                // Text('ME ' + ' KTU',
                                //     style: TextStyle(color: Colors.grey, fontSize: 16)),
                                // Text("KTU")

                                Text(
                                  _userModel.branchName!,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                Text(
                                  _userModel.universityName!,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              child: _userModel.profileUrl == null
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8, bottom: 35),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        ProfileScreen()));
                                          },
                                          child: const CircleAvatar(
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8, bottom: 35),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        const ProfileScreen()));
                                          },
                                          child: Hero(
                                            tag: 'Profile pic',
                                            child: _userModel.profileUrl != null
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(_userModel
                                                            .profileUrl!),
                                                  )
                                                : const CircleAvatar(
                                                    backgroundColor:
                                                        primaryColor,
                                                    child: Icon(Icons.person),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                              height: 170,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Center(
                                    child: TextButton.icon(
                                      onPressed: () {
                                        // print("tapped");
                                        showSemesterBottomSheet(context);
                                      },
                                      icon: const Icon(Icons.arrow_downward,
                                          color: primaryColor),
                                      label: Provider.of<UserProvider>(context)
                                                  .userModel!
                                                  .semester ==
                                              null
                                          ? const Text(
                                              'Select semester',
                                              style: TextStyle(
                                                  color: primaryColor),
                                            )
                                          : Text(
                                              Provider.of<UserProvider>(context,
                                                      listen: true)
                                                  .userModel!
                                                  .semesterName!,
                                              style: const TextStyle(
                                                  color: primaryColor),
                                            ),
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection(collectionUniversity)
                                        .doc(_userModel.university)
                                        .collection(collectionBranch)
                                        .doc(_userModel.branch)
                                        .collection(collectionSemester)
                                        .doc(_userModel.semester)
                                        .collection(collectionSubject)
                                        .orderBy('numberOfModule',
                                            descending: true)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: LoadingAnimationWidget
                                              .fourRotatingDots(
                                                  color: primaryColor,
                                                  size: 50),
                                        );
                                      }
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),

                                          // physics: const NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) =>
                                              SizedBox(
                                                height: 186,
                                                child: SubjectBanner(
                                                  context3: context,
                                                  subId: snapshot
                                                      .data!.docs[index].id,
                                                  indexofSubject: index,
                                                  snapshot: snapshot,
                                                ),
                                              ));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 10,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ));
  }
}
