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
