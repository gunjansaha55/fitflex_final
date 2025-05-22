import 'package:fitness/services/auth/firebase_auth_provider.dart';
import 'package:fitness/services/auth/auth_provider.dart';
import 'package:fitness/services/auth/auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);

  factory AuthService.firebase() => AuthService(
        FirebaseAuthProvider(),
      );

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get getCurrentUser => provider.getCurrentUser;

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);

  @override
  AuthUser? get user => provider.user;

  @override
  Future<AuthUser> refreshUser(
    AuthUser user,
  ) =>
      provider.refreshUser(
        user,
      );

  @override
  Future<bool> hasCompletedOnboarding() => provider.hasCompletedOnboarding();

  @override
  Future<void> setOnboardingComplete() => provider.setOnboardingComplete();

  @override
  Future<AuthUser> signInWithGoogle() => provider.signInWithGoogle();

  @override
  Future<AuthUser> signInWithFacebook() async {
    return provider.signInWithFacebook();
  }
}
