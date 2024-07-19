import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:try_app/pages/navigationbar.dart';
import 'package:try_app/themes/light_mode.dart';
import 'package:try_app/themes/theme_provider.dart';
import 'pages/First.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: BottomNavigationBarExample(),
    );
  }
}
