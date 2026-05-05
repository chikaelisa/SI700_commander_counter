import 'package:flutter/material.dart';

import '../mock/mock_match_history.dart';
import '../models/match_history.dart';

class MatchHistoryPage extends StatelessWidget {
  const MatchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final matches = mockMatchHistory;

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de partidas')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: matches.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final match = matches[index];

          return MatchHistoryCard(match: match);
        },
      ),
    );
  }
}

class MatchHistoryCard extends StatelessWidget {
  final MatchHistory match;

  const MatchHistoryCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final dateText =
        '${match.playedAt.day.toString().padLeft(2, '0')}/'
        '${match.playedAt.month.toString().padLeft(2, '0')}/'
        '${match.playedAt.year}';

    return Card(
      child: ExpansionTile(
        title: Text(match.winnerLabel),
        subtitle: Text('$dateText • ${match.playerCount} jogadores'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              match.comment,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 12),
          ...match.players.map(
            (player) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(player.playerName),
              subtitle: Text(player.commanderName),
              trailing: Text(
                '${player.finalLife}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
