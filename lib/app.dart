import 'package:commander_counter/features/cards/bloc/card_search_bloc.dart';
import 'package:commander_counter/features/cards/data/scryfall_card_search_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/data/auth_data_provider.dart';
import 'features/auth/data/firebase_auth_data_provider.dart';
import 'features/history/bloc/match_history_bloc.dart';
import 'features/history/data/firestore_match_history_data_provider.dart';
import 'features/history/data/match_history_data_provider.dart';
import 'navigation/main_navigation_page.dart';

class CommanderCounterApp extends StatelessWidget {
  final AuthDataProvider? authDataProvider;
  final MatchHistoryDataProvider? matchHistoryDataProvider;

  const CommanderCounterApp({
    super.key,
    this.authDataProvider,
    this.matchHistoryDataProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            dataProvider: authDataProvider ?? FirebaseAuthDataProvider(),
          ),
        ),
        BlocProvider(
          create: (context) => MatchHistoryBloc(
            dataProvider:
                matchHistoryDataProvider ?? FirestoreMatchHistoryDataProvider(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              CardSearchBloc(dataProvider: ScryfallCardSearchDataProvider()),
        ),
      ],
      child: MaterialApp(
        title: 'Commander Counter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6F5A7E)),
          useMaterial3: true,
        ),
        home: const MainNavigationPage(),
      ),
    );
  }
}
