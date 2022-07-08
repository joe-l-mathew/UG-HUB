import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/model/report_model.dart';
import 'package:ug_hub/provider/auth_provider.dart';
import 'package:ug_hub/widgets/button_filled.dart';
import 'package:ug_hub/widgets/custom_input_field.dart';

class ReportScreen extends StatelessWidget {
  ReportModel reportModel;
  ReportScreen({Key? key, required this.reportModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _commentController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("Report")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            CustomInputField(
                maxLength: null,
                inputController: _commentController,
                textaboveBorder: '',
                prefixText: '',
                hintText: "Comments on report",
                keybordType: TextInputType.text),
            ButtonFilled(
                text: "Report",
                onPressed: () async {
                  Provider.of<AuthProvider>(context, listen: false)
                      .isLoadingFun(true);
                  reportModel.comment = _commentController.text;
                  await Firestoremethods().addReport(reportModel);
                  await Provider.of<AuthProvider>(context, listen: false)
                      .isLoadingFun(false);
                  showSnackbar(context, "Report submitted succesfully");
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
