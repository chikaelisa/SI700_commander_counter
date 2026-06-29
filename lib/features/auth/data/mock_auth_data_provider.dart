import '../models/app_user.dart';
import 'auth_data_provider.dart';

class MockAuthDataProvider implements AuthDataProvider {
  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return AppUser(name: 'Usuário Commander', email: email);
  }

  @override
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return AppUser(name: name, email: email);
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
