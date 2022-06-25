import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/provider/auth_provider.dart';
import 'package:ug_hub/widgets/button_filled.dart';
import 'package:ug_hub/widgets/heading_text_widget.dart';
import 'package:ug_hub/widgets/custom_input_field.dart';

class EnterNameScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  EnterNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
              ),
              const HeadingTextWidget(text: "Welcome"),
              Container(
                height: 20,
              ),
              CustomInputField(
                  keybordType: TextInputType.name,
                  maxLength: null,
                  inputController: _nameController,
                  textaboveBorder: "Name",
                  prefixText: "",
                  hintText: "Enter your name"),
              Expanded(child: Container()),
              Center(
                child: ButtonFilled(
                    text: "Next",
                    onPressed: () async {
                      if (_nameController.text.isEmpty) {
                        showSnackbar(context, "Please enter a valid name");
                      } else {
                        //close keyboard
                        FocusManager.instance.primaryFocus?.unfocus();
                        Provider.of<AuthProvider>(context, listen: false)
                            .isLoadingFun(true);
                        await Firestoremethods()
                            .addNameToFirestore(_nameController.text, context);
                        Provider.of<AuthProvider>(context, listen: false)
                            .isLoadingFun(false);
                      }
                    }),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
