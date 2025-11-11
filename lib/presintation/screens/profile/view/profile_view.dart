import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required String userId, required bool isCurrentUser});

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder(
      builder:(context, state){
        return Center(
          child: Text(
            'Профиль'
          ),
        );
      },
      );
  }
}