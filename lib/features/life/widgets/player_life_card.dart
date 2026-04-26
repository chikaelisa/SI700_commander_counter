import 'package:flutter/material.dart';

import '../models/player_life.dart';

class PlayerLifeCard extends StatelessWidget {
  final PlayerLife player;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onEditName;

  const PlayerLifeCard({
    super.key,
    required this.player,
    required this.onIncrement,
    required this.onDecrement,
    required this.onEditName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: player.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            InkWell(
              onTap: onEditName,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        player.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.edit, size: 16),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Text(
              '${player.life}',
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: onDecrement,
                    child: const Icon(Icons.remove),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: onIncrement,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
