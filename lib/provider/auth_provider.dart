import 'package:flutter/cupertino.dart';

class AuthProvider with ChangeNotifier {
  String? verificationCode;
  bool isLoading = false;
  isLoadingFun(bool isLoad) {
    isLoading = isLoad;
    notifyListeners();
  }

  setVerification(String verifiCode) {
    verificationCode = verifiCode;
    notifyListeners();
  }

  Widget? navPage;
  setNavPage(Widget page) {
    navPage = page;
  }
}

//isOtpLoading
