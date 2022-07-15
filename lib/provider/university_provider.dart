import 'package:flutter/material.dart';

class UniversityProvider with ChangeNotifier {
  int? selectedIndex;
  String? selectedUniversityName;
  String? selectedUniversityDocId;
  setUnivName(String? name) {
    selectedUniversityName = name;
    notifyListeners();
  }
//common for both branch and university
  setSelectedIndex(int? index) {
    selectedIndex = index;
    notifyListeners();
  }

  setUnivId(String? docId) {
    selectedUniversityDocId = docId;
  }
}
