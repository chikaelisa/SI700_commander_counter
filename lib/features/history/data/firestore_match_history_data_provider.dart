import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/match_history.dart';
import 'match_history_data_provider.dart';

class FirestoreMatchHistoryDataProvider implements MatchHistoryDataProvider {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FirestoreMatchHistoryDataProvider({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _matchesCollection() {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }

    return firestore.collection('users').doc(user.uid).collection('matches');
  }

  @override
  Future<List<MatchHistory>> getMatches() async {
    final snapshot = await _matchesCollection()
        .orderBy('playedAt', descending: true)
        .get();

    return snapshot.docs.map((document) {
      return MatchHistory.fromFirestore(id: document.id, json: document.data());
    }).toList();
  }

  @override
  Future<void> saveMatch(MatchHistory match) async {
    await _matchesCollection().doc(match.id).set(match.toFirestoreJson());
  }

  @override
  Future<void> deleteMatch(String matchId) async {
    await _matchesCollection().doc(matchId).delete();
  }

  @override
  Future<void> clearMatches() async {
    final snapshot = await _matchesCollection().get();

    final batch = firestore.batch();

    for (final document in snapshot.docs) {
      batch.delete(document.reference);
    }

    await batch.commit();
  }
}
