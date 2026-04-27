import 'package:commander_counter/features/life/constants/player_card_colors.dart';
import 'package:flutter/material.dart';

import '../models/mana_color.dart';
import '../models/player_life.dart';

class EditPlayerBottomSheet extends StatefulWidget {
  final PlayerLife player;
  final bool canEditCommander;

  final void Function({
    required String name,
    required String commanderName,
    required List<ManaColor> manaColors,
    required Color backgroundColor,
  })
  onSave;

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
  late Color selectedBackgroundColor;
  late List<ManaColor> selectedManaColors;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.player.name);
    commanderController = TextEditingController(
      text: widget.player.commanderName,
    );
    selectedManaColors = List.of(widget.player.manaColors);
    selectedBackgroundColor = widget.player.backgroundColor;
  }

  @override
  void dispose() {
    nameController.dispose();
    commanderController.dispose();

    super.dispose();
  }

  void toggleManaColor(ManaColor manaColor) {
    setState(() {
      if (selectedManaColors.contains(manaColor)) {
        selectedManaColors.remove(manaColor);
      } else {
        selectedManaColors.add(manaColor);
      }
    });
  }

  void save() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      return;
    }

    widget.onSave(
      name: name,
      commanderName: commanderController.text.trim(),
      manaColors: selectedManaColors,
      backgroundColor: selectedBackgroundColor,
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
              const SizedBox(height: 24),
              Text(
                'Identidade de cor',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ManaColor.values.map((manaColor) {
                  final isSelected = selectedManaColors.contains(manaColor);

                  return FilterChip(
                    selected: isSelected,
                    avatar: CircleAvatar(
                      backgroundColor: manaColor.backgroundColor,
                      child: Text(
                        manaColor.symbol,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: manaColor.foregroundColor,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    label: Text(manaColor.label),
                    onSelected: (_) => toggleManaColor(manaColor),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(
                'Cor do card',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: playerCardBackgroundColors.map((color) {
                  final isSelected = selectedBackgroundColor == color;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedBackgroundColor = color;
                      });
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 18)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: save, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
