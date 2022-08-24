// import 'package:flutter/cupertino.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:provider/provider.dart';
// import 'package:ug_hub/admob/admob_provider.dart';
// import 'package:ug_hub/firebase/firestore_methods.dart';
// import 'package:ug_hub/functions/snackbar_model.dart';

// import '../constants/hive.dart';
// import '../main.dart';

// class AdManager {
//   BannerAd? _bannerAd;
//   InterstitialAd? _interstitialAd;
//   RewardedAd? _rewardedAd;

//   // void loadBannerAd() {
//   //   _bannerAd = BannerAd(
//   //     adUnitId: Platform.isIOS ? "ca-app-pub-3940256099942544/2934735716" : "ca-app-pub-3940256099942544/6300978111",
//   //     size: AdSize.banner,
//   //     request: const AdRequest(),
//   //     listener: const BannerAdListener(),
//   //   );

//   //   _bannerAd?.load();
//   // }
// //fun for loading add
//   void loadRewardedAd(BuildContext context, {bool isrecall = false}) async {
//     // print('called');
//     String? adid = await Firestoremethods().getAdId();
//     if (adid != null) {
//       await RewardedAd.load(
//         //add id here
//         adUnitId: "ca-app-pub-3940256099942544/5224354917",
//         request: const AdRequest(),
//         rewardedAdLoadCallback:
//             RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
//           _rewardedAd = ad;
//           Provider.of<AdmobProvider>(context, listen: false).setAdd = ad;
//         }, onAdFailedToLoad: (LoadAdError error) {
//           Provider.of<AdmobProvider>(context, listen: false).setAdd = null;
//           _rewardedAd = null;
//         }),
//       );
//     }
//   }

//   void showRewardedAd(BuildContext context) {
//     RewardedAd? rewadd = Provider.of<AdmobProvider>(context, listen: false).add;
//     if (rewadd != null) {
//       rewadd.fullScreenContentCallback = FullScreenContentCallback(
//           onAdShowedFullScreenContent: (RewardedAd ad) {},
//           onAdDismissedFullScreenContent: (RewardedAd ad) {
//             ad.dispose();
//             // hivebox.put(hiveAddNumberKey, 2);
//             // Provider.of<AdmobProvider>(context, listen: false).setAdd = null;
//             loadRewardedAd(context, isrecall: true);
//           },
//           onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//             ad.dispose();
//             // hivebox.put(hiveAddNumberKey, 2);
//             // Provider.of<AdmobProvider>(context, listen: false).setAdd = null;
//             loadRewardedAd(context, isrecall: true);
//           });

//       rewadd.setImmersiveMode(true);
//       rewadd.show(
//           onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
//         // print('no sceen');
//         Provider.of<AdmobProvider>(context, listen: false).setAdd = null;
//         hivebox.put(hiveAddNumberKey, 0);
//         showSnackbar(context, "Recived 4 hours and 2 downloads as reward");
//         await Firestoremethods().addTime(context);
//         await Firestoremethods().getUserDetail(context);
//       });
//     }
//   }

//   void disposeAds() {
//     _bannerAd?.dispose();
//     _interstitialAd?.dispose();
//     _rewardedAd?.dispose();
//   }
// }
