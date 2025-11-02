import 'package:flutter/material.dart';
import 'package:tik_talk/internal/di.dart';
import 'package:tik_talk/internal/global_bloc_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DIContainer.init();

  runApp(const GlobalBlocProvider());
}

