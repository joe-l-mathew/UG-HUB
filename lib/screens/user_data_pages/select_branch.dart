import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/admin/add_branch.dart';
import 'package:ug_hub/constants/admins.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/provider/branch_provider.dart';
import 'package:ug_hub/provider/university_provider.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/widgets/button_filled.dart';
import 'package:ug_hub/widgets/heading_text_widget.dart';

import '../../admin/add_university.dart';
import '../../utils/color.dart';
import '../../widgets/university_tile_widget.dart';

class SelectBranchScreen extends StatelessWidget {
  const SelectBranchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserProvider>(context).userModel!.uid;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: adminList.contains(uid)
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                addBranch(context);
              })
          : null,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white10,
        elevation: 0,
        title: const HeadingTextWidget(
          fontsize: 25,
          text: "Select your branch",
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collectionUniversity)
            .doc(Provider.of<UserProvider>(context).userModel!.university)
            .collection(collectionBranch)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: primaryColor, size: 50),
            );
          }
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0),
                      itemBuilder: (context, index) {
                        var snap = snapshot.data!.docs[index].data();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CardFb1(
                              text: snap['Display name'],
                              imageUrl: snap['logo uri'],
                              subtitle: "+30 books",
                              onPressed: () {
                                Provider.of<BranchyProvider>(context,
                                        listen: false)
                                    .setUnivName(snap['name']);
                                Provider.of<BranchyProvider>(context,
                                        listen: false)
                                    .setBranchId(snapshot.data!.docs[index].id);
                              }),
                        );
                      }),
                ),
                Consumer<BranchyProvider>(builder:
                    (BuildContext context, BranchyProvider val, Widget) {
                  return Container(
                    child: val.selectedUniversityName == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      val.selectedUniversityName!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    ButtonFilled(
                                        text: 'Next',
                                        onPressed: () async {
                                          await Firestoremethods()
                                              .addUniversityToFirestore(
                                                  Provider.of<BranchyProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedUniversityDocId!,
                                                  context);
                                        })
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}



//////
