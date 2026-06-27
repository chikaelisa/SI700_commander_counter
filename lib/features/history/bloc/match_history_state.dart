import '../models/match_history.dart';

sealed class MatchHistoryState {
  const MatchHistoryState();
}

class MatchHistoryInitial extends MatchHistoryState {
  const MatchHistoryInitial();
}

class MatchHistoryLoading extends MatchHistoryState {
  const MatchHistoryLoading();
}

class MatchHistoryLoaded extends MatchHistoryState {
  final List<MatchHistory> matches;

  const MatchHistoryLoaded(this.matches);
}

class MatchHistoryEmpty extends MatchHistoryState {
  const MatchHistoryEmpty();
}

class MatchHistoryError extends MatchHistoryState {
  final String message;

  const MatchHistoryError(this.message);
}
