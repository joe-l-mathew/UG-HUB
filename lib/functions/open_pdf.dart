import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/constants/hive.dart';
import 'package:ug_hub/functions/snackbar_model.dart';
import 'package:ug_hub/main.dart';
import '../admob/admob_class.dart';
import '../admob/admob_provider.dart';
// import '../provider/user_provider.dart';
import '../utils/color.dart';
import '../widgets/dialouge_widget.dart';

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
  //open file from cache storage
  FileInfo? cachedFile = await DefaultCacheManager()
      .getFileFromCache(snapshot.data!.docs[index]['fileUrl']);
  //if cached data available display it
  if (cachedFile != null) {
    // print("From cache");

    OpenFile.open(cachedFile.file.path);
    if (cachedFile.file.path.contains("pptx")) {
      showSnackbar(
          context, "Try instaling google slides if you dont have a ppt viewer",
          duration: 2);
    }
  }
  //if no cache found check for add and download
  else {
    if (hivebox.get(hiveAddNumberKey) != null &&
        hivebox.get(hiveAddNumberKey) >= 2 &&
        Provider.of<AdmobProvider>(context, listen: false).add != null) {
      // print("Time to show add");
      showDialog(
          context: context,
          builder: (dialougeBuilder) {
            return DialougeWidget(
              yesText: "Continue",
              noText: "Cancel",
              onYes: () {
                AdManager().showRewardedAd(context);
                Navigator.pop(dialougeBuilder);
              },
              onNO: () {
                Navigator.pop(dialougeBuilder);
              },
              icon: const FaIcon(FontAwesomeIcons.rectangleAd),
              tittleText: "Download quota finished !",
              subText: "Get 2 downloads with an ad",
            );
          });
    } else {
      try {
        await pr.show();
        var file = await DefaultCacheManager()
            .getSingleFile(snapshot.data!.docs[index]['fileUrl']);

        var existing = hivebox.get(hiveAddNumberKey);
        if (existing != null) {
          hivebox.put(hiveAddNumberKey, existing + 1);
          // print('-----------------' + hivebox.get(hiveAddNumberKey).toString());
          if (hivebox.get(hiveAddNumberKey) >= 2 &&
              Provider.of<AdmobProvider>(context, listen: false).add == null) {
            // print("Load now");
            AdManager().loadRewardedAd(context);
          }
        } else {
          hivebox.put(hiveAddNumberKey, 1);
          // print(hivebox.get(hiveAddNumberKey));
        }
        await pr.hide();
        try {
          OpenFile.open(
            file.path,
          );
          if (file.path.contains("pptx")) {
            showSnackbar(context,
                "Try instaling google slides if you dont have a ppt viewer",
                duration: 2);
          }
        } on Exception catch (e) {
          // TODO
          print("object");
        }
      } on Exception {
        await pr.hide();

        showSnackbar(context, "Please connect to internet and retry");
      }
    }
  }
}
