# Cricket Live HD

Cricket Live HD is a Flutter app (Android) that loads all content dynamically from Firebase Realtime Database. This repository contains a full production-ready scaffold with video playback, ads, and push notifications.

## Features
- Home with 10 main category buttons (controlled from Firebase)
- Unlimited subcategories per category
- Channel lists per subcategory
- Rich player supporting: HLS/M3U8, MP4, YouTube, RTMP (VLC), WebRTC (flutter-webrtc), iframe (WebView)
- AdMob ads (Banner, Interstitial, App Open) controlled from Firebase
- Firebase Cloud Messaging (notifications + history)
- PiP support via Better Player (Android)
- Dark themed cricket UI
- All content & configuration stored in Firebase Realtime Database

## Firebase Realtime Database Structure

/settings/
  - app_name: string
  - app_logo_url: string
  - background_image_url: string
  - primary_color: string (hex)
  - privacy_policy_url: string
  - whatsapp_number: string
  - version: string
  - maintenance_mode: bool
  - force_update: bool

/categories/
  - <unique_key>:
      id: string
      title: string
      image_url: string
      description: string
      order: int
      is_active: true/false

/subcategories/
  - <unique_key>:
      id: string
      category_id: string
      title: string
      image_url: string
      description: string
      order: int
      is_active: true/false

/channels/
  - <unique_key>:
      id: string
      subcategory_id: string
      title: string
      image_url: string
      description: string
      stream_type: "m3u8" | "hls" | "mp4" | "youtube" | "rtmp" | "webrtc" | "iframe"
      stream_url: string
      user_agent: (optional)
      referer: (optional)
      is_active: true/false
      order: int

/ads/
  - admob_app_id: string
  - banner_ad_unit_id: string
  - interstitial_ad_unit_id: string
  - app_open_ad_unit_id: string
  - rewarded_ad_unit_id: string
  - show_banner: true/false
  - show_interstitial: true/false
  - show_app_open: true/false
  - interstitial_click_count: int

/notifications/
  - title
  - message
  - image_url
  - logo_url
  - click_url
  - is_active

/notifications_history/ (auto created by the app)
  - <unique_key>:
      title
      message
      image_url
      logo_url
      click_url
      timestamp
      data

## How to set up
1. Create a Firebase project and enable Realtime Database & Cloud Messaging.
2. Add Android app with package name `com.cricket.livehd` and download `google-services.json` into `android/app/`.
3. Fill `lib/firebase_options.dart` with your Firebase project values (or run `flutterfire configure`).
4. Populate the Realtime Database using the structure above.
5. Add AdMob IDs into /ads/ in Realtime Database.
6. Run `flutter pub get` and `flutter run`.

## Notes
- All runtime content is controlled by Firebase; toggling `is_active` flags hides/shows items instantly.
- Force update / maintenance mode handled by settings values: update `force_update` and `maintenance_mode`.
- Notification messages sent from Firebase Cloud Messaging should include `click_url` or `channel_id` in `data` for deep linking.
