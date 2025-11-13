import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
import 'package:tik_talk/domain/bloc/profile/profile_bloc.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';

part 'profile_edit_form.dart';

class ProfileViewForm extends StatelessWidget {
  const ProfileViewForm({super.key});

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return DateFormat('dd.MM.yyyy').format(d);
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.select((ProfileBloc bloc) => bloc.state.profile);
    // profile может быть null — обработаем
    final String avatarUrl = profile?.avatarUrl ?? '';
    final String name = profile?.name ?? '';
    final String surname = profile?.surname ?? '';
    final String tgName = profile?.tgUsername ?? '';
    final String about = profile?.aboutMe ?? '';
    final String birth = _formatDate(profile?.birthdayDate);

    return _ProfileBaseLayout(
      avatar: CircleAvatar(
        radius: 50,
        backgroundImage: avatarUrl.isNotEmpty
            ? NetworkImage(avatarUrl)
            : AssetImage(ThemeAssets.noAvatarUser(context)) as ImageProvider,
      ),
      nameRow: _NameRow(name: name, surname: surname),
      tgRow: _SingleTextField(value: tgName),
      aboutRow: _DoubleRow(left: about, right: birth),
      bottomRow: const SizedBox(),
    );
  }
}

class _ProfileBaseLayout extends StatelessWidget {
  final Widget avatar;
  final Widget nameRow;
  final Widget tgRow;
  final Widget aboutRow;
  final Widget bottomRow;

  const _ProfileBaseLayout({
    super.key,
    required this.avatar,
    required this.nameRow,
    required this.tgRow,
    required this.aboutRow,
    required this.bottomRow,
  });

  Widget _divider() => const Divider(color: Colors.white, height: 1);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double sectionHeight = constraints.maxHeight / 5;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              SizedBox(height: sectionHeight, child: Center(child: avatar)),
              _divider(),
              SizedBox(height: sectionHeight, child: Center(child: nameRow)),
              _divider(),
              SizedBox(height: sectionHeight, child: Column(children: [Text(
                'Tg@username'
              ) ,tgRow])),
              _divider(),
              SizedBox(height: sectionHeight, child: Center(child: aboutRow)),
              _divider(),
              SizedBox(
                height: 100,
                child: Align(alignment: Alignment.bottomCenter, child: bottomRow),
              ),
            ],
          ),
        );
      },
    );
  }
}

// хелперы
class _NameRow extends StatelessWidget {
  final String name;
  final String surname;
  const _NameRow({required this.name, required this.surname, super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(name, style: const TextStyle(color: Colors.white))),
        const SizedBox(width: 16),
        Expanded(child: Text(surname, style: const TextStyle(color: Colors.white))),
      ],
    );
  }
}

class _SingleTextField extends StatelessWidget {
  final String value;
  const _SingleTextField({required this.value, super.key});
  @override
  Widget build(BuildContext context) {
    return Text(value, style: const TextStyle(color: Colors.white));
  }
}

class _DoubleRow extends StatelessWidget {
  final String left;
  final String right;
  const _DoubleRow({required this.left, required this.right, super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(left, style: const TextStyle(color: Colors.white))),
        const SizedBox(width: 16),
        Expanded(child: Text(right, style: const TextStyle(color: Colors.white))),
      ],
    );
  }
}