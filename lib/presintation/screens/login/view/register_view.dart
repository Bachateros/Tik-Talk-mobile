import 'package:flutter/material.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/presintation/screens/login/widgets/register_complete_url_aligin.dart';
import 'package:tik_talk/presintation/screens/login/widgets/register_form.dart';
import 'package:tik_talk/presintation/widgets/background_picture.dart';

class RegisterView extends StatelessWidget {
  final UserEntity? user;
  const RegisterView({super.key, this.user});


  @override
  Widget build(BuildContext context) {

    if (user?.accesBotLink ==null){
      return BackgroundPicture(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child:SingleChildScrollView(
              child: RegisterForm(),//<= вот сюда передать 
            ),
        ),
        )
      );
    } else {
        return BackgroundPicture(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: RegisterCompleteForm(botLink: user!.accesBotLink!),
          )
        );
    }
  }
}