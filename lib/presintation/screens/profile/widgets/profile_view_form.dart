import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/domain/bloc/profile/profile_bloc.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';
import 'package:tik_talk/presintation/theme/theme_colors.dart';

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
        radius: 80,
        backgroundImage: avatarUrl != '' || avatarUrl != ""
            ? NetworkImage(avatarUrl)
            : NetworkImage(ThemeAssets.noAvatarUser(context)),
      ),
      nameRow: _NameRow(name: name, surname: surname),
      tgRow: _DoubleRow(left: tgName ,fieldLeft:  'Telegram username:', right: birth, fieldRight: 'Date of birthday:',),
      aboutRow: _SingleTextField(value:  about != '' ? about : 'Здесь пока пусто', field: 'About me:',),
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
        final double sectionHeight = constraints.maxHeight ;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            children: [
              SizedBox(height: (sectionHeight * 0.35) , child: Center(child: avatar)),
              _divider(),
              SizedBox(height: (sectionHeight * 0.12), child: nameRow),
              _divider(),
              SizedBox(height: (sectionHeight * 0.12), child: Center(child: tgRow,)),
              _divider(),
              SizedBox(height: (sectionHeight * 0.19), child: Center(child: aboutRow)),
              _divider(),
              SizedBox(
                height: 70,
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
  const _NameRow({required this.name, required this.surname});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text('Name:',style: TextStyle(color: AppColors.menuGrey,),) ),
              SizedBox(width: 4,),
              Expanded(child: Text(name, style: const TextStyle(color: Colors.white, )),),
              SizedBox(width: 1,),
              const Divider(color: Colors.white24),
              ], 
            ),),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text('Surname:',style: TextStyle(color: AppColors.menuGrey,),) ),
              SizedBox(width: 4,),
              Expanded(child: Text(surname, style: const TextStyle(color: Colors.white, )),),
              const Divider(color: Colors.white24),
              ], 
            ),
          ),
      ],
      ),
    );
  }
}

class _SingleTextField extends StatelessWidget {
  final String field;
  final String value;

  const _SingleTextField({
    required this.field,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field,
            style: TextStyle(
              color: AppColors.menuGrey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color.fromARGB(0, 255, 255, 255)),
        ],
      ),
    );
  }
}


class _DoubleRow extends StatelessWidget {
  final String left;
  final String fieldLeft;
  final String right;
  final String fieldRight;
  const _DoubleRow({required this.left, required this.right,required this.fieldLeft ,required this.fieldRight });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Expanded(child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(fieldLeft,style: TextStyle(color: AppColors.menuGrey,),) ),
              const SizedBox(height: 8),
              Expanded(child: Text(left, style: const TextStyle(color: Colors.white, )),),
              const Divider(color: Colors.white24, thickness: 1),
              ], 
            ),),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(fieldRight,style: TextStyle(color: AppColors.menuGrey,),) ),
              const SizedBox(height: 8),
              Expanded(child: Text(right, style: const TextStyle(color: Colors.white, )),),
              const Divider(color: Colors.white24, thickness: 1),
              ], 
            ),
          ),
      ],
      ),
    );
  }
}