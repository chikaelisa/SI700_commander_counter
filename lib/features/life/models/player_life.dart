import 'package:flutter/material.dart';

import 'mana_color.dart';

class PlayerLife {
  final String name;
  final int life;
  final String commanderName;
  final Color backgroundColor;
  final List<ManaColor> manaColors;

  const PlayerLife({
    required this.name,
    required this.life,
    required this.commanderName,
    required this.backgroundColor,
    this.manaColors = const [],
  });

  PlayerLife copyWith({
    String? name,
    int? life,
    String? commanderName,
    Color? backgroundColor,
    List<ManaColor>? manaColors,
  }) {
    return PlayerLife(
      name: name ?? this.name,
      life: life ?? this.life,
      commanderName: commanderName ?? this.commanderName,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
