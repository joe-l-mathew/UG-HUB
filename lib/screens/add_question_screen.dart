import 'package:flutter/material.dart';

import '../widgets/add_material_types_widgets.dart';

class AddQuestionPaperScreen extends StatelessWidget {
  const AddQuestionPaperScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Upload Question Paper"),
        ),
        body: Column(
          children:const [
            SizedBox(),
            Expanded(
                child: AddPdfPage(
              isQuestions: true,
            ))
          ],
        ));
  }
}