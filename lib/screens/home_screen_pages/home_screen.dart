import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/constants/admins.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/utils/color.dart';
import 'package:ug_hub/widgets/subject_banner.dart';
import '../../admin/add_subject.dart';
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
      return Provider.of<UserProvider>(context, listen: false)
              .userModel!
              .semester ??
          showSemesterBottomSheet(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _userModel = Provider.of<UserProvider>(context).userModel;
    return Scaffold(
      floatingActionButton: adminList.contains(_userModel!.uid)
          ? FloatingActionButton(
              onPressed: () {
                addSubject(context);
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: primaryColor,
            bottom: const PreferredSize(
                child: SizedBox(), preferredSize: Size.fromHeight(100)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome back,",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(_userModel.name!,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                // Text('ME ' + ' KTU',
                //     style: TextStyle(color: Colors.grey, fontSize: 16)),
                // Text("KTU")
              ],
            ),
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Container()),
                  Text(
                    _userModel.branchName!,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  Text(
                    _userModel.universityName!,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  Center(
                      child: TextButton.icon(
                          onPressed: () {
                            showSemesterBottomSheet(context);
                          },
                          icon: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                          label: Provider.of<UserProvider>(context)
                                      .userModel!
                                      .semester ==
                                  null
                              ? const Text(
                                  'Select semester',
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  Provider.of<UserProvider>(context,
                                          listen: true)
                                      .userModel!
                                      .semesterName!,
                                  style: const TextStyle(color: Colors.white),
                                )))
                ],
              ),
            ),
            actions: [
              _userModel.profileUrl == null
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(_userModel.profileUrl!),
                      ),
                    )
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              color: primaryColor,
              height: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Provider.of<UserProvider>(context).userModel!.semester == null
              ? SliverFillRemaining(
                  child: Center(child: PleaseSelectSemester()),
                )
              : SliverFillRemaining(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(collectionUniversity)
                        .doc(_userModel.university)
                        .collection(collectionBranch)
                        .doc(_userModel.branch)
                        .collection(collectionSemester)
                        .doc(_userModel.semester)
                        .collection(collectionSubject)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                              color: primaryColor, size: 50),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, indesx) => SubjectBanner());
                    },
                  ),
                )
        ],
      ),
    );
  }
}
