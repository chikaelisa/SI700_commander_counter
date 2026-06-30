import 'package:commander_counter/features/history/models/match_history.dart';
import 'package:commander_counter/features/life/widgets/life_game_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../history/bloc/match_history_bloc.dart';
import '../history/bloc/match_history_event.dart';
import '../history/bloc/match_history_state.dart';
import 'constants/player_card_colors.dart';
import 'models/mana_color.dart';
import 'models/player_life.dart';
import 'widgets/edit_player_bottom_sheet.dart';
import 'widgets/end_game_bottom_sheet.dart';
import 'widgets/life_setup_panel.dart';

class LifePage extends StatefulWidget {
  final bool isLoggedIn;

  const LifePage({super.key, required this.isLoggedIn});

  @override
  State<LifePage> createState() => _LifePageState();
}

class _LifePageState extends State<LifePage> {
  int playerCount = 4;
  int startingLife = 40;
  bool isCustomStartingLife = false;
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
          backgroundColor:
              playerCardBackgroundColors[index %
                  playerCardBackgroundColors.length],
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

  void resetGame() {
    setState(() {
      players = [];
    });
  }

  void updatePlayerName(int index, String newName) {
    final trimmedName = newName.trim();

    if (trimmedName.isEmpty) {
      return;
    }

    setState(() {
      final player = players[index];

      players[index] = player.copyWith(name: trimmedName);
    });
  }

  void updateCommanderName(int index, String newCommanderName) {
    setState(() {
      final player = players[index];

      players[index] = player.copyWith(commanderName: newCommanderName.trim());
    });
  }

  void updatePlayerSettings({
    required int index,
    required String name,
    required String commanderName,
    required List<ManaColor> manaColors,
    required Color backgroundColor,
  }) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return;
    }

    setState(() {
      final player = players[index];

      players[index] = player.copyWith(
        name: trimmedName,
        commanderName: commanderName.trim(),
        manaColors: manaColors,
        backgroundColor: backgroundColor,
      );
    });
  }

  void updateCustomStartingLife(bool value) {
    setState(() {
      isCustomStartingLife = value;
    });
  }

  Future<void> finishGame({
    required String? winnerName,
    required String comment,
  }) async {
    if (!widget.isLoggedIn) {
      if (!mounted) {
        return;
      }

      setState(() {
        players = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Partida encerrada sem salvar.')),
      );

      return;
    }

    final matchHistory = MatchHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      playedAt: DateTime.now(),
      playerCount: players.length,
      winnerName: winnerName,
      comment: comment,
      players: players.map((player) {
        return MatchPlayerHistory(
          playerName: player.name,
          commanderName: player.commanderName,
          finalLife: player.life,
        );
      }).toList(),
    );

    context.read<MatchHistoryBloc>().add(SaveMatchHistory(matchHistory));
  }

  Future<void> showEditNameDialog(int index) async {
    final controller = TextEditingController(text: players[index].name);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar nome'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nome do jogador',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (newName != null) {
      updatePlayerName(index, newName);
    }
  }

  Future<void> showEditCommanderDialog(int index) async {
    final controller = TextEditingController(
      text: players[index].commanderName,
    );

    final newCommanderName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar comandante'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nome do comandante',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (newCommanderName != null) {
      updateCommanderName(index, newCommanderName);
    }
  }

  Future<void> showEditPlayerBottomSheet(int index) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return EditPlayerBottomSheet(
          player: players[index],
          canEditCommander: widget.isLoggedIn,
          onSave:
              ({
                required String name,
                required String commanderName,
                required List<ManaColor> manaColors,
                required Color backgroundColor,
              }) {
                updatePlayerSettings(
                  index: index,
                  name: name,
                  commanderName: commanderName,
                  manaColors: manaColors,
                  backgroundColor: backgroundColor,
                );
              },
        );
      },
    );
  }

  Future<void> showEndGameBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return EndGameBottomSheet(
          players: players,
          isLoggedIn: widget.isLoggedIn,
          onFinishGame:
              ({required String? winnerName, required String comment}) async {
                await finishGame(winnerName: winnerName, comment: comment);
              },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MatchHistoryBloc, MatchHistoryState>(
      listener: (context, state) {
        if (state is MatchHistoryError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));

          return;
        }

        if (state is MatchHistoryLoaded && state.successMessage != null) {
          setState(() {
            players = [];
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage!)));

          return;
        }

        if (state is MatchHistoryEmpty && state.successMessage != null) {
          setState(() {
            players = [];
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
        }
      },
      child: _buildLifeContent(),
    );
  }

  Widget _buildLifeContent() {
    if (players.isEmpty) {
      return LifeSetupPanel(
        playerCount: playerCount,
        startingLife: startingLife,
        isCustomStartingLife: isCustomStartingLife,
        onPlayerCountChanged: updatePlayerCount,
        onStartingLifeChanged: updateStartingLife,
        onCustomStartingLifeChanged: updateCustomStartingLife,
        onCreateGame: createGame,
      );
    }

    return LifeGameView(
      players: players,
      isLoggedIn: widget.isLoggedIn,
      onResetGame: resetGame,
      onIncrementLife: incrementLife,
      onDecrementLife: decrementLife,
      onEditName: showEditNameDialog,
      onEditCommander: showEditCommanderDialog,
      onOpenPlayerSettings: showEditPlayerBottomSheet,
      onEndGame: showEndGameBottomSheet,
    );
  }
}
