import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/provider/user_provider.dart';

void showSemesterBottomSheet(BuildContext context) async {
  var semesterList = await Firestoremethods().getSemesterList(context);
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
          child: ListView.separated(
              itemBuilder: (BuildContext context1, int index) {
                return ListTile(
                  onTap: () async {
                    await Firestoremethods().addSemesterToUser(context,
                        semesterId: semesterList.docs[index].id,
                        semesterName: semesterList.docs[index].data()['name']);
                    Navigator.pop(context1);
                  },
                  title: Text(semesterList.docs[index].data()['name']),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: semesterList.docs.length),
        );
      });
}
