import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/repositories/chat_repository.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent,ChatState>{
  final ChatRepository repository;

  ChatBloc(this.repository) : super(ChatState.initial());
}

//пока мысль следующая у страницы /home/chat будет три chat_view.dart 
//сам чат в котором отображаются сообщения
//
//настройка чата вложенный элемент с формой page (я не знаю лучше такие вещи добавлять через goRouter или вызывать с помощью event) 
//в настройках можно посмотреть: участников(у админа чата есть возможность раздовать роли и удалять участников), 
//имя чата (админ может изменять имя чата), картинку: ее могут менять все 
//
//
//Модель создания чата как отдельная страница в дереве go rotuter должна быть как /home/page_create но задействовать она должна события из этого блока