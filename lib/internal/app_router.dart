import 'package:go_router/go_router.dart';
import 'package:tik_talk/presintation/screens/home_page.dart';
import 'package:tik_talk/presintation/screens/login/view/login_page.dart';
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
        builder: (context, state) => const LoginPage()
        ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage()
      ),

    ],
  );

  // getters
  GoRouter get router => _router;

  //=============================================================================
}
