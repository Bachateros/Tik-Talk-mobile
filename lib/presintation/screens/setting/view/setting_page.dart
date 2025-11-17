import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/setting/settings_bloc.dart';
import 'package:tik_talk/domain/entities/app_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки приложения')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state.loading && state.settings == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = AppSettings(notificationsEnabled: true, useBiometrics: false, language: 'ru');

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Основное',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              SwitchListTile(
                value: settings.notificationsEnabled,
                title: const Text('Уведомления'),
                onChanged: (v) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingsEvent(
                          settings.copyWith(notificationsEnabled: v),
                        ),
                      );
                },
              ),

              SwitchListTile(
                value: settings.useBiometrics,
                title: const Text('Биометрия'),
                onChanged: (v) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingsEvent(
                          settings.copyWith(useBiometrics: v),
                        ),
                      );
                },
              ),

              const Divider(),

              const Text(
                'Язык',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              DropdownButton<String>(
                value: settings.language,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'ru', child: Text('Русский')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (v) {
                  if (v != null) {
                    context.read<SettingsBloc>().add(
                          UpdateSettingsEvent(
                            settings.copyWith(language: v),
                          ),
                        );
                  }
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  context
                      .read<SettingsBloc>()
                      .add(SaveSettingsEvent(settings));
                },
                child: const Text('Сохранить настройки'),
              ),
            ],
          );
        },
      ),
    );
  }
}
