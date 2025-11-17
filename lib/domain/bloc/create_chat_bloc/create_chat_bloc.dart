import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/create_chat_repository.dart';
import 'package:tik_talk/domain/repositories/sync_repository.dart';

part 'create_chat_event.dart';
  part 'create_chat_state.dart';
  
class CreateChatBloc extends Bloc<CreateChatEvent,CreateChatState>{
  CreateChatRepository repository;
  HomeBloc homeBloc;
  SyncRepository syncRepo;

  CreateChatBloc({required this.repository,required this.homeBloc, required this.syncRepo }) : 
      super(CreateChatState.initial(
        homeBloc.state.users,
        (){
        final listContactcts =homeBloc.state.contacts;
        return listContactcts;
        }(),
        (){
        final lastMessage = homeBloc.state.listLastMesseges;
        final List<ChatEntitie?> listChats = [];
          for (final chat in lastMessage) {
            listChats.add(chat?.chat);
          }
        return listChats;
        }(),
        homeBloc.state.user!.userId)
        )
      {
    on<SwitchCreateChatEvent>(_onSwitchCreateChat);
    on<CreateNewChatEvent>(_onCreateNewChat);
  }

  Future<void> _onSwitchCreateChat(SwitchCreateChatEvent event, Emitter emit)async{
    try {
      emit(state.copyWith(status: event.status));
    } catch (e) {
      emit(state.copyWith(status: CreateChatStatus.createDirect,errorMessage: 'Ошибка переключения чата: $e'));
    }
  }

  Future<void> _onCreateNewChat(CreateNewChatEvent event, Emitter emit) async {
    try {
      final newIdChat = await repository.createChat(event.chat,event.listParticipant );
      if (newIdChat!='' || newIdChat != null){
        // await syncRepo.syncChat(newIdChat!);   
        emit(state.copyWith(status: CreateChatStatus.succes,));
      }else {
        print('Ошибка при условии что полный объект вернулся');
        emit(state.copyWith(status:CreateChatStatus.failure, errorMessage: 'Ошибка при условии что полный объект вернулся'));
      }
    } catch (e) {
      print('Ошибка при создании чата: $e');
      emit(state.copyWith(
          status: CreateChatStatus.createDirect,
          errorMessage: 'Ошибка при создании чата: $e'));
    }
  }


}

