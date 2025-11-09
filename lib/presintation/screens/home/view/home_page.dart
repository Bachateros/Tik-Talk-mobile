import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/presintation/widgets/failed_load_view.dart';
import 'package:tik_talk/presintation/screens/splash/splash_screen.dart';
import 'package:tik_talk/presintation/theme/theme_background.dart';
import 'package:tik_talk/presintation/widgets/custom_app_bar.dart';
import 'package:tik_talk/presintation/widgets/side_menu.dart';

class HomePage extends StatelessWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
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
            return const SplashScreen();

          case HomeStatus.success:
            return Scaffold(
              drawer: const SideMenu(),
              appBar: GoRouter.of(context).state.path! == '/home' ? const CustomAppBar() : null,
              body: child, 
            );

          case HomeStatus.failure:
            return FailedLoadView(errorMessage: state.errorMessage,);
        }
      },
    );
  }
}
