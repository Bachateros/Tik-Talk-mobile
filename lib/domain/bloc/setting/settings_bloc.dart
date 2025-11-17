import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/entities/app_settings.dart';
import 'package:tik_talk/domain/repositories/settings_repository.dart';

part 'settings_state.dart';
part 'settings_events.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repo;


  SettingsBloc({required this.repo}) : super(SettingsState.initial()) {
    on<LoadSettingsEvent>(_onLoad);
    on<SaveSettingsEvent>(_onSave);
    on<UpdateSettingsEvent>(_onUpdate);
  }


  Future<void> _onLoad(
  LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(loading: true));
    final settings = await repo.loadSettings();
    emit(state.copyWith(loading: false, settings: settings));
  }


  Future<void> _onSave(
  SaveSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(loading: true));
    await repo.saveSettings(event.settings);
    emit(state.copyWith(loading: false, saved: true));
  }


  void _onUpdate( UpdateSettingsEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(settings: event.settings));
  }
} 