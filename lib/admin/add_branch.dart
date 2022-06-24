import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/widgets/button_filled.dart';
import 'package:ug_hub/widgets/custom_input_field.dart';
import 'package:ug_hub/widgets/heading_text_widget.dart';

import '../provider/auth_provider.dart';

void addBranch(BuildContext context) {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _logoUrlNameController = TextEditingController();
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                HeadingTextWidget(text: "Add Branch"),

                //full name
                CustomInputField(
                    maxLength: null,
                    inputController: _displayNameController,
                    textaboveBorder: "Display name",
                    prefixText: '',
                    hintText: 'Enter short branch name',
                    keybordType: TextInputType.text),
                //short name
                CustomInputField(
                    maxLength: null,
                    inputController: _nameController,
                    textaboveBorder: "Full name",
                    prefixText: '',
                    hintText: 'Enter Full branch name',
                    keybordType: TextInputType.text),
                //Logo Url
                CustomInputField(
                    maxLength: null,
                    inputController: _logoUrlNameController,
                    textaboveBorder: "Logo Url",
                    prefixText: '',
                    hintText: 'Enter Logo Image Url',
                    keybordType: TextInputType.text),

                ButtonFilled(
                    text: "Add",
                    onPressed: () async {
                      if (_logoUrlNameController.text.isNotEmpty &&
                          _displayNameController.text.isNotEmpty &&
                          _nameController.text.isNotEmpty) {
                        Provider.of<AuthProvider>(context, listen: false)
                            .isLoadingFun(true);
                        await Firestoremethods().addBranchModel(
                          _displayNameController.text,
                          _nameController.text,
                          _logoUrlNameController.text,
                          context,
                        );
                        Provider.of<AuthProvider>(context, listen: false)
                            .isLoadingFun(false);
                        Navigator.pop(builder);
                      } else {
                        Navigator.pop(builder);
                        showSnackbar(builder, "Please Fill all Fields");
                      }
                    })
              ],
            ),
          ),
        );
      });
}
