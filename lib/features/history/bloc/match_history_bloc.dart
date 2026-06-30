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
    on<UpdateMatchComment>(_onUpdateMatchComment);
  }

  Future<void> _emitCurrentMatches(
    Emitter<MatchHistoryState> emit, {
    String? successMessage,
  }) async {
    final matches = await dataProvider.getMatches();

    if (matches.isEmpty) {
      emit(MatchHistoryEmpty(successMessage: successMessage));
      return;
    }

    emit(MatchHistoryLoaded(matches, successMessage: successMessage));
  }

  Future<void> _onLoadMatchHistory(
    LoadMatchHistory event,
    Emitter<MatchHistoryState> emit,
  ) async {
    emit(const MatchHistoryLoading());

    try {
      await _emitCurrentMatches(emit);
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

      await _emitCurrentMatches(
        emit,
        successMessage: 'Partida salva no histórico.',
      );
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

      await _emitCurrentMatches(
        emit,
        successMessage: 'Partida excluída do histórico.',
      );
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

      await _emitCurrentMatches(emit, successMessage: 'Histórico limpo.');
    } catch (_) {
      emit(const MatchHistoryError('Não foi possível limpar o histórico.'));
    }
  }

  Future<void> _onUpdateMatchComment(
    UpdateMatchComment event,
    Emitter<MatchHistoryState> emit,
  ) async {
    try {
      await dataProvider.updateMatchComment(
        matchId: event.matchId,
        comment: event.comment,
      );

      await _emitCurrentMatches(emit, successMessage: 'Comentário atualizado.');
    } catch (_) {
      emit(const MatchHistoryError('Não foi possível atualizar o comentário.'));
    }
  }
}
