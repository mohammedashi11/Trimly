import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../../core/utils/mock_latency.dart';
import '../domain/entities/user_profile.dart';
import '../domain/repositories/auth_repository.dart';

/// Local mock implementation of [AuthRepository].
///
/// Accepts any well-formed credentials and persists the session locally,
/// mirroring the surface a real backend implementation would expose.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _sessionKey = 'trimly.session';
  static const _onboardingKey = 'trimly.onboarding_seen';

  @override
  Future<UserProfile?> getCurrentUser() async {
    final raw = _prefs.getString(_sessionKey);
    if (raw == null) return null;
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    await simulateLatency();
    // Derive a display name from the email for returning "accounts".
    final localPart = email.split('@').first.replaceAll(RegExp(r'[._]'), ' ');
    final name = localPart
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
    return _persist(UserProfile(name: name, email: email));
  }

  @override
  Future<UserProfile> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await simulateLatency();
    return _persist(UserProfile(name: name, email: email));
  }

  @override
  Future<UserProfile> signInWithGoogle() async {
    await simulateLatency();
    return _persist(
      const UserProfile(
        name: 'Mohammed Ashi',
        email: 'mohammed.ashi@gmail.com',
        phone: '+1 (555) 000-1234',
      ),
    );
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    await simulateLatency();
    return _persist(profile);
  }

  @override
  Future<void> signOut() async {
    await simulateLatency();
    await _prefs.remove(_sessionKey);
  }

  @override
  Future<bool> hasSeenOnboarding() async =>
      _prefs.getBool(_onboardingKey) ?? false;

  @override
  Future<void> markOnboardingSeen() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  Future<UserProfile> _persist(UserProfile profile) async {
    await _prefs.setString(_sessionKey, jsonEncode(profile.toJson()));
    return profile;
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => MockAuthRepository(ref.watch(sharedPreferencesProvider)),
);
