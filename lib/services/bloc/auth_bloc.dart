// Here we will have the logic of the AuthBloc i.e. the things that will be done in the background using the auth state and auth event and do all the things here.

import 'package:bloc/bloc.dart';
import 'package:fitness/services/auth/auth_provider.dart';
import 'package:fitness/services/auth/firebase_auth_provider.dart';
import 'package:fitness/services/bloc/auth_event.dart';
import 'package:fitness/services/bloc/auth_state.dart';
import 'package:fitness/services/db_services/db_model.dart';
import 'package:fitness/services/db_services/models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Here we are initializing the AuthBloc with the AuthProvider and the initial state of the bloc is AuthStateLoading.
  AuthBloc(AuthProvider authProvider, DBModel dbProvider)
      : super(const AuthStateUniniatlzied(
          isLoading: true,
        )) {
    // Forgot Password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        isLoading: false,
        exception: null,
        hasSentEmail: false,
      ));
      final email = event.email;
      if (email == null) {
        return; // User just wants to go to the forgot password screen
      }
      // User has entered an email and wants to reset the password
      emit(const AuthStateForgotPassword(
        isLoading: true,
        exception: null,
        hasSentEmail: false,
      ));

      bool didSendEmail;
      Exception? exception;
      // Now send the password reset email
      try {
        await authProvider.sendPasswordReset(
          toEmail: email,
        );
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        exception = e;
        didSendEmail = false;
      }
      // Emit the state with the result of the email sending
      emit(AuthStateForgotPassword(
        isLoading: false,
        exception: exception,
        hasSentEmail: didSendEmail,
      ));
    });

    // Go back to the registration screen
    on<AuthEventShouldRegister>((event, emit) {
      emit(
        const AuthStateRegistering(
          isLoading: false,
          exception: null,
        ),
      );
    });

    // send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await authProvider.sendEmailVerification();
      // For email verification, we are sending an email verification to the user and then emitting the current state as email verification dosen't gives any other state.
      emit(state);
    });

    //auth evenet register

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      final fullName = event.name;
      try {
        final user = await authProvider.createUser(
          email: email,
          password: password,
        );

        final dbUser = UserModel.newUser(
          uid: user.id,
          email: user.email,
          name: fullName,
        );
        await dbProvider.createUser(dbUser);
        await authProvider.sendEmailVerification();

        emit(
          const AuthStateNeedsVerification(isLoading: false),
        );
      } on Exception catch (e) {
        emit(
          AuthStateRegistering(exception: e, isLoading: false),
        );
      }
    });

    // Profile completion
    on<AuthEventDoProfileCompletion>((event, emit) async {
      final height = event.height;
      final weight = event.weight;
      final gender = event.gender;
      final age = event.age;
      final allergyCondition = event.allergyCondition;
      final medicalCondition = event.medicalCondition;
      final dietaryPreference = event.dietaryPreference;
      final currentInjuryCondition = event.currentInjuryCondition;
      final authUser = (authProvider as FirebaseAuthProvider).getCurrentUser;

      try {
        var existingUser = await dbProvider.getUser(authUser!.id);

        if (existingUser != null) {
          existingUser = existingUser.copyWith(
            height: height,
            weight: weight,
            age: age,
            gender: gender,
            allergyCondition: allergyCondition,
            medicalCondition: medicalCondition,
            dietaryPreference: dietaryPreference,
            currentInjuryCondition: currentInjuryCondition,
          );
          await dbProvider.updateUser(existingUser);
        }
        var eventGender = event.gender ?? 'male';
        emit(AuthStateSelectBodyShape(isLoading: false, gender: eventGender));
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(exception: e, isLoading: false),
        );
      }
    });

    // Select body shape
    on<AuthEventSelectBodyShape>((event, emit) async {
      final bodyShape = event.bodyShape;
      final authUser = (authProvider as FirebaseAuthProvider).getCurrentUser;

      try {
        var existingUser = await dbProvider.getUser(authUser!.id);
        if (existingUser != null) {
          existingUser = existingUser.copyWith(
            bodyShape: bodyShape,
          );
          await dbProvider.updateUser(existingUser);
          emit(AuthStateLoggedIn(
            isLoading: false,
            user: authUser,
            dbModel: dbProvider,
          ));
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(exception: e, isLoading: false),
        );
      }
    });

    on<AuthEventInitialize>((event, emit) async {
      await authProvider.initialize();
      await dbProvider.init();
      final authUser = await (authProvider as FirebaseAuthProvider)
          .getCurrentUserWithDetails();
      final hasCompletedOnboarding =
          await authProvider.hasCompletedOnboarding();

      if (!hasCompletedOnboarding) {
        emit(const AuthStateOnboarding(isLoading: false));
      } else if (authUser == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!authUser.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        var dbUser = await dbProvider.getUser(authUser.id);
        if (dbUser == null) {
          dbUser = UserModel.newUser(
            uid: authUser.id,
            email: authUser.email,
            name: "Unknown User",
          );
          await dbProvider.createUser(dbUser);
        }
        emit(
          AuthStateLoggedIn(
            user: authUser,
            isLoading: false,
            dbModel: dbProvider,
          ),
        );
      }
    });

    on<AuthEventLogin>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: 'Please wait while we log you in'),
      );

      await dbProvider.init();
      final email = event.email;
      final password = event.password;
      try {
        final user = await authProvider.login(
          email: email,
          password: password,
        );

        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(
            const AuthStateLoggedOut(exception: null, isLoading: false),
          );
        }
        final dbUser = await dbProvider.getUser(user.id);
        if (dbUser == null) {
          await dbProvider.createUser(UserModel.newUser(
            uid: user.id,
            email: user.email,
            name: "Unknown",
          ));
        }
        if (dbUser?.age == null ||
            dbUser?.weight == null ||
            dbUser?.height == null ||
            dbUser?.allergyCondition == null ||
            dbUser?.medicalCondition == null ||
            dbUser?.dietaryPreference == null ||
            dbUser?.gender == null ||
            dbUser?.currentInjuryCondition == null) {
          emit(AuthStateProfileCompletion(
            isLoading: false,
            user: user,
            dbModel: dbProvider,
            exception: null,
          ));
          return;
        }
        if (dbUser?.bodyShape == null) {
          emit(AuthStateSelectBodyShape(
            gender: dbUser?.gender ?? 'Male',
            isLoading: false,
          ));
          return;
        }
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
          dbModel: dbProvider,
        ));

        emit(AuthStateLoggedIn(
            user: user, isLoading: false, dbModel: dbProvider));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          isLoading: false,
          exception: e,
        ));
      }
    });

    on<AuthEventLogout>((event, emit) async {
      try {
        await authProvider.logout();
        emit(
          const AuthStateLoggedOut(exception: null, isLoading: false),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(exception: e, isLoading: false),
        );
      }
    });

    on<AuthEventStartOnboarding>((event, emit) {
      emit(const AuthStateOnboarding(isLoading: false));
    });

    on<AuthEventCompleteOnboarding>((event, emit) async {
      await authProvider.setOnboardingComplete();
      emit(const AuthStateOnboardingComplete(isLoading: false));
    });

    on<AuthEventSignInWithGoogle>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: 'Please wait while we log you in',
          ),
        );
        try {
          final provider = await authProvider.signInWithGoogle();

          emit(AuthStateLoggedIn(
              user: provider, isLoading: false, dbModel: dbProvider));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(
            isLoading: false,
            exception: e,
          ));
        }
      },
    );
  }
}
