import 'dart:async';
import 'package:cricket_live_hd/core/models/ads_model.dart';
import 'package:cricket_live_hd/core/models/category_model.dart';
import 'package:cricket_live_hd/core/models/channel_model.dart';
import 'package:cricket_live_hd/core/models/settings_model.dart';
import 'package:cricket_live_hd/core/models/subcategory_model.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // Settings stream
  Stream<SettingsModel?> settingsStream() {
    return _db.child('settings').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;
      return SettingsModel.fromMap(data);
    });
  }

  // Ads stream
  Stream<AdsModel?> adsStream() {
    return _db.child('ads').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;
      return AdsModel.fromMap(data);
    });
  }

  // Categories (limit to 10 main as requested)
  Stream<List<CategoryModel>> categoriesStream() {
    return _db.child('categories').orderByChild('order').onValue.map((event) {
      final Map<dynamic, dynamic>? map = event.snapshot.value as Map<dynamic, dynamic>?;
      if (map == null) return [];
      final list = map.values.map((e) => CategoryModel.fromMap(e as Map)).toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      final active = list.where((c) => c.isActive).take(10).toList();
      return active;
    });
  }

  // Subcategories by category_id (unlimited)
  Stream<List<SubcategoryModel>> subcategoriesStream(String categoryId) {
    return _db.child('subcategories').orderByChild('order').onValue.map((event) {
      final Map<dynamic, dynamic>? map = event.snapshot.value as Map<dynamic, dynamic>?;
      if (map == null) return [];
      final list = map.values.map((e) => SubcategoryModel.fromMap(e as Map)).where((s) => s.categoryId == categoryId && s.isActive).toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      return list;
    });
  }

  // Channels by subcategory_id
  Stream<List<ChannelModel>> channelsStream(String subcategoryId) {
    return _db.child('channels').orderByChild('order').onValue.map((event) {
      final Map<dynamic, dynamic>? map = event.snapshot.value as Map<dynamic, dynamic>?;
      if (map == null) return [];
      final list = map.values.map((e) => ChannelModel.fromMap(e as Map)).where((c) => c.subcategoryId == subcategoryId && c.isActive).toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      return list;
    });
  }

  // Notifications list (history)
  Stream<List<Map<String, dynamic>>> notificationsStream() {
    return _db.child('notifications_history').orderByChild('timestamp').onValue.map((event) {
      final Map<dynamic, dynamic>? map = event.snapshot.value as Map<dynamic, dynamic>?;
      if (map == null) return [];
      final list = map.entries.map((e) {
        final val = e.value as Map<dynamic, dynamic>;
        return val.map((k, v) => MapEntry(k.toString(), v));
      }).toList();
      return list;
    });
  }
}
