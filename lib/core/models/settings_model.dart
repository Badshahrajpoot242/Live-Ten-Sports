class SettingsModel {
  final String appName;
  final String appLogoUrl;
  final String backgroundImageUrl;
  final String primaryColor;
  final String privacyPolicyUrl;
  final String whatsappNumber;
  final String version;
  final bool maintenance;
  final bool forceUpdate;

  SettingsModel({
    required this.appName,
    required this.appLogoUrl,
    required this.backgroundImageUrl,
    required this.primaryColor,
    required this.privacyPolicyUrl,
    required this.whatsappNumber,
    required this.version,
    required this.maintenance,
    required this.forceUpdate,
  });

  factory SettingsModel.fromMap(Map<dynamic, dynamic> map) {
    return SettingsModel(
      appName: map['app_name'] ?? 'Cricket Live HD',
      appLogoUrl: map['app_logo_url'] ?? '',
      backgroundImageUrl: map['background_image_url'] ?? '',
      primaryColor: map['primary_color'] ?? '#FF1744',
      privacyPolicyUrl: map['privacy_policy_url'] ?? '',
      whatsappNumber: map['whatsapp_number'] ?? '',
      version: map['version'] ?? '1.0.0',
      maintenance: map['maintenance_mode'] == true,
      forceUpdate: map['force_update'] == true,
    );
  }
}
