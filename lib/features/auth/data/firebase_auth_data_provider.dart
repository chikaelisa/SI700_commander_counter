import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import 'auth_data_provider.dart';

class FirebaseAuthDataProvider implements AuthDataProvider {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FirebaseAuthDataProvider({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Usuário autenticado não encontrado.');
    }

    return _getUserProfile(firebaseUser);
  }

  @override
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Usuário criado não encontrado.');
    }

    await firebaseUser.updateDisplayName(name);

    final userDocument = firestore.collection('users').doc(firebaseUser.uid);

    await userDocument.set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return AppUser(id: firebaseUser.uid, name: name, email: email);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<AppUser> _getUserProfile(User firebaseUser) async {
    final userDocument = firestore.collection('users').doc(firebaseUser.uid);
    final snapshot = await userDocument.get();

    if (!snapshot.exists) {
      final fallbackName = firebaseUser.displayName ?? 'Usuário Commander';
      final fallbackEmail = firebaseUser.email ?? '';

      await userDocument.set({
        'name': fallbackName,
        'email': fallbackEmail,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return AppUser(
        id: firebaseUser.uid,
        name: fallbackName,
        email: fallbackEmail,
      );
    }

    final data = snapshot.data();

    return AppUser(
      id: firebaseUser.uid,
      name: data?['name'] as String? ?? 'Usuário Commander',
      email: data?['email'] as String? ?? firebaseUser.email ?? '',
    );
  }
}
