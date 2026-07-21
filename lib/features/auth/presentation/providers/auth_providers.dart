import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_auth_repository.dart';
import '../../domain/entities/user_profile.dart';

/// Holds the signed-in user (null when signed out) and exposes auth actions.
final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserProfile?>(AuthController.new);

class AuthController extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() =>
      ref.watch(authRepositoryProvider).getCurrentUser();

  Future<bool> signIn({required String email, required String password}) =>
      _run(() => ref.read(authRepositoryProvider).signIn(
            email: email,
            password: password,
          ));

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) =>
      _run(() => ref.read(authRepositoryProvider).signUp(
            name: name,
            email: email,
            password: password,
          ));

  Future<bool> signInWithGoogle() =>
      _run(() => ref.read(authRepositoryProvider).signInWithGoogle());

  Future<bool> updateProfile(UserProfile profile) =>
      _run(() => ref.read(authRepositoryProvider).updateProfile(profile));

  Future<void> signOut() async {
    state = const AsyncLoading();
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }

  Future<bool> _run(Future<UserProfile> Function() action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
    return state.valueOrNull != null;
  }
}
