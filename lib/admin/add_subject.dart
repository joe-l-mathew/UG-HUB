import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/model/branch_model.dart';
import 'package:ug_hub/widgets/button_filled.dart';
import 'package:ug_hub/widgets/custom_input_field.dart';
import 'package:ug_hub/widgets/heading_text_widget.dart';

import '../provider/auth_provider.dart';

void addSubject(BuildContext context) {
  final TextEditingController _shortNameController = TextEditingController();
  final TextEditingController _numberOfModuleController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
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
                const SizedBox(
                  height: 20,
                ),
                const HeadingTextWidget(text: "Add Subject"),

                //short name
                CustomInputField(
                    maxLength: null,
                    inputController: _shortNameController,
                    textaboveBorder: "Short name",
                    prefixText: '',
                    hintText: 'Enter short branch name',
                    keybordType: TextInputType.text),
                //full name
                CustomInputField(
                    maxLength: null,
                    inputController: _nameController,
                    textaboveBorder: "Full name",
                    prefixText: '',
                    hintText: 'Enter full subject name',
                    keybordType: TextInputType.text),
                //Logo Url
                // CustomInputField(
                //     maxLength: null,
                //     inputController: _logoUrlNameController,
                //     textaboveBorder: "Logo Url",
                //     prefixText: '',
                //     hintText: 'Enter Logo Image Url',
                //     keybordType: TextInputType.text),
                CustomInputField(
                    maxLength: null,
                    inputController: _numberOfModuleController,
                    textaboveBorder: "Number of module",
                    prefixText: '',
                    hintText: 'Enter number of module',
                    keybordType:
                        const TextInputType.numberWithOptions(decimal: false)),

                ButtonFilled(
                    text: "Add",
                    onPressed: () async {
                      if (_shortNameController.text.isNotEmpty &&
                          _nameController.text.isNotEmpty &&
                          _numberOfModuleController.text.isNotEmpty) {
                        Provider.of<AuthProvider>(context, listen: false)
                            .isLoadingFun(true);
                        // await Firestoremethods().addBranchModel(
                        //   BranchModel(
                        //       displayName: _displayNameController.text,
                        //       name: _nameController.text,
                        //       logoUrl: _logoUrlNameController.text,
                        //       numberOfSemester:
                        //           _numberOfSemesterController.text),
                        //   context,
                        // );
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
