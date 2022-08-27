// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/model/subject_model.dart';
import 'package:ug_hub/widgets/button_filled.dart';
import 'package:ug_hub/widgets/custom_input_field.dart';
import 'package:ug_hub/widgets/heading_text_widget.dart';
import '../provider/auth_provider.dart';

void addSubject(BuildContext context) {
  final TextEditingController shortNameController = TextEditingController();
  final TextEditingController numberOfModuleController =
      TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController syllabusLinkController = TextEditingController();
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
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const HeadingTextWidget(text: "Add Subject"),

                //short name
                CustomInputField(
                    maxLength: null,
                    inputController: shortNameController,
                    textaboveBorder: "Short name",
                    prefixText: '',
                    hintText: 'Enter short subject name',
                    keybordType: TextInputType.text),
                //full name
                CustomInputField(
                    maxLength: null,
                    inputController: fullNameController,
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
                    inputController: numberOfModuleController,
                    textaboveBorder: "Number of module",
                    prefixText: '',
                    hintText: 'Enter number of module',
                    keybordType:
                        const TextInputType.numberWithOptions(decimal: false)),
                //add link
                CustomInputField(
                    maxLength: null,
                    inputController: syllabusLinkController,
                    textaboveBorder: "Sylabus",
                    prefixText: '',
                    hintText: 'Enter sylabus drive link(make visible on)',
                    keybordType: TextInputType.text),

                ButtonFilled(
                    text: "Add",
                    onPressed: () async {
                      if (shortNameController.text.isNotEmpty &&
                          fullNameController.text.isNotEmpty &&
                          numberOfModuleController.text.isNotEmpty &&
                          // ignore: duplicate_ignore, duplicate_ignore
                          syllabusLinkController.text.isNotEmpty) {
                        Provider.of<AuthProvider>(context, listen: false)
                            .isLoadingFun(true);
                        await Firestoremethods().addModule(
                            context,
                            SubjectModel(
                                syllabusLink: syllabusLinkController.text,
                                shortName: shortNameController.text,
                                fullname: fullNameController.text,
                                numberOfModule:
                                    numberOfModuleController.text));
                        // await Firestoremethods().addBranchModel(
                        //   BranchModel(
                        //       displayName: _displayNameController.text,
                        //       name: _nameController.text,
                        //       logoUrl: _logoUrlNameController.text,
                        //       numberOfSemester:
                        //           _numberOfSemesterController.text),
                        //   context,
                        // );
                        // ignore: use_build_context_synchronously
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
