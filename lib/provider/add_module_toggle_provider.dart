import 'package:flutter/cupertino.dart';

class AddModuleToggleProvider with ChangeNotifier {
  int selectedField = 0;
  set setSelectedField(int selectedFieldIndex) {
    selectedField = selectedFieldIndex;
    notifyListeners();
  }
}
