import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/provider/add_module_toggle_provider.dart';
import 'package:ug_hub/utils/color.dart';
import '../widgets/add_material_types_widgets.dart';
import '../widgets/toogle_button_widget.dart';

class AddMaterialsScreen extends StatelessWidget {
  AddMaterialsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> listOfUploads = [
      AddPdfPage(),
      AddYoutubeUrlPage(context: context),
      AddOtherLinkPage(
        context: context,
      )
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Upload material"),
        backgroundColor: primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          // Align(
          //     alignment: Alignment.bottomLeft,
          //     child: HeadingTextWidget(text: " Add material")),
          ToggleTextButtonWidget(
            multipleSelectionsAllowed: false,
            selected: (no) {
              Provider.of<AddModuleToggleProvider>(context, listen: false)
                  .setSelectedField = no;
            },
            texts: const [
              Text("PDF"),
              Text("Youtube"),
              Text("Other"),
            ],
          ),
          listOfUploads[
              Provider.of<AddModuleToggleProvider>(context).selectedField]
        ],
      ),
    );
  }
}
