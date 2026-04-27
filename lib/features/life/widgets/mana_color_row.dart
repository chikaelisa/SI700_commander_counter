import 'package:flutter/material.dart';

import '../models/mana_color.dart';

class ManaColorRow extends StatelessWidget {
  final List<ManaColor> manaColors;
  final VoidCallback onAddPressed;

  const ManaColorRow({
    super.key,
    required this.manaColors,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (manaColors.isEmpty) {
      return InkWell(
        onTap: onAddPressed,
        borderRadius: BorderRadius.circular(999),
        child: const ManaColorPlaceholderBadge(),
      );
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.start,
      children: manaColors.map((manaColor) {
        return ManaColorBadge(manaColor: manaColor);
      }).toList(),
    );
  }
}

class ManaColorPlaceholderBadge extends StatelessWidget {
  const ManaColorPlaceholderBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border.all(color: Colors.black, width: 1),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.add,
        size: 14,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class ManaColorBadge extends StatelessWidget {
  final ManaColor manaColor;

  const ManaColorBadge({super.key, required this.manaColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: manaColor.backgroundColor,
        border: Border.all(color: Colors.black, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        manaColor.symbol,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: manaColor.foregroundColor,
        ),
      ),
    );
  }
}
