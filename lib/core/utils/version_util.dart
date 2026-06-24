import 'package:package_info_plus/package_info_plus.dart';

class VersionUtil {
  static Future<String> currentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }
}
