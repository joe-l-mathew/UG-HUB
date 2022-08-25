import 'package:flutter/cupertino.dart';

const String placementIdconst = "interstetial";

class UnityProvider with ChangeNotifier {
  bool isAdLoaded = false;
  setAdLoadedStat(bool isLoaded) {
    isAdLoaded = isLoaded;
    notifyListeners();
  }
}
