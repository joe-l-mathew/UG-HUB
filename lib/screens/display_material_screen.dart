import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/model/module_model.dart';
import 'package:ug_hub/provider/module_model_provider.dart';
import 'package:ug_hub/screens/add_materials.dart';
import 'package:ug_hub/utils/color.dart';

class DisplayMaterialsScreen extends StatelessWidget {
  const DisplayMaterialsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ModuleModel? moduleModel =
        Provider.of<ModuleModelProvider>(context).getModuleModel;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => AddMaterialsScreen()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(moduleModel!.moduleName +
              " (" +
              moduleModel.subjectShortName +
              ")")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(moduleModel.subjectName),
            Text(moduleModel.moduleName),
            Text(moduleModel.moduleId),
            Text(moduleModel.subjectId)
          ],
        ),
      ),
    );
  }
}
