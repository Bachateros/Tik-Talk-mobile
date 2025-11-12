import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';

part 'search_list_builder.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;
  late List<SearchItem> _searchItems;

  @override
  void initState() {
    super.initState();
    _updateSearchItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Обновляем данные при изменении состояния HomeBloc
    final homeBloc = context.read<HomeBloc>();
    homeBloc.stream.listen((state) {
      if (mounted) {
        setState(() {
          _updateSearchItems();
        });
      }
    });
  }

  void _updateSearchItems() {
    final homeState = context.read<HomeBloc>().state;
    final users = homeState.users.whereType<UserEntity>().toList();
    final List<ChatEntitie?>chats = [];
    final listLastMes= homeState.listLastMesseges;
    for(final chat in listLastMes){
      chats.add(chat?.chat);
    }

    _searchItems = [];

    // Добавляем пользователей
    for (final user in users) {
      if (user.name != '' || user.surname != '') {
        final displayName = '${user.name} ${user.surname}'.trim();
        if (displayName.isNotEmpty) {
          _searchItems.add(SearchItem(
            id: user.userId,
            displayName: displayName,
            type: SearchItemType.user,
            subtitle: 'Пользователь',
          ));
        }
      }
    }

    // Добавляем чаты
    for (final chat in chats) {
      String displayName = chat!.nameChat;
      
      // Если имя чата пустое, генерируем его
      if (displayName.isEmpty) {
        switch (chat.typeChat) {
          case ChatType.direct:displayName= (){
            final contactId = listLastMes.firstWhere((ch)=> ch?.chat.idChat == chat.idChat )?.contactId;
            if(contactId == null){return 'dir';}
            final user = users.firstWhere((u) => (u.userId == contactId));
            return '${user.surname} ${user.name}';
          }();
          case ChatType.group:
            displayName = 'Групповой чат';
            break;
          case ChatType.channel:
            displayName = 'Канал';
            break;
        }
      }

      if (displayName.isNotEmpty) {
        _searchItems.add(SearchItem(
          id: chat.idChat,
          displayName: displayName,
          type: _getSearchItemType(chat.typeChat),
          subtitle: _getChatTypeName(chat.typeChat),
        ));
      }
    }
  }

  SearchItemType _getSearchItemType(ChatType chatType) {
    switch (chatType) {
      case ChatType.direct:
        return SearchItemType.directChat;
      case ChatType.group:
        return SearchItemType.groupChat;
      case ChatType.channel:
        return SearchItemType.channel;
    }
  }

  String _getChatTypeName(ChatType chatType) {
    switch (chatType) {
      case ChatType.direct:
        return 'Диалог';
      case ChatType.group:
        return 'Группа';
      case ChatType.channel:
        return 'Канал';
    }
  }



  void _handleSelection(SearchItem item, BuildContext context) {
    switch (item.type) {
      case SearchItemType.user:
        context.push('/home/profile/${item.id}');
        break;
      case SearchItemType.directChat:
      case SearchItemType.groupChat:
      case SearchItemType.channel:
        context.push('/home/chat/${item.id}');
        break;
    }
  }

  Widget _getItemIcon(SearchItemType type) {
    switch (type) {
      case SearchItemType.user:
        return const Icon(Icons.person, size: 20);
      case SearchItemType.directChat:
        return const Icon(Icons.chat, size: 20);
      case SearchItemType.groupChat:
        return const Icon(Icons.group, size: 20);
      case SearchItemType.channel:
        return const Icon(Icons.campaign, size: 20);
    }
  }

  Widget _getItemTrailingIcon(SearchItemType type) {
    switch (type) {
      case SearchItemType.user:
        return const Icon(Icons.person_outline, size: 16);
      case SearchItemType.directChat:
      case SearchItemType.groupChat:
      case SearchItemType.channel:
        return const Icon(Icons.chat_bubble_outline, size: 16);
    }
  }

  Widget _buildSearchField(BuildContext context) {
    return Autocomplete<SearchItem>(
      optionsBuilder: (TextEditingValue value) {
        if (value.text.isEmpty) return const Iterable<SearchItem>.empty();
        
        return _searchItems.where((item) =>
            item.displayName.toLowerCase().contains(value.text.toLowerCase()) ||
            (item.subtitle?.toLowerCase().contains(value.text.toLowerCase()) ?? false));
      },
      
      onSelected: (SearchItem selection) {
        _handleSelection(selection, context);
        setState(() => _isSearching = false);
        _controller.clear();
      },
      
      displayStringForOption: (SearchItem item) => item.displayName,
      
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Поиск пользователей и чатов...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
        );
      },
      
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final item = options.elementAt(index);
                  return ListTile(
                    leading: _getItemIcon(item.type),
                    title: Text(
                      item.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      item.subtitle ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: _getItemTrailingIcon(item.type),
                    onTap: () => onSelected(item),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

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
          builder: (context) => IconButton(
            icon: Image.asset(ThemeAssets.logo(context)),
            // onPressed: () => context.push('/api-tester'),
            onPressed: () => Scaffold.of(context).openDrawer(), //TODO:
          ),
        ),
        backgroundColor: Colors.transparent,
        title: !_isSearching
            ? const Text(
                'Tik-Talk',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            : _buildSearchField(context),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _controller.clear();
                } else {
                  _updateSearchItems();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}