import 'package:flutter/material.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/widgets/button_filled.dart';

void showTermsAndCondition(BuildContext context, {bool isSlow = true}) async {
  if (isSlow) {
    await Future.delayed(const Duration(milliseconds: 400));
  }
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(
                child: Text(
                  "Terms and conditions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const Text(
                "1. Users are instructed to use the application only for educational purposes.",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Text(
                "2. Uploaded files could be viewed and downloaded by other users.",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Text(
                "3. Uploading or attachment of any other files or links may lead to the permanent termination of the account.",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Text(
                "4. Users should report(long tap on content) inappropriate chats and study materials.",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Text(
                "5. Don't upload any copyrighted PDF",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Text(
                "6. Any sexually explicit or abusive user-generated content in chats or materials will lead to the permanent termination of the account.",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Text(
                "User should accept all of the above terms and conditions to use the chat and add material",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Center(
                child: ButtonFilled(
                    text: "Accept",
                    onPressed: () async {
                      await Firestoremethods().termsAndConditions(context);
                      Navigator.pop(context);
                    }),
              )
            ],
          ),
        );
      });
}
