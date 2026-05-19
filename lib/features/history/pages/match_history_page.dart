import 'package:flutter/material.dart';

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
    return matchHistoryStorageService.getMatches();
  }

  Future<void> refreshMatches() async {
    setState(() {
      matchesFuture = loadMatches();
    });
  }

  Future<void> deleteMatch(String matchId) async {
    await matchHistoryStorageService.deleteMatch(matchId);

    if (!mounted) {
      return;
    }

    await refreshMatches();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partida excluída do histórico.')),
    );
  }

  Future<void> confirmDeleteMatch(MatchHistory match) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir partida'),
          content: const Text(
            'Tem certeza que deseja excluir esta partida do histórico local?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await deleteMatch(match.id);
    }
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

              return MatchHistoryCard(
                match: match,
                onDelete: () => confirmDeleteMatch(match),
              );
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
  final VoidCallback onDelete;

  const MatchHistoryCard({
    super.key,
    required this.match,
    required this.onDelete,
  });

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
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Excluir partida',
          onPressed: onDelete,
        ),
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
