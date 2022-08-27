// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/model/branch_model.dart';
import 'package:ug_hub/widgets/button_filled.dart';
import 'package:ug_hub/widgets/custom_input_field.dart';
import 'package:ug_hub/widgets/heading_text_widget.dart';

import '../provider/auth_provider.dart';

void addBranch(BuildContext context) {
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController numberOfSemesterController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController logoUrlNameController = TextEditingController();
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
                const HeadingTextWidget(text: "Add Branch"),

                //full name
                CustomInputField(
                    maxLength: null,
                    inputController: displayNameController,
                    textaboveBorder: "Display name",
                    prefixText: '',
                    hintText: 'Enter short branch name',
                    keybordType: TextInputType.text),
                //short name
                CustomInputField(
                    maxLength: null,
                    inputController: nameController,
                    textaboveBorder: "Full name",
                    prefixText: '',
                    hintText: 'Enter Full branch name',
                    keybordType: TextInputType.text),
                //Logo Url
                CustomInputField(
                    maxLength: null,
                    inputController: logoUrlNameController,
                    textaboveBorder: "Logo Url",
                    prefixText: '',
                    hintText: 'Enter Logo Image Url',
                    keybordType: TextInputType.text),
                CustomInputField(
                    maxLength: null,
                    inputController: numberOfSemesterController,
                    textaboveBorder: "Number of semester",
                    prefixText: '',
                    hintText: 'Enter number of semester',
                    keybordType:
                        const TextInputType.numberWithOptions(decimal: false)),

                ButtonFilled(
                    text: "Add",
                    onPressed: () async {
                      if (logoUrlNameController.text.isNotEmpty &&
                          displayNameController.text.isNotEmpty &&
                          nameController.text.isNotEmpty &&
                          numberOfSemesterController.text.isNotEmpty) {
                        Provider.of<AuthProvider>(context, listen: false)
                            .isLoadingFun(true);
                        await Firestoremethods().addBranchModel(
                          BranchModel(
                              displayName: displayNameController.text,
                              name: nameController.text,
                              logoUrl: logoUrlNameController.text,
                              numberOfSemester:
                                  numberOfSemesterController.text),
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
