import 'package:go_router/go_router.dart';
import 'package:tik_talk/presintation/screens/chat/view/chat_page.dart';
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
      path: '/auth',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/profile/me',
      builder: (context, state) => const ProfilePage(isCurrentUser: true, userId: '',),
    ),
    GoRoute(
      path: '/profile/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return ProfilePage(userId: userId, isCurrentUser: false,);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingPage(),
    ),
    GoRoute(
      path: '/chat/:chatId',
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        return ChatPage(chatId: chatId);
      },
    ),
  ],
);

  // getters
  GoRouter get router => _router;

  //=============================================================================
}
