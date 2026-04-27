import 'package:flutter/material.dart';

import '../models/player_life.dart';

class EditPlayerBottomSheet extends StatefulWidget {
  final PlayerLife player;
  final bool canEditCommander;
  final void Function({
    required String name,
    required String commanderName,
  }) onSave;

  const EditPlayerBottomSheet({
    super.key,
    required this.player,
    required this.canEditCommander,
    required this.onSave,
  });

  @override
  State<EditPlayerBottomSheet> createState() => _EditPlayerBottomSheetState();
}

class _EditPlayerBottomSheetState extends State<EditPlayerBottomSheet> {
  late final TextEditingController nameController;
  late final TextEditingController commanderController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.player.name);
    commanderController = TextEditingController(
      text: widget.player.commanderName,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    commanderController.dispose();

    super.dispose();
  }

  void save() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      return;
    }

    widget.onSave(
      name: name,
      commanderName: commanderController.text.trim(),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                'Configurar jogador',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome do jogador',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commanderController,
                enabled: widget.canEditCommander,
                decoration: InputDecoration(
                  labelText: 'Comandante',
                  helperText: widget.canEditCommander
                      ? 'Digite o nome do comandante usado na partida.'
                      : 'Faça login para registrar o comandante.',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: save,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}