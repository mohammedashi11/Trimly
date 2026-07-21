import '../entities/user_profile.dart';

/// Session management and profile persistence.
abstract interface class AuthRepository {
  /// The persisted session, or null when signed out.
  Future<UserProfile?> getCurrentUser();

  Future<UserProfile> signIn({required String email, required String password});

  Future<UserProfile> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<UserProfile> signInWithGoogle();

  Future<UserProfile> updateProfile(UserProfile profile);

  Future<void> signOut();

  /// Whether onboarding has been completed on this device.
  Future<bool> hasSeenOnboarding();

  Future<void> markOnboardingSeen();
}
