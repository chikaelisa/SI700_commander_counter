import 'package:flutter/material.dart';

import '../../shared/widgets/under_development_page.dart';

class CountersPage extends StatelessWidget {
  final VoidCallback? onGoToLife;

  const CountersPage({super.key, this.onGoToLife});

  @override
  Widget build(BuildContext context) {
    return UnderDevelopmentPage(
      title: 'Counters em desenvolvimento',
      description:
          'Nesta área, futuramente você poderá criar contadores personalizados para veneno, commander damage, energia, storm e outros marcadores.',
      icon: Icons.add_chart_outlined,
      onPrimaryAction: onGoToLife,
    );
  }
}
