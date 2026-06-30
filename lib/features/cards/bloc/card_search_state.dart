import '../models/magic_card.dart';

sealed class CardSearchState {
  const CardSearchState();
}

class CardSearchInitial extends CardSearchState {
  const CardSearchInitial();
}

class CardSearchLoading extends CardSearchState {
  const CardSearchLoading();
}

class CardSearchLoaded extends CardSearchState {
  final List<MagicCard> cards;

  const CardSearchLoaded(this.cards);
}

class CardSearchEmpty extends CardSearchState {
  const CardSearchEmpty();
}

class CardSearchError extends CardSearchState {
  final String message;

  const CardSearchError(this.message);
}
