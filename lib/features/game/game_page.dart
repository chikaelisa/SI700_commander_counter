import 'package:flutter/material.dart';

import '../../shared/widgets/under_development_page.dart';

class GamePage extends StatelessWidget {
  final VoidCallback? onGoToLife;

  const GamePage({super.key, this.onGoToLife});

  @override
  Widget build(BuildContext context) {
    return UnderDevelopmentPage(
      title: 'Game em desenvolvimento',
      description:
          'Nesta área, futuramente você poderá acompanhar partidas salvas, criar mesas e gerenciar dados mais completos do jogo.',
      icon: Icons.extension_outlined,
      onPrimaryAction: onGoToLife,
    );
  }
}
