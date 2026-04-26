class MatchHistory {
  final String id;
  final DateTime playedAt;
  final int playerCount;
  final String winnerName;
  final String comment;
  final List<MatchPlayerHistory> players;

  const MatchHistory({
    required this.id,
    required this.playedAt,
    required this.playerCount,
    required this.winnerName,
    required this.comment,
    required this.players,
  });
}

class MatchPlayerHistory {
  final String playerName;
  final String commanderName;
  final int finalLife;

  const MatchPlayerHistory({
    required this.playerName,
    required this.commanderName,
    required this.finalLife,
  });
}
