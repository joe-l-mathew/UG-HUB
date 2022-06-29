import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/provider/upload_pdf_provider.dart';
import 'package:ug_hub/utils/color.dart';
import 'package:ug_hub/widgets/custom_input_field.dart';

import '../functions/pick_pdf_file.dart';

final pdfNameController = TextEditingController();

class AddPdfPage extends StatelessWidget {
  AddPdfPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomInputField(
                maxLength: null,
                inputController: pdfNameController,
                textaboveBorder: "Name",
                prefixText: '',
                hintText: 'Enter a display name',
                keybordType: TextInputType.text),
          ),
          DialogFb1(),
          // Provider.of<UploadPdfProvider>(context).selectedPdfName != null
          //     ? Padding(
          //         padding: const EdgeInsets.only(left: 70, right: 70),
          //         child: ButtonFilled(text: "Upload", onPressed: () {}),
          //       )
          //     : SizedBox(
          //         width: 20,
          //       )
        ],
      ),
    );
  }
}

//custom widget to upload
class DialogFb1 extends StatelessWidget {
  const DialogFb1({Key? key}) : super(key: key);

  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
                backgroundColor: primaryColor,
                radius: 25,
                child: Icon(Icons.cloud_upload)),
            const SizedBox(
              height: 15,
            ),
            Provider.of<UploadPdfProvider>(context).selectedPdfName == null
                ? const Text("Select a pdf file",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold))
                : Text(
                    Provider.of<UploadPdfProvider>(context, listen: false)
                        .selectedPdfName!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 3.5,
            ),
            const Text("Upload a file lessthan 5MB",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w300)),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SimpleBtn1(
                  text: "Select",
                  onPressed: () {
                    pickPdfFile(context);
                  },
                  invertedColors:
                      Provider.of<UploadPdfProvider>(context).selectedPdfName !=
                          null,
                ),
                Provider.of<UploadPdfProvider>(context).selectedPdfName != null
                    ? SimpleBtn1(
                        text: "Upload",
                        onPressed: () async {
                          if (pdfNameController.text.isNotEmpty) {
                            Provider.of<UploadPdfProvider>(context,
                                    listen: false)
                                .setInputFileName = pdfNameController.text;
                            await Firestoremethods().addPdftoDatabase(context);
                            showSnackbar(context, "Uploaded Successfully");
                            Navigator.pop(context);
                          } else {
                            showSnackbar(context, "Please fill File Name");
                            // Provider.of<UploadPdfProvider>(context,
                            //         listen: false)
                            //     .setInputFileName = "pdf name";
                            // Firestoremethods().addPdftoDatabase(context);
                          }
                        },
                        invertedColors: false)
                    : SimpleBtn1(
                        text: "Upload",
                        onPressed: () {
                          showSnackbar(
                              context, "Select a file before uploading");
                        },
                        invertedColors: true),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SimpleBtn1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool invertedColors;
  const SimpleBtn1(
      {required this.text,
      required this.onPressed,
      this.invertedColors = false,
      Key? key})
      : super(key: key);
  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            alignment: Alignment.center,
            side: MaterialStateProperty.all(
                BorderSide(width: 1, color: primaryColor)),
            padding: MaterialStateProperty.all(
                const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0)),
            backgroundColor: MaterialStateProperty.all(
                invertedColors ? accentColor : primaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            )),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: invertedColors ? primaryColor : accentColor, fontSize: 16),
        ));
  }
}

class AddYoutubeUrlPage extends StatelessWidget {
  final pdfNameController = TextEditingController();
  AddYoutubeUrlPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomInputField(
              maxLength: null,
              inputController: pdfNameController,
              textaboveBorder: "Link",
              prefixText: '',
              hintText: 'Enter youtube Link',
              keybordType: TextInputType.text)
        ],
      ),
    );
  }
}

class AddOtherLinkPage extends StatelessWidget {
  final pdfNameController = TextEditingController();
  AddOtherLinkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomInputField(
              maxLength: null,
              inputController: pdfNameController,
              textaboveBorder: "Link",
              prefixText: '',
              hintText: 'Enter other links',
              keybordType: TextInputType.text)
        ],
      ),
    );
  }
}




// class UploadPdfWidget extends StatelessWidget {
//   const UploadPdfWidget({Key? key}) : super(key: key);
//   final primaryColor = const Color(0xff4338CA);
//   final accentColor = const Color(0xffffffff);

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Container(
//         width: MediaQuery.of(context).size.width / 1.4,
//         height: MediaQuery.of(context).size.height / 4,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//                 backgroundColor: primaryColor,
//                 radius: 25,
//                 child: const Icon(Icons.cloud_upload)),
//             const SizedBox(
//               height: 15,
//             ),
//             Provider.of<UploadPdfProvider>(context).selectedPdfName == null
//                 ? const Text("Select a pdf file",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold))
//                 : Text(
//                     Provider.of<UploadPdfProvider>(context, listen: false)
//                         .selectedPdfName!,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold)),
//             const SizedBox(
//               height: 3.5,
//             ),
//             const Text("please upload files less than 5MB",
//                 style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w300)),
//             const SizedBox(
//               height: 15,
//             ),
//             Container(
//               height: 50,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   SimpleBtn1(
//                     text: "Select",
//                     onPressed: () {
//                       pickPdfFile(context);
//                     },
//                     invertedColors:
//                         Provider.of<UploadPdfProvider>(context).file != null,
//                   ),
//                   SimpleBtn1(
//                     text: "Upload",
//                     onPressed: () {},
//                     invertedColors:
//                         Provider.of<UploadPdfProvider>(context).file == null,
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SimpleBtn1 extends StatelessWidget {
//   final String text;
//   final Function() onPressed;
//   final bool invertedColors;
//   const SimpleBtn1(
//       {required this.text,
//       required this.onPressed,
//       this.invertedColors = false,
//       Key? key})
//       : super(key: key);
//   final primaryColor = const Color(0xff4338CA);
//   final accentColor = const Color(0xffffffff);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         style: ButtonStyle(
//             elevation: MaterialStateProperty.all(0),
//             alignment: Alignment.center,
//             side: MaterialStateProperty.all(
//                 BorderSide(width: 1, color: primaryColor)),
//             padding: MaterialStateProperty.all(
//                 const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0)),
//             backgroundColor: MaterialStateProperty.all(
//                 invertedColors ? accentColor : primaryColor),
//             shape: MaterialStateProperty.all(
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             )),
//         onPressed: onPressed,
//         child: Text(
//           text,
//           style: TextStyle(
//               color: invertedColors ? primaryColor : accentColor, fontSize: 16),
//         ));
//   }
// }
