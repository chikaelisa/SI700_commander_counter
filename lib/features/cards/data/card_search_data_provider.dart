import '../models/magic_card.dart';

abstract class CardSearchDataProvider {
  Future<List<MagicCard>> searchCommanderCards(String query);
}
