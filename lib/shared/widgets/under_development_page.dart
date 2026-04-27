import 'package:flutter/material.dart';

class UnderDevelopmentPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onPrimaryAction;

  const UnderDevelopmentPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (onPrimaryAction != null) ...[
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: onPrimaryAction,
                  icon: const Icon(Icons.favorite),
                  label: const Text('Ir para contador de vida'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
