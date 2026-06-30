import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/card_search_data_provider.dart';
import 'card_search_event.dart';
import 'card_search_state.dart';

class CardSearchBloc extends Bloc<CardSearchEvent, CardSearchState> {
  final CardSearchDataProvider dataProvider;

  CardSearchBloc({required this.dataProvider})
    : super(const CardSearchInitial()) {
    on<SearchCommanderCardsRequested>(_onSearchCommanderCardsRequested);
    on<ClearCardSearch>(_onClearCardSearch);
  }

  Future<void> _onSearchCommanderCardsRequested(
    SearchCommanderCardsRequested event,
    Emitter<CardSearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(const CardSearchInitial());
      return;
    }

    emit(const CardSearchLoading());

    try {
      final cards = await dataProvider.searchCommanderCards(query);

      if (cards.isEmpty) {
        emit(const CardSearchEmpty());
        return;
      }

      emit(CardSearchLoaded(cards));
    } catch (_) {
      emit(const CardSearchError('Não foi possível buscar cartas agora.'));
    }
  }

  void _onClearCardSearch(
    ClearCardSearch event,
    Emitter<CardSearchState> emit,
  ) {
    emit(const CardSearchInitial());
  }
}
