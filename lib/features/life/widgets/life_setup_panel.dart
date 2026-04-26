import 'package:flutter/material.dart';

class LifeSetupPanel extends StatelessWidget {
  final int playerCount;
  final int startingLife;
  final ValueChanged<int> onPlayerCountChanged;
  final ValueChanged<int> onStartingLifeChanged;
  final VoidCallback onCreateGame;

  const LifeSetupPanel({
    super.key,
    required this.playerCount,
    required this.startingLife,
    required this.onPlayerCountChanged,
    required this.onStartingLifeChanged,
    required this.onCreateGame,
  });

  @override
  Widget build(BuildContext context) {
    const playerOptions = [2, 3, 4, 5, 6, 7, 8];
    const lifeOptions = [20, 30, 40];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Configurar partida',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Escolha a quantidade de jogadores e a vida inicial.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Text('Jogadores', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: playerCount,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: playerOptions
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text('$value jogadores'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onPlayerCountChanged(value);
                }
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Vida inicial',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: startingLife,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: lifeOptions
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text('$value de vida'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onStartingLifeChanged(value);
                }
              },
            ),
            const Spacer(),
            FilledButton(
              onPressed: onCreateGame,
              child: const Text('Criar partida'),
            ),
          ],
        ),
      ),
    );
  }
}
