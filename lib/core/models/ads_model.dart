class AdsModel {
  final String admobAppId;
  final String bannerAdUnitId;
  final String interstitialAdUnitId;
  final String appOpenAdUnitId;
  final String rewardedAdUnitId;
  final bool showBanner;
  final bool showInterstitial;
  final bool showAppOpen;
  final int interstitialClickCount;

  AdsModel({
    required this.admobAppId,
    required this.bannerAdUnitId,
    required this.interstitialAdUnitId,
    required this.appOpenAdUnitId,
    required this.rewardedAdUnitId,
    required this.showBanner,
    required this.showInterstitial,
    required this.showAppOpen,
    required this.interstitialClickCount,
  });

  factory AdsModel.fromMap(Map<dynamic, dynamic> map) {
    return AdsModel(
      admobAppId: map['admob_app_id'] ?? '',
      bannerAdUnitId: map['banner_ad_unit_id'] ?? '',
      interstitialAdUnitId: map['interstitial_ad_unit_id'] ?? '',
      appOpenAdUnitId: map['app_open_ad_unit_id'] ?? '',
      rewardedAdUnitId: map['rewarded_ad_unit_id'] ?? '',
      showBanner: map['show_banner'] == true,
      showInterstitial: map['show_interstitial'] == true,
      showAppOpen: map['show_app_open'] == true,
      interstitialClickCount: (map['interstitial_click_count'] ?? 3) as int,
    );
  }
}
