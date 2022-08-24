import 'package:flutter/cupertino.dart';

const String placementIdconst = "rewarded1";

class UnityProvider with ChangeNotifier {
  bool isAdLoaded = false;
  setAdLoadedStat(bool isLoaded) {
    isAdLoaded = isLoaded;
    notifyListeners();
  }
}
