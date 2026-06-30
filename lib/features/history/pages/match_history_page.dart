import 'package:commander_counter/features/history/bloc/match_history_bloc.dart';
import 'package:commander_counter/features/life/models/mana_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/match_history_event.dart';
import '../bloc/match_history_state.dart';
import '../models/match_history.dart';

class MatchHistoryPage extends StatefulWidget {
  const MatchHistoryPage({super.key});

  @override
  State<MatchHistoryPage> createState() => _MatchHistoryPageState();
}

class _MatchHistoryPageState extends State<MatchHistoryPage> {
  @override
  void initState() {
    super.initState();

    context.read<MatchHistoryBloc>().add(const LoadMatchHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de partidas')),
      body: BlocConsumer<MatchHistoryBloc, MatchHistoryState>(
        listener: (context, state) {
          if (state is MatchHistoryError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));

            return;
          }

          if (state is MatchHistoryLoaded && state.successMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.successMessage!)));

            return;
          }

          if (state is MatchHistoryEmpty && state.successMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
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
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final match = state.matches[index];

                return MatchHistoryCard(
                  match: match,
                  onEditComment: () =>
                      editMatchComment(context: context, match: match),
                  onDelete: () =>
                      confirmDeleteMatch(context: context, match: match),
                );
              },
            );
          }

          return const EmptyMatchHistoryView();
        },
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
            'Tem certeza que deseja excluir esta partida do histórico?',
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
    }
  }

  Future<void> editMatchComment({
    required BuildContext context,
    required MatchHistory match,
  }) async {
    final controller = TextEditingController(text: match.comment);

    final newComment = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar comentário'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Comentário',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(controller.text);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (newComment != null && context.mounted) {
      context.read<MatchHistoryBloc>().add(
        UpdateMatchComment(matchId: match.id, comment: newComment.trim()),
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
  final VoidCallback onEditComment;

  const MatchHistoryCard({
    super.key,
    required this.match,
    required this.onDelete,
    required this.onEditComment,
  });

  List<ManaColor> parseManaColors(List<String> symbols) {
    return symbols.map(manaColorFromSymbol).whereType<ManaColor>().toList();
  }

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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Editar comentário',
              onPressed: onEditComment,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Excluir partida',
              onPressed: onDelete,
            ),
          ],
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

          ...match.players.map((player) {
            final manaColors = parseManaColors(player.manaColors);

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CommanderHistoryImage(
                imageUrl: player.commanderImageUrl,
              ),
              title: Text(player.playerName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.commanderName.trim().isEmpty
                        ? 'Sem comandante informado'
                        : player.commanderName,
                  ),
                  if (manaColors.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    ManaHistoryRow(manaColors: manaColors),
                  ],
                ],
              ),
              trailing: Text(
                '${player.finalLife}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class CommanderHistoryImage extends StatelessWidget {
  final String? imageUrl;

  const CommanderHistoryImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 44,
        height: 60,
        child: hasImage
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const ColoredBox(
                    color: Color(0xFFE5E7EB),
                    child: Icon(Icons.broken_image_outlined),
                  );
                },
              )
            : const ColoredBox(
                color: Color(0xFFE5E7EB),
                child: Icon(Icons.image_not_supported_outlined),
              ),
      ),
    );
  }
}

class ManaHistoryRow extends StatelessWidget {
  final List<ManaColor> manaColors;

  const ManaHistoryRow({super.key, required this.manaColors});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: manaColors.map((manaColor) {
        return Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: manaColor.backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Text(
            manaColor.symbol,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: manaColor.foregroundColor,
            ),
          ),
        );
      }).toList(),
    );
  }
}
