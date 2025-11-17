class AppSettings {
  final bool notificationsEnabled;
  final bool useBiometrics;
  final String language;


  AppSettings({
  required this.notificationsEnabled,
  required this.useBiometrics,
  required this.language,
  });


AppSettings copyWith({
  bool? notificationsEnabled,
  bool? useBiometrics,
  String? language,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      useBiometrics: useBiometrics ?? this.useBiometrics,
      language: language ?? this.language,
    );
}
}