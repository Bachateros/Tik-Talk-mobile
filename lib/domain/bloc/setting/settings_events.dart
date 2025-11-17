part of 'settings_bloc.dart';


abstract class SettingsEvent {}


class LoadSettingsEvent extends SettingsEvent {}
class SaveSettingsEvent extends SettingsEvent {
final AppSettings settings;
SaveSettingsEvent(this.settings);
}
class UpdateSettingsEvent extends SettingsEvent {
final AppSettings settings;
UpdateSettingsEvent(this.settings);
}