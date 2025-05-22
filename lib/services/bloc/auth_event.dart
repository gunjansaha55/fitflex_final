// This will contain the events that will be used to trigger the state changes in the AuthBloc.

import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

// For login we will need email and password.
class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogin(this.email, this.password);
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  final String name;
  const AuthEventRegister(
    this.email,
    this.password,
    this.name,
  );
}

class AuthEventDoProfileCompletion extends AuthEvent {
  final String? height;
  final String? weight;
  final String? gender;
  final String? age;
  final String? allergyCondition;
  final String? medicalCondition;
  final String? dietaryPreference;
  final String? currentInjuryCondition;

  const AuthEventDoProfileCompletion({
    this.height,
    this.weight,
    this.gender,
    this.age,
    this.allergyCondition,
    this.medicalCondition,
    this.dietaryPreference,
    this.currentInjuryCondition,
  });
}

class AuthEventSelectBodyShape extends AuthEvent {
  final String? bodyShape;
  const AuthEventSelectBodyShape({this.bodyShape});
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}

class AuthEventStartOnboarding extends AuthEvent {
  const AuthEventStartOnboarding();
}

class AuthEventCompleteOnboarding extends AuthEvent {
  const AuthEventCompleteOnboarding();
}

class AuthEventSignInWithGoogle extends AuthEvent {
  const AuthEventSignInWithGoogle();
}
