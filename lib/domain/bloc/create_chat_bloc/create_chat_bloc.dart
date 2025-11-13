  part 'create_chat_event.dart';
  part 'create_chat_state.dart';
  
  // on<CreateChatEvent>(_onCreateChat);
  // on<CreateDirectEvent>(_onCreateDirect);

  // // Создание нового чата
  // Future<void> _onCreateChat(
  //     CreateChatEvent event, Emitter<ChatState> emit) async {
  //   emit(state.copyWith(status: ChatStatus.unknown));
  //   try {
  //     final newChat = await repository.createChat(event.chat,event.participantList);
  //     emit(state.copyWith(
  //       status: ChatStatus.update,
  //       chatModel: newChat,
  //       chatId: newChat.idChat,
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(
  //         status: ChatStatus.failure,
  //         errorMessage: 'Ошибка при создании чата: $e'));
  //   }
  // }

  // // Создание личного (direct) чата
  // Future<void> _onCreateDirect(
  //     CreateDirectEvent event, Emitter<ChatState> emit) async {
  //   emit(state.copyWith(status: ChatStatus.unknown));
  //   try {
  //     final directChat = await repository.createChat(event.chat,state.listParticipant);
  //     emit(state.copyWith(
  //       status: ChatStatus.update,
  //       chatModel: directChat,
  //       chatId: directChat.idChat,
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(
  //         status: ChatStatus.failure,
  //         errorMessage: 'Ошибка при создании личного чата: $e'));
  //   }
  // }