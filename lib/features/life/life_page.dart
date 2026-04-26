import 'package:commander_counter/features/life/widgets/player_life_card.dart';
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

  void incrementLife(int index) {
    setState(() {
      final player = players[index];

      players[index] = player.copyWith(life: player.life + 1);
    });
  }

  void decrementLife(int index) {
    setState(() {
      final player = players[index];

      players[index] = player.copyWith(life: player.life - 1);
    });
  }

  int getCrossAxisCount(int playerCount) {
    if (playerCount <= 2) {
      return 1;
    }

    if (playerCount <= 4) {
      return 2;
    }

    return 2;
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: players.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getCrossAxisCount(players.length),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return PlayerLifeCard(
              player: players[index],
              onIncrement: () => incrementLife(index),
              onDecrement: () => decrementLife(index),
            );
          },
        ),
      ),
    );
  }
}
