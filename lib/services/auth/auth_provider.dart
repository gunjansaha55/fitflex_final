import 'package:fitness/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get getCurrentUser;

  AuthUser? get user;

  Future<void> initialize();

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendEmailVerification();

  Future<void> sendPasswordReset({required String toEmail});

  Future<AuthUser> refreshUser(
    AuthUser user,
  );

  Future<bool> hasCompletedOnboarding();
  Future<void> setOnboardingComplete();

  Future<AuthUser> signInWithGoogle();
  Future<AuthUser> signInWithFacebook();
}
