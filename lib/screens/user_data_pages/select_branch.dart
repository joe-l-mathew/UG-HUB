// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/admin/add_branch.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/provider/branch_provider.dart';
import 'package:ug_hub/provider/university_provider.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/screens/user_data_pages/select_university_screen.dart';
import 'package:ug_hub/widgets/button_filled.dart';
import 'package:ug_hub/widgets/heading_text_widget.dart';

import '../../provider/auth_provider.dart';
import '../../utils/color.dart';
import '../../widgets/university_tile_widget.dart';

class SelectBranchScreen extends StatelessWidget {
  const SelectBranchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String uid = Provider.of<UserProvider>(context).userModel!.uid;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton:
          Provider.of<UserProvider>(context).userModel!.isAdmin != null
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    addBranch(context);
                  })
              : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              color: primaryColor,
              onPressed: () {
                Provider.of<BranchProvider>(context, listen: false)
                    .setBranchId(null);
                Provider.of<BranchProvider>(context, listen: false)
                    .setBranchModel(null);
                Provider.of<BranchProvider>(context, listen: false)
                    .setBranchName(null);

                Provider.of<UniversityProvider>(context, listen: false)
                    .setSelectedIndex(null);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const SelectUniversityScreen()),
                    (route) => false);
              },
              icon: const Icon(Icons.edit))
        ],
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
                              consIndex: index,
                              text: snap['Display name'],
                              imageUrl: snap['logo uri'],
                              subtitle: "",
                              onPressed: () {
                                Provider.of<UniversityProvider>(context,
                                        listen: false)
                                    .setSelectedIndex(index);
                                Provider.of<BranchProvider>(context,
                                        listen: false)
                                    .setBranchName(snap['name']);
                                //getting branch id
                                Provider.of<BranchProvider>(context,
                                        listen: false)
                                    .setBranchId(snapshot.data!.docs[index].id);
                              }),
                        );
                      }),
                ),
                Consumer<BranchProvider>(builder:
                    (BuildContext context, BranchProvider val, widget) {
                  return Container(
                    child: val.selectedBranchName == null
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
                                      val.selectedBranchName!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    ButtonFilled(
                                        text: 'Next',
                                        onPressed: () async {
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .isLoadingFun(true);
                                          await Firestoremethods()
                                              .addBranchToFirestore(
                                                  branchId: Provider.of<
                                                              BranchProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedBranchDocId!,
                                                  context: context);
                                          Provider.of<BranchProvider>(context,
                                                  listen: false)
                                              .setBranchId(null);
                                          Provider.of<BranchProvider>(context,
                                                  listen: false)
                                              .setBranchModel(null);
                                          Provider.of<BranchProvider>(context,
                                                  listen: false)
                                              .setBranchName(null);

                                          Provider.of<UniversityProvider>(
                                                  context,
                                                  listen: false)
                                              .setSelectedIndex(null);
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .isLoadingFun(false);
                                        })
                                  ],
                                ),
                                const SizedBox(
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
