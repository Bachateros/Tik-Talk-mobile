import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';
import 'package:tik_talk/presintation/theme/theme_colors.dart';


class ContactsListView extends StatefulWidget {
  const ContactsListView({super.key});

  @override
  State<ContactsListView> createState() => _ContactsListViewState();
}

class _ContactsListViewState extends State<ContactsListView> {
 @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeBloc>().add(UpdateEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final contacts = state.contacts;

        if (state.status == HomeStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (contacts.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Нет контактов',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            if (contact == null) return const SizedBox.shrink();

            return Card(
              color: Colors.transparent,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade300,
                  backgroundImage: NetworkImage(
                    contact.avatarUrl != '' ? contact.avatarUrl! : ThemeAssets.noAvatar(context),
                  ),
                ),
                title: Text(
                  '${contact.name} ${contact.surname}',
                  style: const TextStyle(
                    color: AppColors.menuGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => context.push('/home/profile/:${contact.userId}'),
              ),
            );
          },
        );
      },
    );
  }
}



// class ContactsListView extends StatelessWidget {
//   const ContactsListView({super.key});

//   final problemURL = 'https://yt3.googleusercontent.com/ytc/AIdro_nLjyqSZ4m79nFyl-XE7oAWDkBc9uOQBxGv3wC_2NnuRQ=s900-c-k-c0x00ffffff-no-rj';
  
//   @override
//   Widget build(BuildContext context) {

//     context.read<HomeBloc>().add(UpdateEvent());

//     return BlocBuilder<HomeBloc,HomeState>(
//       builder:(context,state){
//         final contacts = state.contacts;
//         if (contacts.isEmpty){
//           return const Center(child: Text('Нет контактов'));
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.all(8),
//           itemCount: contacts.length,
//           itemBuilder: (context, index) {
//             final contact = contacts[index];          
//             return Card(
//               color: Colors.green,
//               margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//               child: ListTile(
//                 //TODO: добавить поск аватарки и вставить ссылку на 
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.blueGrey.shade300,
//                   child: Image.network(
//                       width: 40,
//                     //TODO: иконка с первым символом пользователя
//                       contact?.profile?.avatarUrl ?? problemURL,
//                     ),
//                   ),
//                 title: Text(
//                   '${contact?.name ?? 'error name'} ${contact?.surname ?? 'error name'}',
//                   style: const TextStyle(color: AppColors.menuGrey, fontWeight: FontWeight.bold),
//                 ),
//                 onTap: () => context.push('/profile/${contact!.userId}'),
//                 ),
//               );
//           }
//         );
//       } 
//     );
//   }
// }