import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/utils/color.dart';

import '../model/user_model.dart';
import '../provider/user_provider.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? _userModel = Provider.of<UserProvider>(context).userModel;

    return Container(
      color: primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Padding(
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
                  Text(_userModel!.name!),
                ],
              ),
            ),
          ),
          Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _userModel.profileUrl == null
                ? const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(_userModel.profileUrl!),
                  ),
          )),
        ],
      ),
    );
  }
}
