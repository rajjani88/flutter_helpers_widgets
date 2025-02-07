import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsController extends GetxController {
  // Ad instances
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;

  // State variables
  var isBannerAdLoaded = false.obs;
  var isInterstitialAdLoaded = false.obs;
  var isRewardedAdLoaded = false.obs;

  // Counters
  var totalAdsShown = 0.obs;
  var coinsEarnedFromAds = 0.obs;

  // Ad unit IDs (replace these with your AdMob ad unit IDs)
  final String bannerAdUnitId = "ca-app-pub-4035340144253699/4202622430"; //live
  final String interstitialAdUnitId =
      "ca-app-pub-4035340144253699/1165934555"; //live
  final String rewardedAdUnitId =
      "ca-app-pub-4035340144253699/2618617022"; //live

  BannerAd? bannerAd1;
  BannerAd? bannerAd2;
  BannerAd? bannerAd3;

  // State variables for each banner ad
  var isBannerAd1Loaded = false.obs;
  var isBannerAd2Loaded = false.obs;
  var isBannerAd3Loaded = false.obs;

  // Ad unit IDs (replace these with your AdMob ad unit IDs)
  final String bannerAdUnitId1 =
      "ca-app-pub-4035340144253699/4233314547"; //live
  final String bannerAdUnitId2 =
      "ca-app-pub-4035340144253699/5424204768"; //live
  final String bannerAdUnitId3 = "ca-app-pub-3940256099942544/9304295312";

  @override
  void onInit() {
    super.onInit();
    _loadBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();

    _loadBannerAd1();
    _loadBannerAd2();
    _loadBannerAd3();
  }

  // Load Banner Ad
  void _loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAdLoaded.value = true;
          totalAdsShown.value++;
        },
        onAdFailedToLoad: (ad, error) {
          isBannerAdLoaded.value = false;
          ad.dispose();
          print("Banner Ad failed to load: $error");
        },
      ),
    )..load();
  }

  // Load Banner Ad 1
  void _loadBannerAd1() {
    bannerAd1 = BannerAd(
      adUnitId: bannerAdUnitId1,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAd1Loaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          isBannerAd1Loaded.value = false;
          ad.dispose();
          print("Banner Ad 1 failed to load: $error");
        },
      ),
    )..load();
  }

  // Load Banner Ad 2
  void _loadBannerAd2() {
    bannerAd2 = BannerAd(
      adUnitId: bannerAdUnitId2,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAd2Loaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          isBannerAd2Loaded.value = false;
          ad.dispose();
          print("Banner Ad 2 failed to load: $error");
        },
      ),
    )..load();
  }

  // Load Banner Ad 3
  void _loadBannerAd3() {
    bannerAd3 = BannerAd(
      adUnitId: bannerAdUnitId3,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAd3Loaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          isBannerAd3Loaded.value = false;
          ad.dispose();
          print("Banner Ad 3 failed to load: $error");
        },
      ),
    )..load();
  }

  // Load Interstitial Ad
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          isInterstitialAdLoaded.value = true;

          // Handle Ad events
          interstitialAd?.setImmersiveMode(true);
          interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) {
              interstitialAd?.dispose();
              _loadInterstitialAd(); // Preload next interstitial ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadInterstitialAd(); // Preload next interstitial ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          isInterstitialAdLoaded.value = false;
          print("Interstitial Ad failed to load: $error");
        },
      ),
    );
  }

  // Load Rewarded Ad
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          isRewardedAdLoaded.value = true;

          // Handle Ad events
          rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) {
              rewardedAd?.dispose();
              _loadRewardedAd(); // Preload next rewarded ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadRewardedAd(); // Preload next rewarded ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          isRewardedAdLoaded.value = false;
          print("Rewarded Ad failed to load: $error");
        },
      ),
    );
  }

  // Show Interstitial Ad
  void showInterstitialAd() {
    if (isInterstitialAdLoaded.value) {
      interstitialAd?.show();
      isInterstitialAdLoaded.value = false;
      totalAdsShown.value++;
    } else {
      print("Interstitial Ad not loaded yet.");
    }
  }

  // Show Rewarded Ad
  void showRewardedAd({Function()? onRewardGranted}) {
    if (isRewardedAdLoaded.value) {
      rewardedAd?.show(
        onUserEarnedReward: (ad, reward) {
          coinsEarnedFromAds.value += reward.amount.toInt();
          print("User earned ${reward.amount} coins!");
          onRewardGranted!();
        },
      );
      isRewardedAdLoaded.value = false;
      totalAdsShown.value++;
    } else {
      print("Rewarded Ad not loaded yet.");
    }
  }

  // Dispose resources
  @override
  void onClose() {
    bannerAd?.dispose();
    interstitialAd?.dispose();
    rewardedAd?.dispose();

    bannerAd1?.dispose();
    bannerAd2?.dispose();
    bannerAd3?.dispose();
    super.onClose();
  }
}
