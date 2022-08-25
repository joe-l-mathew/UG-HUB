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
      // testMode: true,
      gameId: '4899999',
      // onComplete: () => print('Initialization Complete'),
    );

  }

  loadAds(BuildContext context) async {
    bool initStat = await UnityAds.isInitialized();
    if (initStat == true) {
      // print("Loading Ads started");
      UnityAds.load(
        placementId: placementIdconst,
        onComplete: (placementId) {
          // print('Load Complete $placementId');
          Provider.of<UnityProvider>(context, listen: false)
              .setAdLoadedStat(true);
        },
        onFailed: (placementId, error, message) {
          // print('Load Failed $placementId: $error $message');
        },
      );
    } else {
      initializeAds();
      await Future.delayed(const Duration(seconds: 10));
      loadAds(context);
    }
  }

  playAds(BuildContext context) {
    UnityAds.showVideoAd(
        placementId: placementIdconst,
        onStart: (placementId) async {
          Provider.of<UnityProvider>(context, listen: false).isAdLoaded = false;
          hivebox.put(hiveAddNumberKey, 1);
          // showSnackbar(context, "Recived 0 hours and 1 downloads as reward");
          // print('Video Ad $placementId started');
        },
        // onClick: (placementId) => print('Video Ad $placementId click'),
        onSkipped: (placementId) async {
          Provider.of<UnityProvider>(context, listen: false).isAdLoaded = false;
          hivebox.put(hiveAddNumberKey, 0);
          showSnackbar(context, "Recived 2 hours and 2 downloads as reward");
          await Firestoremethods().addTime(context, duration: 2);
          await Firestoremethods().getUserDetail(context);
          // print('Video Ad $placementId skipped');
        },
        onComplete: (placementId) async {
          // print('Video Ad $placementId completed');
          Provider.of<UnityProvider>(context, listen: false).isAdLoaded = false;
          hivebox.put(hiveAddNumberKey, -2);
          showSnackbar(context, "Recived 12 hours and 4 downloads as reward");
          await Firestoremethods().addTime(context);
          await Firestoremethods().getUserDetail(context);
        },
        onFailed: (placementId, error, message) {
          Provider.of<UnityProvider>(context, listen: false).isAdLoaded = false;
          hivebox.put(hiveAddNumberKey, 1);
        });
  }
}
