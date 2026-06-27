import 'package:commander_counter/features/history/bloc/match_history_event.dart';
import 'package:commander_counter/features/history/bloc/match_history_state.dart';
import 'package:commander_counter/features/history/data/match_history_data_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchHistoryBloc extends Bloc<MatchHistoryEvent, MatchHistoryState> {
  final MatchHistoryDataProvider dataProvider;

  MatchHistoryBloc({required this.dataProvider})
    : super(const MatchHistoryInitial()) {
    on<LoadMatchHistory>(_onLoadMatchHistory);
    on<SaveMatchHistory>(_onSaveMatchHistory);
    on<DeleteMatchHistory>(_onDeleteMatchHistory);
    on<ClearMatchHistory>(_onClearMatchHistory);
  }

  Future<void> _onLoadMatchHistory(
    LoadMatchHistory event,
    Emitter<MatchHistoryState> emit,
  ) async {
    emit(const MatchHistoryLoading());

    try {
      final matches = await dataProvider.getMatches();

      if (matches.isEmpty) {
        emit(const MatchHistoryEmpty());
        return;
      }

      emit(MatchHistoryLoaded(matches));
    } catch (_) {
      emit(
        const MatchHistoryError(
          'Não foi possível carregar o histórico de partidas.',
        ),
      );
    }
  }

  Future<void> _onSaveMatchHistory(
    SaveMatchHistory event,
    Emitter<MatchHistoryState> emit,
  ) async {
    try {
      await dataProvider.saveMatch(event.match);
      add(const LoadMatchHistory());
    } catch (_) {
      emit(
        const MatchHistoryError(
          'Não foi possível salvar a partida no histórico.',
        ),
      );
    }
  }

  Future<void> _onDeleteMatchHistory(
    DeleteMatchHistory event,
    Emitter<MatchHistoryState> emit,
  ) async {
    try {
      await dataProvider.deleteMatch(event.matchId);
      add(const LoadMatchHistory());
    } catch (_) {
      emit(
        const MatchHistoryError(
          'Não foi possível excluir a partida do histórico.',
        ),
      );
    }
  }

  Future<void> _onClearMatchHistory(
    ClearMatchHistory event,
    Emitter<MatchHistoryState> emit,
  ) async {
    try {
      await dataProvider.clearMatches();
      add(const LoadMatchHistory());
    } catch (_) {
      emit(const MatchHistoryError('Não foi possível limpar o histórico.'));
    }
  }
}
