import 'package:flutter/material.dart';

import '../features/life/life_page.dart';
import '../features/profile/profile_page.dart';
import '../shared/widgets/auth_required_page.dart';
import 'widgets/app_bottom_navigation_bar.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int selectedIndex = 2;

  bool isLoggedIn = false;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void goToProfile() {
    setState(() {
      selectedIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      AuthRequiredPage(title: 'Game', onLoginPressed: goToProfile),
      AuthRequiredPage(title: 'Counters', onLoginPressed: goToProfile),
      const LifePage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTapped,
      ),
    );
  }
}
