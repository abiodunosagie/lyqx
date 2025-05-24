import 'package:flutter/material.dart';
import 'package:lyqx/theme/app_theme.dart';
import 'package:lyqx/views/home/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      debugShowCheckedModeBanner: false,

      // Apply our custom themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Automatically switches based on system settings

      // Start with welcome screen
      home: const HomeScreen(),
    );
  }
}