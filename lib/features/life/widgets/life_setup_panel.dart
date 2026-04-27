import 'package:flutter/material.dart';

class LifeSetupPanel extends StatelessWidget {
  final int playerCount;
  final int startingLife;
  final bool isCustomStartingLife;
  final ValueChanged<int> onPlayerCountChanged;
  final ValueChanged<int> onStartingLifeChanged;
  final ValueChanged<bool> onCustomStartingLifeChanged;
  final VoidCallback onCreateGame;

  const LifeSetupPanel({
    super.key,
    required this.playerCount,
    required this.startingLife,
    required this.isCustomStartingLife,
    required this.onPlayerCountChanged,
    required this.onStartingLifeChanged,
    required this.onCustomStartingLifeChanged,
    required this.onCreateGame,
  });

  @override
  Widget build(BuildContext context) {
    const playerOptions = [2, 3, 4, 5, 6];
    const lifeOptions = [20, 30, 40, 60];

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
              initialValue: playerCount,
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
            DropdownButtonFormField<String>(
              initialValue: isCustomStartingLife
                  ? 'custom'
                  : startingLife.toString(),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: [
                ...lifeOptions.map(
                  (value) => DropdownMenuItem(
                    value: value.toString(),
                    child: Text('$value de vida'),
                  ),
                ),
                const DropdownMenuItem(
                  value: 'custom',
                  child: Text('Personalizada'),
                ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                if (value == 'custom') {
                  onCustomStartingLifeChanged(true);
                  return;
                }

                onCustomStartingLifeChanged(false);
                onStartingLifeChanged(int.parse(value));
              },
            ),

            if (isCustomStartingLife) ...[
              const SizedBox(height: 16),
              TextFormField(
                initialValue: startingLife.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Vida personalizada',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  final parsedValue = int.tryParse(value);

                  if (parsedValue != null && parsedValue > 0) {
                    onStartingLifeChanged(parsedValue);
                  }
                },
              ),
            ],

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
