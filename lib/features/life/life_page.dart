import 'package:flutter/material.dart';

import 'models/player_life.dart';
import 'widgets/life_setup_panel.dart';

class LifePage extends StatefulWidget {
  const LifePage({super.key});

  @override
  State<LifePage> createState() => _LifePageState();
}

class _LifePageState extends State<LifePage> {
  int playerCount = 4;
  int startingLife = 40;
  List<PlayerLife> players = [];

  void updatePlayerCount(int value) {
    setState(() {
      playerCount = value;
    });
  }

  void updateStartingLife(int value) {
    setState(() {
      startingLife = value;
    });
  }

  void createGame() {
    setState(() {
      players = List.generate(
        playerCount,
        (index) => PlayerLife(
          name: 'Jogador ${index + 1}',
          life: startingLife,
          commanderName: '',
          backgroundColor: Colors.grey.shade200,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return LifeSetupPanel(
        playerCount: playerCount,
        startingLife: startingLife,
        onPlayerCountChanged: updatePlayerCount,
        onStartingLifeChanged: updateStartingLife,
        onCreateGame: createGame,
      );
    }

    return SafeArea(
      child: Center(
        child: Text(
          'Partida criada com ${players.length} jogadores',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
