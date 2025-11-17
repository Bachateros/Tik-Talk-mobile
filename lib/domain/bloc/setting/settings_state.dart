part of 'settings_bloc.dart';

class SettingsState {
final bool loading;
final AppSettings? settings;
final bool saved;


SettingsState({
required this.loading,
required this.settings,
required this.saved,
});


factory SettingsState.initial() => SettingsState(
loading: false,
settings: null,
saved: false,
);


SettingsState copyWith({
bool? loading,
AppSettings? settings,
bool? saved,
}) {
return SettingsState(
loading: loading ?? this.loading,
settings: settings ?? this.settings,
saved: saved ?? this.saved,
);
}
}