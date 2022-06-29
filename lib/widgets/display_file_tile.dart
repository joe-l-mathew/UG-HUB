import 'package:flutter/material.dart';
import 'package:ug_hub/constants/firebase_fields.dart';
import 'package:ug_hub/utils/color.dart';

class DisplayMaterialTile extends StatelessWidget {
  final String fileName;
  final String uploadedBy;
  final String likeCount;
  final Enum fileType;
  const DisplayMaterialTile(
      {Key? key,
      required this.fileName,
      required this.uploadedBy,
      required this.likeCount,
      required this.fileType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget getSelectedIcon() {
      if (fileType == FileType.pdf) {
        return Icon(Icons.picture_as_pdf_outlined);
      } else if (fileType == FileType.youtube) {
        return Icon(Icons.youtube_searched_for);
      } else {
        return Icon(Icons.app_blocking);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CircleAvatar(
                child: getSelectedIcon(),
                backgroundColor: primaryColor,
                radius: 23,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                fileName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(uploadedBy),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
              Text(likeCount)
            ],
          )
        ]),
        decoration: const BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.white54,
          //     blurRadius: 2.0,
          //     spreadRadius: 0.0,
          //     offset: Offset(2.0, 2.0), // shadow direction: bottom right
          //   )
          // ],
          color: Color.fromARGB(179, 182, 186, 236),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        height: 200,
        width: 200,
      ),
    );
  }
}
