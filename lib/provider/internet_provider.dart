import 'package:flutter/cupertino.dart';

class InternetProvider with ChangeNotifier {
  bool isConnected = true;
  setConnecteionState(bool isconnected) {
    isConnected = isconnected;
    notifyListeners();
  }
}
