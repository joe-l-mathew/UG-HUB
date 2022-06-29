import 'package:flutter/cupertino.dart';
import 'package:ug_hub/model/module_model.dart';

class ModuleModelProvider with ChangeNotifier {
  ModuleModel? _moduleModel;
  set setModuleModel(ModuleModel setVal) {
    _moduleModel = setVal;
    notifyListeners();
  }

  ModuleModel? get getModuleModel {
    return _moduleModel;
  }
}
