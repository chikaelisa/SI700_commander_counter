import '../models/match_history.dart';

abstract class MatchHistoryDataProvider {
  Future<List<MatchHistory>> getMatches();

  Future<void> saveMatch(MatchHistory match);

  Future<void> deleteMatch(String matchId);

  Future<void> clearMatches();
}