import 'package:commander_counter/features/history/bloc/lib/features/history/bloc/match_history_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/match_history_event.dart';
import '../bloc/match_history_state.dart';
import '../data/local_match_history_data_provider.dart';
import '../models/match_history.dart';

class MatchHistoryPage extends StatelessWidget {
  const MatchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MatchHistoryBloc(dataProvider: LocalMatchHistoryDataProvider())
            ..add(const LoadMatchHistory()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Histórico de partidas')),
        body: BlocConsumer<MatchHistoryBloc, MatchHistoryState>(
          listener: (context, state) {
            if (state is MatchHistoryError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is MatchHistoryInitial || state is MatchHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MatchHistoryError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
            }

            if (state is MatchHistoryEmpty) {
              return const EmptyMatchHistoryView();
            }

            if (state is MatchHistoryLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.matches.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final match = state.matches[index];

                  return MatchHistoryCard(
                    match: match,
                    onDelete: () =>
                        confirmDeleteMatch(context: context, match: match),
                  );
                },
              );
            }

            return const EmptyMatchHistoryView();
          },
        ),
      ),
    );
  }

  Future<void> confirmDeleteMatch({
    required BuildContext context,
    required MatchHistory match,
  }) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir partida'),
          content: const Text(
            'Tem certeza que deseja excluir esta partida do histórico local?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && context.mounted) {
      context.read<MatchHistoryBloc>().add(DeleteMatchHistory(match.id));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Partida excluída do histórico.')),
      );
    }
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
