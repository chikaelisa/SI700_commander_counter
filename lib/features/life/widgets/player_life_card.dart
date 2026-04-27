import 'package:flutter/material.dart';

import '../models/player_life.dart';
import 'mana_color_row.dart';

class PlayerLifeCard extends StatelessWidget {
  final PlayerLife player;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onEditName;
  final bool canEditCommander;
  final VoidCallback onEditCommander;
  final VoidCallback onOpenSettings;

  const PlayerLifeCard({
    super.key,
    required this.player,
    required this.onIncrement,
    required this.onDecrement,
    required this.onEditName,
    required this.canEditCommander,
    required this.onEditCommander,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: player.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onEditName,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                ),
                IconButton(
                  onPressed: onOpenSettings,
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: 'Configurar jogador',
                ),
              ],
            ),
            if (canEditCommander) ...[
              const SizedBox(height: 2),
              InkWell(
                onTap: onEditCommander,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          player.commanderName.isEmpty
                              ? 'Comandante'
                              : player.commanderName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.edit, size: 14),
                    ],
                  ),
                ),
              ),
            ],
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _LifeTapArea(
                      onTap: onDecrement,
                      icon: Icons.remove,
                      semanticLabel: 'Diminuir vida',
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${player.life}',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 72,
                              ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _LifeTapArea(
                      onTap: onIncrement,
                      icon: Icons.add,
                      semanticLabel: 'Aumentar vida',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: ManaColorRow(
                manaColors: player.manaColors,
                onAddPressed: onOpenSettings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LifeTapArea extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String semanticLabel;

  const _LifeTapArea({
    required this.onTap,
    required this.icon,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox.expand(
          child: Center(
            child: Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
