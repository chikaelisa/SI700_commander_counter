class MatchHistory {
  final String id;
  final DateTime playedAt;
  final int playerCount;
  final String? winnerName;
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

  String get winnerLabel {
    if (winnerName == null || winnerName!.trim().isEmpty) {
      return 'Sem vencedor';
    }

    return 'Vencedor: $winnerName';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playedAt': playedAt.toIso8601String(),
      'playerCount': playerCount,
      'winnerName': winnerName,
      'comment': comment,
      'players': players.map((player) => player.toJson()).toList(),
    };
  }

  factory MatchHistory.fromJson(Map<String, dynamic> json) {
    return MatchHistory(
      id: json['id'] as String,
      playedAt: DateTime.parse(json['playedAt'] as String),
      playerCount: json['playerCount'] as int,
      winnerName: json['winnerName'] as String?,
      comment: json['comment'] as String,
      players: (json['players'] as List<dynamic>)
          .map(
            (playerJson) =>
                MatchPlayerHistory.fromJson(playerJson as Map<String, dynamic>),
          )
          .toList(),
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'commanderName': commanderName,
      'finalLife': finalLife,
    };
  }

  factory MatchPlayerHistory.fromJson(Map<String, dynamic> json) {
    return MatchPlayerHistory(
      playerName: json['playerName'] as String,
      commanderName: json['commanderName'] as String,
      finalLife: json['finalLife'] as int,
    );
  }
}
