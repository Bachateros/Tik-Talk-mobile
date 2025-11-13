import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';

class AppBarChat extends StatefulWidget implements PreferredSizeWidget {
  const AppBarChat({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarChat> createState() => _AppBarChatState();
}

class _AppBarChatState extends State<AppBarChat> {

  @override
  Widget build(BuildContext context) {  
    final chat = context.read<ChatBloc>().state.chatModel;
    final status = context.read<ChatBloc>().state.status;
    String chatName = '';
    final String? avatar;
    if (chat?.typeChat != ChatType.direct){
       chatName = chat?.nameChat ?? '';
       avatar = chat?.avatarUrl ?? ThemeAssets.noAvatarChat(context);
    } else{
       final contactId = context.read<HomeBloc>().state
            .listLastMesseges.firstWhere((c)=>(c?.chat.idChat == chat?.idChat))
            ?.contactId;
       final user =  context.read<HomeBloc>().state
            .users.firstWhere((u)=>u?.userId==contactId);
      if(user == null){
         chatName = '';
         avatar = null;
      }else{
         chatName = "${user.surname} ${user.name}";
         avatar = user.avatarUrl;
      }
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ThemeAssets.searchBar(context)),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topLeft,
        ),
      ),
      child: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back_ios),
              
              onPressed: () {
                if (status == ChatStatus.setting){
                  return context.read<ChatBloc>().add(StatusChangeEvent(status: ChatStatus.update));
                }else{
                  return context.pop();
                }
                },
          ),
        ),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: avatar != null
                    ? NetworkImage(avatar)
                    : AssetImage(ThemeAssets.noAvatarChat(context)) as ImageProvider,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  chatName == '' ? 'Беседа' : chatName,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ]
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          BlocBuilder<ChatBloc,ChatState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder:(context, state) => state.status == ChatStatus.update ? IconButton( 
                icon: const Icon(Icons.more_vert),
                color: Colors.white,
                onPressed: () => context.read<ChatBloc>().add(StatusChangeEvent(status: ChatStatus.setting),
                ),
              ): const SizedBox.shrink(),
            ),
        ],

      ),
    );
  }
}