import 'package:flutter/material.dart';

import '../models/player_life.dart';

class EndGameBottomSheet extends StatefulWidget {
  final List<PlayerLife> players;
  final bool isLoggedIn;
  final Future<void> Function({
    required String? winnerName,
    required String comment,
  })
  onFinishGame;

  const EndGameBottomSheet({
    super.key,
    required this.players,
    required this.isLoggedIn,
    required this.onFinishGame,
  });

  @override
  State<EndGameBottomSheet> createState() => _EndGameBottomSheetState();
}

class _EndGameBottomSheetState extends State<EndGameBottomSheet> {
  String? selectedWinnerName = 'no_winner';
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> finishGame() async {
    final winnerName = selectedWinnerName == 'no_winner'
        ? null
        : selectedWinnerName;

    final comment = commentController.text.trim();

    Navigator.of(context).pop();

    await widget.onFinishGame(winnerName: winnerName, comment: comment);
  }

  @override
  Widget build(BuildContext context) {
    final canSaveDetails = widget.isLoggedIn;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: SizedBox(
          height: screenHeight * 0.65,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Encerrar partida',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  canSaveDetails
                      ? 'Selecione o vencedor e adicione um comentário, se quiser.'
                      : 'Faça login para salvar vencedor, comentário e histórico da partida.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                if (canSaveDetails) ...[
                  DropdownButtonFormField<String>(
                    initialValue: selectedWinnerName,
                    decoration: const InputDecoration(
                      labelText: 'Vencedor',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: 'no_winner',
                        child: Text('Sem vencedor'),
                      ),
                      ...widget.players.map(
                        (player) => DropdownMenuItem<String>(
                          value: player.name,
                          child: Text(player.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedWinnerName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Comentário',
                      hintText: 'Ex.: vitória por combo, partida longa...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],

                const Spacer(),

                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Voltar'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: finishGame,
                  child: Text(
                    canSaveDetails
                        ? 'Finalizar partida'
                        : 'Encerrar sem salvar',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
