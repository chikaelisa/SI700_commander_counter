import 'package:flutter/material.dart';

class AuthRequiredPage extends StatelessWidget {
  final String title;
  final VoidCallback onLoginPressed;

  const AuthRequiredPage({
    super.key,
    required this.title,
    required this.onLoginPressed,
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
                Icons.lock_outline,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Você precisa fazer login para acessar esta área.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onLoginPressed,
                child: const Text('Fazer login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
