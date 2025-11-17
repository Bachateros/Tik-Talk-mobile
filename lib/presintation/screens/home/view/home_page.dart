import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/presintation/screens/splash/splash_home_screan.dart';
import 'package:tik_talk/presintation/widgets/failed_load_view.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';
import 'package:tik_talk/presintation/widgets/custom_app_bar.dart';
import 'package:tik_talk/presintation/widgets/side_menu.dart';

class HomePage extends StatelessWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).routerDelegate.currentConfiguration.last.matchedLocation;
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (BuildContext context, HomeState state) {
        switch (state.status) {
          case HomeStatus.unknown:
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ThemeAssets.background(context)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            );

          case HomeStatus.loading:
            return const SplashHomeScreen();

          case HomeStatus.success:{
            if (location.startsWith('/home/chat')) {
              return child;
            }
            if (location.startsWith('/home/profile')) {
              return child;
            }
            if (location.startsWith('/home/create_chat')) {
              return child;
            }
            return Scaffold(
              drawer: const SideMenu(),
              appBar: location == '/home' ? const CustomAppBar() 
                    // : location.startsWith('/home/profile') ? AppBarProfile()  
                    // : location.startsWith('/home/chat') ? AppBarChat()
                    : null,
              body: child, 
            );
          }
          case HomeStatus.failure:
            return FailedLoadView(errorMessage: state.errorMessage,);
        }
      },
    );
  }
}
