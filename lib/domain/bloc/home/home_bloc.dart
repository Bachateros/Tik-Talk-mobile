import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/home_entitie.dart';
import 'package:tik_talk/domain/repositories/home_repository.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc( this.repository) : super(HomeState.initial()){
    on<LoadEvent>(_onLoadDate);
    on<UpdateEvent>(_onUpdateDate);
  }

  Future<void> _onLoadDate(LoadEvent event, Emitter emit) async {
    try {
      final chats = await repository.getChats();
      final lastmesseges = await repository.getLastMessages(chats);
      emit(state.copyWith(status: HomeStatus.success, homeModel: state.homeModel.copyWith(chats: chats , lastMesseges: lastmesseges.whereType<ChatWithLastMessegeEntitie>().toList())));
    } catch (e) {
      print('Ошибка регистрации: $e');
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _onUpdateDate(UpdateEvent event, Emitter emit) async {
    try {
      final chats = await repository.getChats();
      final lastmesseges = await repository.getLastMessages(chats);
      emit(state.copyWith(status: HomeStatus.success, homeModel: state.homeModel.copyWith(chats: chats , lastMesseges: lastmesseges.whereType<ChatWithLastMessegeEntitie>().toList())));
    } catch (e) {
      print('Ошибка регистрации: $e');
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}

