import 'package:flutter/material.dart';

import '../mock/mock_match_history.dart';
import '../models/match_history.dart';
import '../services/match_history_storage_service.dart';

class MatchHistoryPage extends StatefulWidget {
  const MatchHistoryPage({super.key});

  @override
  State<MatchHistoryPage> createState() => _MatchHistoryPageState();
}

class _MatchHistoryPageState extends State<MatchHistoryPage> {
  final matchHistoryStorageService = MatchHistoryStorageService();

  late Future<List<MatchHistory>> matchesFuture;

  @override
  void initState() {
    super.initState();

    matchesFuture = loadMatches();
  }

  Future<List<MatchHistory>> loadMatches() async {
    final localMatches = await matchHistoryStorageService.getMatches();

    if (localMatches.isEmpty) {
      return mockMatchHistory;
    }

    return localMatches;
  }

  Future<void> refreshMatches() async {
    setState(() {
      matchesFuture = loadMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de partidas')),
      body: FutureBuilder<List<MatchHistory>>(
        future: matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Não foi possível carregar o histórico de partidas.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          final matches = snapshot.data ?? [];

          if (matches.isEmpty) {
            return const EmptyMatchHistoryView();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final match = matches[index];

              return MatchHistoryCard(match: match);
            },
          );
        },
      ),
    );
  }
}

class EmptyMatchHistoryView extends StatelessWidget {
  const EmptyMatchHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Nenhuma partida salva ainda.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
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
          if (match.comment.trim().isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                match.comment,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 12),
          ],
          ...match.players.map(
            (player) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(player.playerName),
              subtitle: Text(
                player.commanderName.trim().isEmpty
                    ? 'Sem comandante informado'
                    : player.commanderName,
              ),
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
