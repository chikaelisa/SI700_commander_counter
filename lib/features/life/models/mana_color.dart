import 'package:flutter/material.dart';

enum ManaColor { white, blue, black, red, green, colorless }

extension ManaColorLabel on ManaColor {
  String get symbol {
    switch (this) {
      case ManaColor.white:
        return 'W';
      case ManaColor.blue:
        return 'U';
      case ManaColor.black:
        return 'B';
      case ManaColor.red:
        return 'R';
      case ManaColor.green:
        return 'G';
      case ManaColor.colorless:
        return 'C';
    }
  }

  String get label {
    switch (this) {
      case ManaColor.white:
        return 'Branco';
      case ManaColor.blue:
        return 'Azul';
      case ManaColor.black:
        return 'Preto';
      case ManaColor.red:
        return 'Vermelho';
      case ManaColor.green:
        return 'Verde';
      case ManaColor.colorless:
        return 'Incolor';
    }
  }
}

extension ManaColorStyle on ManaColor {
  Color get backgroundColor {
    switch (this) {
      case ManaColor.white:
        return const Color(0xFFF3E8C8);
      case ManaColor.blue:
        return const Color(0xFF3B82F6);
      case ManaColor.black:
        return const Color(0xFF1F2937);
      case ManaColor.red:
        return const Color(0xFFEF4444);
      case ManaColor.green:
        return const Color(0xFF22C55E);
      case ManaColor.colorless:
        return const Color(0xFFE5E7EB);
    }
  }

  Color get foregroundColor {
    switch (this) {
      case ManaColor.white:
      case ManaColor.green:
      case ManaColor.colorless:
        return Colors.black;
      case ManaColor.blue:
      case ManaColor.black:
      case ManaColor.red:
        return Colors.white;
    }
  }
}

ManaColor? manaColorFromSymbol(String symbol) {
  switch (symbol.toUpperCase()) {
    case 'W':
      return ManaColor.white;
    case 'U':
      return ManaColor.blue;
    case 'B':
      return ManaColor.black;
    case 'R':
      return ManaColor.red;
    case 'G':
      return ManaColor.green;
    case 'C':
      return ManaColor.colorless;
    default:
      return null;
  }
}
