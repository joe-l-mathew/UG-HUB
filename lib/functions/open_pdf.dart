import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:ug_hub/functions/snackbar_model.dart';

import '../utils/color.dart';

Future<void> openPdf(
    {required BuildContext context,
    required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
    required int index}) async {
  ProgressDialog pr = ProgressDialog(context);
  pr = ProgressDialog(context,
      type: ProgressDialogType.download, isDismissible: false, showLogs: true);
  pr.style(
      message: 'Downloading file...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Center(
        child: LoadingAnimationWidget.inkDrop(color: primaryColor, size: 14),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      textAlign: TextAlign.center,
      maxProgress: 100.0,
      progressTextStyle: const TextStyle(
          color: Colors.white, fontSize: 0, fontWeight: FontWeight.w400),
      messageTextStyle: const TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
  try {
    await pr.show();
    var file = await DefaultCacheManager()
        .getSingleFile(snapshot.data!.docs[index]['fileUrl']);
    await pr.hide();
    OpenFile.open(
      file.path,
    );
  } on Exception {
    await pr.hide();

    showSnackbar(context, "Please connect to internet and retry");
  }
}
