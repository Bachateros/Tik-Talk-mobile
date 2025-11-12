import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/data/datasources/local/auth_local_data_source.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/domain/entities/last_message_chat_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/home_repository.dart';
import 'package:tik_talk/internal/di.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;
  late final StreamSubscription _sub;
  final AuthBloc authBloc;

  HomeBloc({required this.repository, required this.authBloc}) : super(HomeState.initial()){
    _sub = authBloc.stream.listen((event) {
      if (event.status == AuthStatus.autheficated) {
        // load data
        Future.delayed(Duration(milliseconds: 100),
         () {
          add(LoadEvent());
        }
        );

      }
    });
    
    on<LoadEvent>(_onLoadDate);
    on<UpdateEvent>(_onUpdateDate);
  }

  @override
  Future<void> close() {
    _sub.cancel();  // отписываемся при закрытии
    return super.close();
  }

  Future<void> _onLoadDate(LoadEvent event, Emitter emit) async {
    try {
      final authLocal = DIContainer().container.get<AuthLocalDataSource>();
      final userId = await authLocal.getUserId();

      if (userId == null) throw Exception("User not logged in");


      final user = await repository.getMy(userId);
      final users = await repository.getAllUsers();
      final contacts = await repository.getContacts(userId);
      final listLastMesseges= await repository.getLastMessages(userId);

      emit(state.copyWith(status: HomeStatus.success,userId: userId,user: user, listLastMesseges : listLastMesseges,listContacts: contacts, users: users ), );
      } catch (e) {
      print('Ошибка загрузки данных: $e');
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _onUpdateDate(UpdateEvent event, Emitter emit) async {
    try {
      final listLastMesseges= await repository.getLastMessages(state.user!.userId);

      emit(state.copyWith(status: HomeStatus.success, listLastMesseges : listLastMesseges), );

    } catch (e) {
      print('Ошибка обновления данных: $e');
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  //TODO: добависть обновление после обновления личной информации      final user = await repository.getMy(userId);
  //при вызове от веб сокета обновляем  final contacts = await repository.getContacts(userId);
  //final listLastMesseges= await repository.getLastMessages(userId);
}

