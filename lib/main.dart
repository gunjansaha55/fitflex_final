import 'package:fitness/services/auth/firebase_auth_provider.dart';
import 'package:fitness/services/bloc/auth_bloc.dart';
import 'package:fitness/services/bloc/auth_event.dart';
import 'package:fitness/services/bloc/auth_state.dart';
import 'package:fitness/loading_screen.dart';
import 'package:fitness/services/db_services/firestore_db.dart';
import 'package:fitness/view/login/body_shape_selection_female_screen.dart';
import 'package:fitness/view/login/body_shape_selection_male_screen.dart';
import 'package:fitness/view/login/complete_profile_details.dart';
import 'package:fitness/view/login/forgot_password_view.dart';
import 'package:fitness/view/login/login_view.dart';
import 'package:fitness/view/login/signup_view.dart';
import 'package:fitness/view/login/verify_email_view.dart';
import 'package:fitness/view/main_tab/main_tab_view.dart';
import 'package:fitness/view/on_boarding/on_boarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/colo_extension.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness 3 in 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          displayLarge: TextStyle(color: Colors.black),
          displayMedium: TextStyle(color: Colors.black),
          displaySmall: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          titleSmall: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          labelLarge: TextStyle(color: Colors.black),
          labelSmall: TextStyle(color: Colors.black),
        ),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
      ),
      // home: const MainTabView(),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          FirebaseAuthProvider(),
          FirestoreDB(),
        ),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
          context: context,
          text: state.loadingText ?? 'Please wait a moment',
        );
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthStateOnboarding) {
        return const OnBoardingView();
      } else if (state is AuthStateOnboardingComplete) {
        return const LoginView();
      } else if (state is AuthStateLoggedIn) {
        var dbModel = state.dbModel;
        var authUser = state.user;
        return MainTabView(
          dbModel: dbModel,
          authUser: authUser,
        );
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateForgotPassword) {
        return const ForgotPasswordView();
      } else if (state is AuthStateRegistering) {
        return const SignUpView();
      } else if (state is AuthStateProfileCompletion) {
        return CompleteProfileDetailsScreen(
          dbModel: state.dbModel,
          authUser: state.user,
        );
      } else if (state is AuthStateSelectBodyShape) {
        if (state.gender.toLowerCase() == 'male') {
          return const BodyShapeSelectionMaleScreen();
        } else {
          return const BodyShapeSelectionFemaleScreen();
        }
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
