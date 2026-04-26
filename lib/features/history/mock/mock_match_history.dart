import '../models/match_history.dart';

final mockMatchHistory = [
  MatchHistory(
    id: '1',
    playedAt: DateTime(2026, 4, 18, 21, 30),
    playerCount: 4,
    winnerName: 'Chika',
    comment: 'Partida longa, vencida com combo no late game.',
    players: const [
      MatchPlayerHistory(
        playerName: 'Chika',
        commanderName: 'Meren of Clan Nel Toth',
        finalLife: 12,
      ),
      MatchPlayerHistory(
        playerName: 'Lia',
        commanderName: 'Atraxa, Praetors’ Voice',
        finalLife: 0,
      ),
      MatchPlayerHistory(
        playerName: 'Rafa',
        commanderName: 'Krenko, Mob Boss',
        finalLife: -3,
      ),
      MatchPlayerHistory(
        playerName: 'Nina',
        commanderName: 'Yuriko, the Tiger’s Shadow',
        finalLife: 0,
      ),
    ],
  ),
  MatchHistory(
    id: '2',
    playedAt: DateTime(2026, 4, 10, 19, 15),
    playerCount: 3,
    winnerName: 'Rafa',
    comment: 'Agressivo desde o início. A mesa não conseguiu estabilizar.',
    players: const [
      MatchPlayerHistory(
        playerName: 'Chika',
        commanderName: 'Teysa Karlov',
        finalLife: 0,
      ),
      MatchPlayerHistory(
        playerName: 'Rafa',
        commanderName: 'Najeela, the Blade-Blossom',
        finalLife: 24,
      ),
      MatchPlayerHistory(
        playerName: 'Lia',
        commanderName: 'Muldrotha, the Gravetide',
        finalLife: -1,
      ),
    ],
  ),
  MatchHistory(
    id: '3',
    playedAt: DateTime(2026, 3, 29, 22, 5),
    playerCount: 5,
    winnerName: 'Nina',
    comment: 'Partida caótica com muitos counters e politics.',
    players: const [
      MatchPlayerHistory(
        playerName: 'Chika',
        commanderName: 'Edgar Markov',
        finalLife: 0,
      ),
      MatchPlayerHistory(
        playerName: 'Nina',
        commanderName: 'Kenrith, the Returned King',
        finalLife: 7,
      ),
      MatchPlayerHistory(
        playerName: 'Rafa',
        commanderName: 'Omnath, Locus of Creation',
        finalLife: 0,
      ),
      MatchPlayerHistory(
        playerName: 'Lia',
        commanderName: 'Alela, Artful Provocateur',
        finalLife: -2,
      ),
      MatchPlayerHistory(
        playerName: 'Bia',
        commanderName: 'Miirym, Sentinel Wyrm',
        finalLife: 0,
      ),
    ],
  ),
];
