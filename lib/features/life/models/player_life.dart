import 'package:flutter/material.dart';

import 'mana_color.dart';

class PlayerLife {
  final String name;
  final int life;
  final String commanderName;
  final String? commanderCardId;
  final String? commanderImageUrl;
  final Color backgroundColor;
  final List<ManaColor> manaColors;

  const PlayerLife({
    required this.name,
    required this.life,
    required this.commanderName,
    required this.backgroundColor,
    this.commanderCardId,
    this.commanderImageUrl,
    this.manaColors = const [],
  });

  PlayerLife copyWith({
    String? name,
    int? life,
    String? commanderName,
    String? commanderCardId,
    String? commanderImageUrl,
    Color? backgroundColor,
    List<ManaColor>? manaColors,
  }) {
    return PlayerLife(
      name: name ?? this.name,
      life: life ?? this.life,
      commanderName: commanderName ?? this.commanderName,
      commanderCardId: commanderCardId ?? this.commanderCardId,
      commanderImageUrl: commanderImageUrl ?? this.commanderImageUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      manaColors: manaColors ?? this.manaColors,
    );
  }
}
