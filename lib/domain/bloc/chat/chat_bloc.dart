import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/message_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/repositories/chat_repository.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc(this.repository) : super(ChatState.initial()) {
    on<LoadChatEvent>(_onLoadChat);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<DeleteChatEvent>(_onDeleteChat);
    on<LeaveFromChat>(_onLeaveChat);
    on<UpdateMessegeEvent>(_onUpdateMessage);
    on<UpdateEvent>(_onUpdateChat);
    on<StatusChangeEvent>(_onStatusChangeEvent);
  }

  // Загрузка чата и его участников + сообщений
  Future<void> _onLoadChat(
      LoadChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      final chat = await repository.getChat(event.chatId);
      final participants =
          await repository.getChatParticipants(event.chatId);
      final messages = await repository.getMessage(event.chatId);

      emit(state.copyWith(
        status: ChatStatus.update,
        chatId: event.chatId,
        chatModel: chat,
        listParticipant: participants.whereType<ParticipantEntitie>().toList(),
        listMesseges: messages.whereType<MessageEntitie>().toList(),
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ChatStatus.failure,
          errorMessage: 'Ошибка при загрузке данных чата: $e'));
    }
  }

  // Загрузка сообщений (без обновления данных чата)
  Future<void> _onLoadMessages(
      LoadMessagesEvent event, Emitter<ChatState> emit) async {
    if (state.chatId == null) return;
    try {
      final messages = await repository.getMessage(state.chatId!);
      emit(state.copyWith(
        status: ChatStatus.update,
        listMesseges: messages.whereType<MessageEntitie>().toList(),
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ChatStatus.failure,
          errorMessage: 'Ошибка загрузки сообщений: $e'));
    }
  }

  //  Отправка нового сообщения
  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      await repository.sendMessage(event.message);
      // После отправки обновляем список сообщений
      add(LoadMessagesEvent());
    } catch (e) {
      emit(state.copyWith(
          status: ChatStatus.failure,
          errorMessage: 'Ошибка при отправке сообщения: $e'));
    }
  }

  Future<void> _onStatusChangeEvent(StatusChangeEvent event, Emitter emit)async{
    emit(state.copyWith(status: event.status));
  }

  // Обновление данных чата (например, при изменении имени или аватара)
  Future<void> _onUpdateChat(UpdateEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    if (state.chatModel == null) return;
    try {
      final updatedChat = await repository.updateChat(state.chatModel!);
      emit(state.copyWith(
        status: ChatStatus.update,
        chatModel: updatedChat,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ChatStatus.failure,
          errorMessage: 'Ошибка при обновлении чата: $e'));
    }
  }

  // Удаление чата
  Future<void> _onDeleteChat(
      DeleteChatEvent event, Emitter<ChatState> emit) async {
    if (state.chatId == null) return;
    try {
      await repository.deleteChat(state.chatId!);
      emit(ChatState.initial().copyWith(status: ChatStatus.update));
    } catch (e) {
      emit(state.copyWith(
          status: ChatStatus.failure,
          errorMessage: 'Ошибка при удалении чата: $e'));
    }
  }

  // Выход из чата
  Future<void> _onLeaveChat(
      LeaveFromChat event, Emitter<ChatState> emit) async {
    if (state.chatId == null) return;
    try {
      await repository.leaveChat(state.chatId!);
      emit(ChatState.initial().copyWith(status: ChatStatus.update));
    } catch (e) {
      emit(state.copyWith(
          status: ChatStatus.failure,
          errorMessage: 'Ошибка при выходе из чата: $e'));
    }
  }



  // Изменение или удаление сообщения
  Future<void> _onUpdateMessage(
      UpdateMessegeEvent event, Emitter<ChatState> emit) async {
    try {
      final updatedList = state.listMesseges.map((msg) {
        if (msg?.idMessage == event.message.idMessage) return event.message;
        return msg;
      }).toList();

      emit(state.copyWith(
        status: ChatStatus.update,
        listMesseges: updatedList,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ChatStatus.failure,
          errorMessage: 'Ошибка при обновлении сообщения: $e'));
    }
  }
}

