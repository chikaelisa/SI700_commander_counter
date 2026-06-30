sealed class CardSearchEvent {
  const CardSearchEvent();
}

class SearchCommanderCardsRequested extends CardSearchEvent {
  final String query;

  const SearchCommanderCardsRequested(this.query);
}

class ClearCardSearch extends CardSearchEvent {
  const ClearCardSearch();
}
