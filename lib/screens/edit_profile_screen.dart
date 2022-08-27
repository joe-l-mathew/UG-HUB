// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/model/user_model.dart';
import 'package:ug_hub/provider/user_provider.dart';
import 'package:ug_hub/utils/color.dart';
import 'package:ug_hub/widgets/button_filled.dart';
import 'package:ug_hub/widgets/custom_input_field.dart';
import 'dart:io';
import '../functions/snackbar_model.dart';
import '../provider/auth_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _collegeController = TextEditingController();

  @override
  void initState() {
    UserModel? user =
        Provider.of<UserProvider>(context, listen: false).userModel;
    super.initState();
    if (user!.name != null) {
      _nameController.text = user.name!;
    }
    if (user.college != null) {
      _collegeController.text = user.college!;
    }
  }

  File? imageFile;
  @override
  Widget build(BuildContext context) {
    UserModel? user =
        Provider.of<UserProvider>(context, listen: false).userModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Stack(
              children: [
                imageFile != null
                    ? CircleAvatar(
                        backgroundColor: ThemeData().scaffoldBackgroundColor,
                        radius: 30,
                        backgroundImage: FileImage(imageFile!),
                      )
                    : CircleAvatar(
                        radius: 30,
                        backgroundImage: user!.profileUrl != null
                            ? NetworkImage(user.profileUrl!)
                            : null,
                        backgroundColor: user.profileUrl == null
                            ? primaryColor
                            : ThemeData().scaffoldBackgroundColor,
                        child: user.profileUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                Positioned(
                  bottom: -10,
                  left: 25,
                  child: IconButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              allowMultiple: false,
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png']);

                      if (result != null) {
                        PlatformFile file1 = result.files.first;
                        if (file1.size < 204288) {
                          final path = result.files.single.path;
                          setState(() {
                            imageFile = File(path.toString());
                          });
                        } else {
                          showSnackbar(context, "Pick a file lessthan 200 KB");
                        }
                      }
                    },
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomInputField(
                isFocoused: false,
                maxLength: null,
                inputController: _nameController,
                textaboveBorder: "Name",
                prefixText: "",
                hintText: "Enter name",
                keybordType: TextInputType.name),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomInputField(
                isFocoused: false,
                maxLength: null,
                inputController: _collegeController,
                textaboveBorder: "College name",
                prefixText: "",
                hintText: "Enter college name",
                keybordType: TextInputType.name),
          ),
          Center(
            child: ButtonFilled(
                text: "Update",
                onPressed: () async {
                  if (_nameController.text.isNotEmpty) {
                    Provider.of<AuthProvider>(context, listen: false)
                        .isLoadingFun(true);
                    await Firestoremethods().updateProfile(imageFile,
                        _nameController.text, _collegeController.text, context);
                    Provider.of<AuthProvider>(context, listen: false)
                        .isLoading = false;
                    Provider.of<AuthProvider>(context, listen: false)
                        .isLoadingFun(false);
                  } else {
                    showSnackbar(context, "Name can't be empty");
                  }
                }),
          )
        ],
      )),
    );
  }
}
