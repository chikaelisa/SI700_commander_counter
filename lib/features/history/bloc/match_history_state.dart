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
  final String? successMessage;

  const MatchHistoryLoaded(this.matches, {this.successMessage});
}

class MatchHistoryEmpty extends MatchHistoryState {
  final String? successMessage;

  const MatchHistoryEmpty({this.successMessage});
}

class MatchHistoryError extends MatchHistoryState {
  final String message;

  const MatchHistoryError(this.message);
}
