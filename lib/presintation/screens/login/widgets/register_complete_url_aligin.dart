import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterCompleteForm extends StatelessWidget {
  final String botLink;

  const RegisterCompleteForm({super.key, required this.botLink});

  Future<void> _launchLink(BuildContext context) async {
    try {
      // Пробуем открыть ссылку напрямую
      await launchUrl(
        Uri.parse(botLink),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      // Если не получилось, показываем сообщение
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: botLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ссылка скопирована')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Регистрация успешна!',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Перейдите по ссылке, чтобы активировать Telegram-бота:',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _launchLink(context),
            child: Text(
              botLink,
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => _copyLink(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white70),
            ),
            child: const Text('Скопировать ссылку'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.read<AuthBloc>().add(AppStarted()),
          child: const Text('Закрыть', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}