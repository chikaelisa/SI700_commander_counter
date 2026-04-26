import 'package:flutter/material.dart';

import 'navigation/main_navigation_page.dart';

class CommanderCounterApp extends StatelessWidget {
  const CommanderCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Commander Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6F5A7E),
      ),
      home: const MainNavigationPage(),
    );
  }
}
