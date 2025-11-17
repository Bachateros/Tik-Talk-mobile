import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/create_chat_bloc/create_chat_bloc.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';

class AppBarCreate extends StatefulWidget implements PreferredSizeWidget {
  const AppBarCreate({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarCreate> createState() => _AppBarCreateState();
}

class _AppBarCreateState extends State<AppBarCreate> {

  @override
  Widget build(BuildContext context) {
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
          builder: (context) {
            if (context.read<CreateChatBloc>().state.status != CreateChatStatus.createDirect){
              return IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => context.read<CreateChatBloc>().add(SwitchCreateChatEvent(status: CreateChatStatus.createDirect))
              );
            } else {
              return IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => context.pop(), 
              );
            }
          },
        ),
        centerTitle: true,
        title: Text('Create chat'),
        backgroundColor: Colors.transparent,
      )
    );
  }
}