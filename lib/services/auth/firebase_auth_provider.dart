import 'package:fitness/services/auth/auth_exceptions.dart';
import 'package:fitness/services/auth/auth_provider.dart';
import 'package:fitness/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show
        FirebaseAuth,
        FirebaseAuthException,
        GoogleAuthProvider,
        User,
        UserCredential;
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness/services/auth/shared_preferrence_helper.dart';
import 'package:fitness/firebase_options.dart';
import 'package:fitness/services/db_services/firestore_db.dart';
import 'package:fitness/services/db_services/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser(
      {required String email, required password}) async {
    try {
      final createdUser =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final authUser = _userFromFirebase(createdUser.user);
      if (authUser == null) {
        throw GenericAuthException();
      }
      return authUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  AuthUser? _userFromFirebase(User? user) {
    return user != null
        ? AuthUser(
            email: user.email!,
            isEmailVerified: user.emailVerified,
            id: user.uid,
          )
        : null;
  }

  @override
  AuthUser? get getCurrentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> login(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        return AuthUser.fromFirebase(user);
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<AuthUser?> getCurrentUserWithDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  AuthUser? get user => _userFromFirebase(FirebaseAuth.instance.currentUser);

  @override
  Future<AuthUser> refreshUser(AuthUser user) async {
    final refreshedUser = FirebaseAuth.instance.currentUser;
    if (refreshedUser != null) {
      await refreshedUser.reload();
      var refreshedAuthUser = user.copyWith(
        isEmailVerified: refreshedUser.emailVerified,
      );
      return refreshedAuthUser;
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    const key = 'onboarding_complete';
    return await SharedPreferencesHelper.getBool(key);
  }

  @override
  Future<void> setOnboardingComplete() async {
    const key = 'onboarding_complete';
    await SharedPreferencesHelper.setBool(key, true);
  }

  @override
  Future<AuthUser> signInWithFacebook() {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();
      final googleAccount = await googleSignIn.signIn();
      if (googleAccount == null) {
        throw UserCancelledAuthException();
      }

      final googleAuth = await googleAccount.authentication;

      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(googleCredential);

      final user = userCredential.user;

      if (user != null) {
        final name = user.displayName;
        final image = user.photoURL;
        final dbModel =
            FirestoreDB(); // Assuming FirestoreDB implements DBModel
        await dbModel.init(); // Ensure FirestoreDB is initialized
        await dbModel.createUser(UserModel.newUser(
          uid: user.uid,
          email: user.email!,
          name: name ?? "Unknown",
          photoUrl: image,
        ));
        return AuthUser.fromFirebase(user);
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (_) {
      throw GenericAuthException();
    } catch (e) {
      throw GenericAuthException();
    }
  }
}
