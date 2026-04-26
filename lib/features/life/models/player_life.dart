import 'package:flutter/material.dart';

class PlayerLife {
  final String name;
  final int life;
  final String commanderName;
  final Color backgroundColor;

  const PlayerLife({
    required this.name,
    required this.life,
    required this.commanderName,
    required this.backgroundColor,
  });

  PlayerLife copyWith({
    String? name,
    int? life,
    String? commanderName,
    Color? backgroundColor,
  }) {
    return PlayerLife(
      name: name ?? this.name,
      life: life ?? this.life,
      commanderName: commanderName ?? this.commanderName,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
