import '../models/match_history.dart';

sealed class MatchHistoryEvent {
  const MatchHistoryEvent();
}

class LoadMatchHistory extends MatchHistoryEvent {
  const LoadMatchHistory();
}

class SaveMatchHistory extends MatchHistoryEvent {
  final MatchHistory match;

  const SaveMatchHistory(this.match);
}

class DeleteMatchHistory extends MatchHistoryEvent {
  final String matchId;

  const DeleteMatchHistory(this.matchId);
}

class ClearMatchHistory extends MatchHistoryEvent {
  const ClearMatchHistory();
}
