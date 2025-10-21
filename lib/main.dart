import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/AuthProvider.dart';
import 'service/auth.dart';

void main() => runApp(ChangeNotifierProvider(
  create: () => AuthProvider(),
  childe: const MyApp(),
));

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
  }
}
