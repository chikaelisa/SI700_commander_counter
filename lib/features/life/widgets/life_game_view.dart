import 'package:flutter/material.dart';

import '../models/player_life.dart';
import 'player_life_card.dart';

class LifeGameView extends StatelessWidget {
  final List<PlayerLife> players;
  final bool isLoggedIn;
  final VoidCallback onResetGame;
  final void Function(int index) onIncrementLife;
  final void Function(int index) onDecrementLife;
  final void Function(int index) onEditName;
  final void Function(int index) onEditCommander;

  const LifeGameView({
    super.key,
    required this.players,
    required this.isLoggedIn,
    required this.onResetGame,
    required this.onIncrementLife,
    required this.onDecrementLife,
    required this.onEditName,
    required this.onEditCommander,
  });

  int getCrossAxisCount(int playerCount) {
    if (playerCount <= 2) {
      return 1;
    }

    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(
              children: [
                Text(
                  'Partida',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onResetGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reconfigurar'),
                ),
              ],
            ),
          ),
          Expanded(
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
                    onIncrement: () => onIncrementLife(index),
                    onDecrement: () => onDecrementLife(index),
                    onEditName: () => onEditName(index),
                    canEditCommander: isLoggedIn,
                    onEditCommander: () => onEditCommander(index),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
