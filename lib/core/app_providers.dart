import 'package:cricket_live_hd/core/models/ads_model.dart';
import 'package:cricket_live_hd/core/models/settings_model.dart';
import 'package:cricket_live_hd/core/services/firebase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Firebase service (singleton)
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

// Settings provider
final settingsProvider = StreamProvider<SettingsModel?>((ref) {
  final fs = ref.watch(firebaseServiceProvider);
  return fs.settingsStream();
});

// Ads settings
final adsProvider = StreamProvider<AdsModel?>((ref) {
  final fs = ref.watch(firebaseServiceProvider);
  return fs.adsStream();
});
