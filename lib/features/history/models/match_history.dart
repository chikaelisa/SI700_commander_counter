import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toFirestoreJson() {
    return {
      'playedAt': Timestamp.fromDate(playedAt),
      'playerCount': playerCount,
      'winnerName': winnerName,
      'comment': comment,
      'players': players.map((player) => player.toJson()).toList(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory MatchHistory.fromJson(Map<String, dynamic> json) {
    return MatchHistory(
      id: json['id'] as String,
      playedAt: _parseDate(json['playedAt']),
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

  factory MatchHistory.fromFirestore({
    required String id,
    required Map<String, dynamic> json,
  }) {
    return MatchHistory(
      id: id,
      playedAt: _parseDate(json['playedAt']),
      playerCount: json['playerCount'] as int? ?? 0,
      winnerName: json['winnerName'] as String?,
      comment: json['comment'] as String? ?? '',
      players: (json['players'] as List<dynamic>? ?? [])
          .map(
            (playerJson) =>
                MatchPlayerHistory.fromJson(playerJson as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String) {
      return DateTime.parse(value);
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }
}

class MatchPlayerHistory {
  final String playerName;
  final String commanderName;
  final String? commanderCardId;
  final String? commanderImageUrl;
  final int finalLife;
  final List<String> manaColors;

  const MatchPlayerHistory({
    required this.playerName,
    required this.commanderName,
    required this.finalLife,
    this.commanderCardId,
    this.commanderImageUrl,
    this.manaColors = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'commanderName': commanderName,
      'commanderCardId': commanderCardId,
      'commanderImageUrl': commanderImageUrl,
      'finalLife': finalLife,
      'manaColors': manaColors,
    };
  }

  factory MatchPlayerHistory.fromJson(Map<String, dynamic> json) {
    return MatchPlayerHistory(
      playerName: json['playerName'] as String? ?? '',
      commanderName: json['commanderName'] as String? ?? '',
      commanderCardId: json['commanderCardId'] as String?,
      commanderImageUrl: json['commanderImageUrl'] as String?,
      finalLife: json['finalLife'] as int? ?? 0,
      manaColors: (json['manaColors'] as List<dynamic>? ?? [])
          .map((manaColor) => manaColor as String)
          .toList(),
    );
  }
}
