import 'package:flutter/cupertino.dart';

class ModuleIdProvider with ChangeNotifier {
  String? moduleid;
  setModuleId(setid) {
    moduleid = setid;
    notifyListeners();
  }
}
