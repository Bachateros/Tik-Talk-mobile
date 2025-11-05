import 'package:go_router/go_router.dart';
import 'package:tik_talk/presintation/screens/chat/view/chat_page.dart';
import 'package:tik_talk/presintation/screens/chat/view/chat_settings_page.dart';
import 'package:tik_talk/presintation/screens/home/view/chat_list_page.dart';
import 'package:tik_talk/presintation/screens/home/view/home_page.dart';
import 'package:tik_talk/presintation/screens/login/view/login_page.dart';
import 'package:tik_talk/presintation/screens/profile/view/profile_page.dart';
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
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => HomePage(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const ChatListPage(),
        ),
        GoRoute(
          path: '/home/chat/:chatId',
          builder: (context, state) {
            final chatId = state.pathParameters['chatId']!;
            return ChatPage(chatId: chatId);
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
          builder: (context, state) => const ProfilePage(isCurrentUser: true, userId: '',),
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
            return ProfilePage(isCurrentUser: false, userId: userId);
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
