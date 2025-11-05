import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/presintation/screens/home/view/chat_list_page.dart';
import 'package:tik_talk/presintation/screens/home/view/home_failed_load_view.dart';
import 'package:tik_talk/presintation/screens/splash/splash_screen.dart';
import 'package:tik_talk/presintation/theme/theme_background.dart';
import 'package:tik_talk/presintation/widgets/custom_app_bar.dart';
import 'package:tik_talk/presintation/widgets/side_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required Widget child});
                
              
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => previous.status != current.status, 
      builder: (BuildContext context, HomeState state) {
        switch (state.status) {
          case HomeStatus.unknown:
              return Scaffold(
                body:Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ThemeAssets.background(context)),
                      fit: BoxFit.cover,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: Center(
                    child:CircularProgressIndicator()
                    ),
                  ),
              );
          case HomeStatus.loading:
              return Scaffold(body: SplashScreen());
          case HomeStatus.success:
              return Scaffold(
                    drawer: const SideMenu(), 
                    appBar: CustomAppBar(), 
                    body: ChatListPage(), 
                    );
          case HomeStatus.failure:
              return Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ThemeAssets.background(context)),
                      fit: BoxFit.cover,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: Scaffold(
                    body: HomeFailedLoadView(errorMessage:  state.errorMessage)),
                ),
              );
          default:
          break;
        } return SplashScreen();
      },
      );
  }
}
