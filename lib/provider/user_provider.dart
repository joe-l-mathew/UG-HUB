import 'package:flutter/cupertino.dart';
import 'package:ug_hub/model/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  void setUserModel({required UserModel userModelc}) {
    userModel = userModelc;
    notifyListeners();
  }
}
