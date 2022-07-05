import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:ug_hub/admob/admob_provider.dart';
import 'package:ug_hub/firebase/firestore_methods.dart';

class AdManager {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // void loadBannerAd() {
  //   _bannerAd = BannerAd(
  //     adUnitId: Platform.isIOS ? "ca-app-pub-3940256099942544/2934735716" : "ca-app-pub-3940256099942544/6300978111",
  //     size: AdSize.banner,
  //     request: const AdRequest(),
  //     listener: const BannerAdListener(),
  //   );

  //   _bannerAd?.load();
  // }

  void loadRewardedAd(BuildContext context) async {
    print("Call reached -------------------------------");
    await RewardedAd.load(
        adUnitId: "ca-app-pub-3940256099942544/5224354917",
        // "ca-app-pub-8232424078858151/2941845534",
        request: const AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          print('Loaded----------------------');
          Provider.of<AdmobProvider>(context, listen: false).setAdd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          print(error.message + "---------------------------");
          _rewardedAd = null;
        }));
  }

  void showRewardedAd(BuildContext context) {
    RewardedAd? rewadd = Provider.of<AdmobProvider>(context, listen: false).add;
    if (rewadd != null) {
      rewadd.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (RewardedAd ad) {},
          onAdDismissedFullScreenContent: (RewardedAd ad) {
            ad.dispose();
            loadRewardedAd(context);
          },
          onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
            ad.dispose();
            loadRewardedAd(context);
          });

      rewadd.setImmersiveMode(true);
      rewadd.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
        Provider.of<AdmobProvider>(context, listen: false).setAdd = null;
        await Firestoremethods().addTime(context);
        await Firestoremethods().getUserDetail(context);
      });
    }
  }

  void disposeAds() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
