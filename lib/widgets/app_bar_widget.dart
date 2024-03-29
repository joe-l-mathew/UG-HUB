import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/utils/color.dart';

import '../model/user_model.dart';
import '../provider/user_provider.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = Provider.of<UserProvider>(context).userModel;

    return Container(
      color: primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      color: Colors.grey),
                ),
                Text(userModel!.name!),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: userModel.profileUrl == null
            ? const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              )
            : CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(userModel.profileUrl!),
              ),
          ),
        ],
      ),
    );
  }
}
