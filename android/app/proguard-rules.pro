
# Keep Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
# Keep Better Player & ExoPlayer
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**
# Keep Google Mobile Ads
-keep public class com.google.android.gms.ads.** { public *; }
