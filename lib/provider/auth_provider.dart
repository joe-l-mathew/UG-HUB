import 'package:flutter/cupertino.dart';

class AuthProvider with ChangeNotifier {
  String? verificationCode;
  bool isOtpLoading = false;
  isOtpLoadingFun(bool isLoading) {
    isOtpLoading = isLoading;
    notifyListeners();
  }
}
