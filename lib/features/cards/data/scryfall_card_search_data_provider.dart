import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/magic_card.dart';
import 'card_search_data_provider.dart';

class ScryfallCardSearchDataProvider implements CardSearchDataProvider {
  final http.Client client;

  ScryfallCardSearchDataProvider({http.Client? client})
    : client = client ?? http.Client();

  @override
  Future<List<MagicCard>> searchCommanderCards(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return [];
    }

    final uri = Uri.https('api.scryfall.com', '/cards/search', {
      'q': '$trimmedQuery is:commander',
      'unique': 'cards',
      'order': 'name',
    });

    final response = await client.get(uri);

    if (response.statusCode == 404) {
      return [];
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erro ao buscar cartas na Scryfall.');
    }

    final decodedJson = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decodedJson['data'] as List<dynamic>? ?? [];

    return data.map((cardJson) {
      return MagicCard.fromScryfallJson(cardJson as Map<String, dynamic>);
    }).toList();
  }
}
