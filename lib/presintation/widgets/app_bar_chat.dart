import 'package:flutter/material.dart';
import 'package:tik_talk/presintation/theme/theme_background.dart';

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
    // final chat = context.read<ChatBloc>().state.chatModel;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ThemeAssets.searchBar(context)),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topLeft,
        ),
      ),
      child: Text('имя чата'),
    );
  }
}