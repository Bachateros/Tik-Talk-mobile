import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/profile/profile_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});


  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc,ProfileState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder:(context, state){
        return Center(
          child: Text(
            state.profile!.name,
          ),
        );
      },
      );
  }
}

// class ProfileView extends StatelessWidget {
//   const ProfileView({super.key, required String userId, required bool isCurrentUser});

//   @override
//   Widget build(BuildContext context) {
    
//     return BlocBuilder<ProfileBloc,ProfileState>(
//       buildWhen: (previous, current) => previous.status != current.status,
//       builder:(context, state){
//         return Center(
//           child: Text(
//             state.profile!.name,
//           ),
//         );
//       },
//       );
//   }
// }