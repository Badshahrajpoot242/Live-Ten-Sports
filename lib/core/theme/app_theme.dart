
import 'package:cricket_live_hd/core/models/settings_model.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData create(SettingsModel? settings) {
    final primary = settings?.primaryColor != null ? HexColor.fromHex(settings!.primaryColor) : Colors.redAccent;
    return ThemeData.dark().copyWith(
      primaryColor: primary,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: ThemeData.dark().textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
      colorScheme: ColorScheme.dark(primary: primary),
    );
  }
}

// Utility to parse hex color
class HexColor extends Color {
  HexColor(final int hexColor) : super(hexColor);

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
