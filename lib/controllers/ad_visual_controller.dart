import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../ad_helper.dart';

class AdAndVisualController extends GetxController {
  InterstitialAd? interstitialAd;
  InterstitialAd? interstitialVideoAd;
  RewardedAd? rewardedAd;
  bool _isRewardedAdLoaded = false;
  MainGameController mainCtrl = Get.find<MainGameController>();
  String currentPress = '';
  Rx<bool> showQR = false.obs;
  bool openDialog = false;

  bool buttonWasClick = false;
  RxDouble mainScreenShaddow = 0.0.obs;

  @override
  void onInit() async {
    await loadAudioAssets();
    _loadRewardedAd();
    super.onInit();
  }

  void _loadRewardedAd() {
    _isRewardedAdLoaded = false;
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (RewardedAd ad) {
            ad.dispose();
            rewardedAd = null;
            _loadRewardedAd();
          });
          rewardedAd = ad;
          _isRewardedAdLoaded = true;
        }, onAdFailedToLoad: (LoadAdError error) {
          print("Failed to load an rewarded ad : ${error.message}");
          rewardedAd = null;
        }));
  }

  Future<bool> lastAdAloudToShowNext() async {
    int sec = await mainCtrl.secLastAd();

    var timestampNow = Timestamp.now();
    if (timestampNow.seconds - mainCtrl.globalSettings.adInterval > sec) {
      return true;
    }
    return false;
  }

  void changeAdTimestamp() {
    mainCtrl.changeLastShowAdToNow();
  }

  void addReward() {
    mainCtrl.addReward(1);
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              Get.offNamed(Routes.GENERAL_MENU);
              interstitialAd = null;
              _loadInterstitialAd();
            },
          );

          interstitialAd = ad;
          print("Interstitial Ad Loaded");
        }, onAdFailedToLoad: (err) {
          print("Failed to load an interstitial ad: ${err.message}");
          interstitialAd = null;
        }));
  }

  void _loadInterstitialVideoAdToRivalSearch() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialVideoAdUnitId,
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              Get.toNamed(Routes.PLAY_MENU);
              interstitialVideoAd = null;
              _loadInterstitialVideoAdToRivalSearch();
            },
          );

          interstitialVideoAd = ad;
          print("Interstitial Ad Loaded");
        }, onAdFailedToLoad: (err) {
          print("Failed to load an interstitial ad: ${err.message}");
          interstitialVideoAd = null;
        }));
  }

  Future<void> pressMenuButtonEffects(String path) async {
    currentPress = path;
    buttonWasClick = true;
    await FlameAudio.play('boom1.mp3');
    for (var i = 0; i < 8; i++) {
      await Future.delayed(Duration(milliseconds: 40));
      mainScreenShaddow.value += 0.1;
      update();
    }
    await Future.delayed(Duration(milliseconds: 220));
    for (var i = 0; i < 8; i++) {
      await Future.delayed(Duration(milliseconds: 40));
      mainScreenShaddow.value -= 0.1;
      update();
    }
    if (mainScreenShaddow.value != 0.0) {
      mainScreenShaddow.value = 0.0;
    }
    currentPress = '';
    update();
    Get.toNamed(path);
    buttonWasClick = false;
  }

  //// QR ////
  void changeQrShow() {
    showQR.value = !showQR.value;
    update();
  }

  QrImageView createQR() {
    return QrImageView(
      data: mainCtrl.userName.value,
      version: QrVersions.auto,
      size: 200.0,
    );
  }

  Future<void> loadAudioAssets() async {
    await FlameAudio.audioCache.loadAll([
      'door-slide1.mp3',
      'boom1.mp3',
      'sfx_Swipe.mp3',
      'sfx_Swipe1.mp3',
      'sfx_scroll.mp3'
    ]);
  }
}
