import 'package:commander_counter/features/counters/counters_page.dart';
import 'package:commander_counter/features/game/game_page.dart';
import 'package:commander_counter/features/history/bloc/match_history_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/history/data/local_match_history_data_provider.dart';
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

  void login() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
    });
  }

  void goToLife() {
    setState(() {
      selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      isLoggedIn
          ? GamePage(onGoToLife: goToLife)
          : AuthRequiredPage(title: 'Game', onLoginPressed: goToProfile),

      isLoggedIn
          ? CountersPage(onGoToLife: goToLife)
          : AuthRequiredPage(title: 'Counters', onLoginPressed: goToProfile),

      LifePage(isLoggedIn: isLoggedIn),

      ProfilePage(isLoggedIn: isLoggedIn, onLogin: login, onLogout: logout),
    ];

    return BlocProvider(
      create: (context) =>
          MatchHistoryBloc(dataProvider: LocalMatchHistoryDataProvider()),
      child: Scaffold(
        body: IndexedStack(index: selectedIndex, children: pages),
        bottomNavigationBar: AppBottomNavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onItemTapped,
        ),
      ),
    );
  }
}
