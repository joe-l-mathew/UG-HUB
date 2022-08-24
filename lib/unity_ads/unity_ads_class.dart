import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/unity_ads/unity_provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../constants/hive.dart';
import '../firebase/firestore_methods.dart';
import '../functions/snackbar_model.dart';
import '../main.dart';

class UnityClass {
  initializeAds() {
    UnityAds.init(
      testMode: true,
      gameId: '4899999',
      onComplete: () => print('Initialization Complete'),
      onFailed: (error, message) =>
          print('Initialization Failed: $error $message'),
    );
  }

  loadAds(BuildContext context) {
    print("Loading Ads started");
    UnityAds.load(
      placementId: placementIdconst,
      onComplete: (placementId) {
        print('Load Complete $placementId');
        Provider.of<UnityProvider>(context, listen: false)
            .setAdLoadedStat(true);
      },
      onFailed: (placementId, error, message) {
        print('Load Failed $placementId: $error $message');
      },
    );
  }

  playAds(BuildContext context) {
    UnityAds.showVideoAd(
      placementId: placementIdconst,
      onStart: (placementId) => print('Video Ad $placementId started'),
      onClick: (placementId) => print('Video Ad $placementId click'),
      onSkipped: (placementId) => print('Video Ad $placementId skipped'),
      onComplete: (placementId) async {
        print('Video Ad $placementId completed');
        Provider.of<UnityProvider>(context, listen: false).isAdLoaded = false;
        hivebox.put(hiveAddNumberKey, 0);
        showSnackbar(context, "Recived 4 hours and 2 downloads as reward");
        await Firestoremethods().addTime(context);
        await Firestoremethods().getUserDetail(context);
      },
      onFailed: (placementId, error, message) =>
          print('Video Ad $placementId failed: $error $message'),
    );
  }
}
