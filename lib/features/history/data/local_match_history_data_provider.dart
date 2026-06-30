import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/match_history.dart';
import 'match_history_data_provider.dart';

class LocalMatchHistoryDataProvider implements MatchHistoryDataProvider {
  static const String _storageKey = 'match_history';

  @override
  Future<List<MatchHistory>> getMatches() async {
    final preferences = await SharedPreferences.getInstance();
    final matchesJson = preferences.getStringList(_storageKey) ?? [];

    return matchesJson.map((matchJson) {
      final decodedJson = jsonDecode(matchJson) as Map<String, dynamic>;
      return MatchHistory.fromJson(decodedJson);
    }).toList();
  }

  @override
  Future<void> saveMatch(MatchHistory match) async {
    final preferences = await SharedPreferences.getInstance();
    final matches = await getMatches();

    final updatedMatches = [match, ...matches];

    final matchesJson = updatedMatches.map((match) {
      return jsonEncode(match.toJson());
    }).toList();

    await preferences.setStringList(_storageKey, matchesJson);
  }

  @override
  Future<void> deleteMatch(String matchId) async {
    final preferences = await SharedPreferences.getInstance();
    final matches = await getMatches();

    final updatedMatches = matches.where((match) {
      return match.id != matchId;
    }).toList();

    final matchesJson = updatedMatches.map((match) {
      return jsonEncode(match.toJson());
    }).toList();

    await preferences.setStringList(_storageKey, matchesJson);
  }

  @override
  Future<void> clearMatches() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_storageKey);
  }

  @override
  Future<void> updateMatchComment({
    required String matchId,
    required String comment,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final matches = await getMatches();

    final updatedMatches = matches.map((match) {
      if (match.id != matchId) {
        return match;
      }

      return MatchHistory(
        id: match.id,
        playedAt: match.playedAt,
        playerCount: match.playerCount,
        winnerName: match.winnerName,
        comment: comment,
        players: match.players,
      );
    }).toList();

    final matchesJson = updatedMatches.map((match) {
      return jsonEncode(match.toJson());
    }).toList();

    await preferences.setStringList(_storageKey, matchesJson);
  }
}
