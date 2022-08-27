// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/utils/color.dart';

void showSemesterBottomSheet(BuildContext context) async {
  var semesterList = Firestoremethods().getSemesterList(context);
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      isDismissible: Provider.of<UserProvider>(context, listen: false)
              .userModel!
              .semester !=
          null,
      enableDrag: Provider.of<UserProvider>(context, listen: false)
              .userModel!
              .semester !=
          null,
      context: context,
      builder: (builder) {
        return SizedBox(
          height: 600,
          child: StreamBuilder(
              stream: semesterList,
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.halfTriangleDot(
                        color: primaryColor, size: 30),
                  );
                }

                return ListView.separated(
                    itemBuilder: (BuildContext context1, int index) {
                      return ListTile(
                        onTap: () async {
                          await Firestoremethods().addSemesterToUser(
                            context,
                            semesterId: snapshot.data!.docs[index].id,
                            // semesterId: semesterList.docs[index].id,
                            semesterName: snapshot.data!.docs[index]['name'],
                          );
                          Navigator.pop(context1);
                        },
                        title: Text(snapshot.data!.docs[index].data()['name']),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemCount: snapshot.data!.docs.length);
              }),
        );
      });
}
