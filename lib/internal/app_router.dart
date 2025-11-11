import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/data/datasources/remote/chats_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/message_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/participiant_service_remote_source.dart';
import 'package:tik_talk/data/repositories/chat_repository_IMPL.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
import 'package:tik_talk/internal/di.dart';
import 'package:tik_talk/presintation/screens/chat/view/chat_page.dart';
import 'package:tik_talk/presintation/screens/chat/view/chat_settings_page.dart';
import 'package:tik_talk/presintation/screens/home/view/chat_list_view.dart';
import 'package:tik_talk/presintation/screens/home/view/home_page.dart';
import 'package:tik_talk/presintation/screens/login/view/auth_page.dart';
import 'package:tik_talk/presintation/screens/login/widgets/login_form.dart';
import 'package:tik_talk/presintation/screens/profile/view/profile_view.dart';
import 'package:tik_talk/presintation/screens/setting/view/setting_page.dart';
import 'package:tik_talk/presintation/screens/splash/splash_screen.dart';

class AppRouter {
  //=============================================================================

  // making singleton
  static final AppRouter _instance = AppRouter._();

  AppRouter._();

  factory AppRouter() {
    return _instance;
  }

  //=============================================================================

  // variables
final GoRouter _router = GoRouter(
  redirect: (context, state) {
      //One
      if(state.fullPath == '/') {
        return '/home' ;
      }
      //Two
      if(state.fullPath == '/auth') {
        return "/auth/login";
      }

      // if(state.fullPath == '/home/profile'){
      //   return '/home/profile';
      // }
      return null;
    },
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/home',
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => AuthPage(child: child),
      routes: [
        GoRoute(
          path: '/auth',
          redirect: (context, state) => '/auth/login',
        ),
        GoRoute(
          path: '/auth/login', 
          builder:(context, state) => LoginForm(),
          ),
        GoRoute(
          path: '/auth/login/verify', 
          redirect: (context, state) => '/auth/login', 
          ),
        GoRoute(
          path: '/auth/register', 
          redirect: (context, state) => '/auth/login'),
        GoRoute(
          path: '/auth/register/bot_link', 
          redirect: (context, state) => '/auth/login'), 
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => HomePage(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            return ChatListView();
          }
        ),
        GoRoute(
          path: '/home/chat/:chatId',
          builder: (context, state) {
            final chatId = state.pathParameters['chatId']!;
            return BlocProvider(
              create:(context) => ChatBloc(
                ChatRepositoryImpl(
                  chatsService: DIContainer().container.get<ChatsServiceRemoteSource>(),
                  messageService: DIContainer().container.get<MessageServiceRemoteSource>(),
                  participantService: DIContainer().container.get<ParticipiantServiceRemoteSource>()
                ))..add(LoadChatEvent(chatId: chatId)),
              child: ChatPage(), 
            );
          },
        ),
        GoRoute(
          path: '/home/chat/:chatId/setting_chat',
          builder: (context, state) {
            final chatId = state.pathParameters['chatId']!;
            return ChatSettingsPage(chatId: chatId);
          },
        ),
        GoRoute(
          path: '/home/profile',
          builder: (context, state) {
            return  ProfileView(isCurrentUser: true, userId:  context.read<AuthBloc>().state.user.userId);
          }
        ),
        GoRoute(
          path: '/home/profile/:userId',
          // builder: (context, state) {
          // final userId = state.pathParameters['userId']!;
          // return BlocProvider(
          //   create: (_) => ProfileBloc()..add(LoadProfile(userId)),
          //   child: ProfilePage(userId: userId, isCurrentUser: false),
          // );
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return ProfileView(isCurrentUser: false, userId: userId);
          },
        ),
        GoRoute(
          path: '/home/settings',
          builder: (context, state) => const SettingPage(),
        ),
      ],
    ),
  ],
);


  // getters
  GoRouter get router => _router;

  //=============================================================================
}
