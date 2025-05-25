import 'package:flutter/material.dart';
import 'package:lyqx/presentation/views/welcome_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LYQX Shopping App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
    );
  }
}
