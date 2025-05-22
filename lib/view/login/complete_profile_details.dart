import 'package:fitness/common_widget/round_textfield.dart';
import 'package:fitness/services/auth/auth_exceptions.dart';
import 'package:fitness/services/auth/auth_user.dart';
import 'package:fitness/services/bloc/auth_bloc.dart';
import 'package:fitness/services/bloc/auth_event.dart';
import 'package:fitness/services/bloc/auth_state.dart';
import 'package:fitness/services/db_services/db_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteProfileDetailsScreen extends StatefulWidget {
  final DBModel dbModel;
  final AuthUser authUser;
  const CompleteProfileDetailsScreen({
    super.key,
    required this.dbModel,
    required this.authUser,
  });

  @override
  State<CompleteProfileDetailsScreen> createState() =>
      _CompleteProfileDetailsScreenState();
}

class _CompleteProfileDetailsScreenState
    extends State<CompleteProfileDetailsScreen> {
  late final TextEditingController _heightController;
  late final TextEditingController _genderController;
  late final TextEditingController _weightController;
  late final TextEditingController _ageController;
  late final TextEditingController _allergyConditionController;
  late final TextEditingController _medicalConditionController;
  late final TextEditingController _dietaryPreferenceController;
  late final TextEditingController _currentInjuryConditionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _heightController = TextEditingController();
    _genderController = TextEditingController();
    _weightController = TextEditingController();
    _ageController = TextEditingController();
    _allergyConditionController = TextEditingController();
    _medicalConditionController = TextEditingController();
    _dietaryPreferenceController = TextEditingController();
    _currentInjuryConditionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _allergyConditionController.dispose();
    _medicalConditionController.dispose();
    _dietaryPreferenceController.dispose();
    _currentInjuryConditionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateHasDoneProfileCompletion) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred'),
            ),
          );
        } else if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User not found'),
              ),
            );
          } else if (state.exception is GenericAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('An error occurred'),
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    SizedBox(
                      height: 220,
                      child: Image.asset(
                          'assets/img/complete_profile_onboarding.png',
                          fit: BoxFit.contain),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Let’s complete your profile",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "It will help us to know more about you!",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 25),

                    RoundTextField(
                      hitText: "Enter your age",
                      keyboardType: TextInputType.number,
                      controller: _ageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    RoundTextField(
                      hitText: "Enter your height (cm)",
                      keyboardType: TextInputType.number,
                      controller: _heightController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your height';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    RoundTextField(
                      hitText: "Enter your weight (kg)",
                      keyboardType: TextInputType.number,
                      controller: _weightController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your weight';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildGenderDropdown(),
                    const SizedBox(height: 10),
                    RoundTextField(
                      hitText: "Enter your allergy condition",
                      keyboardType: TextInputType.text,
                      controller: _allergyConditionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter proper allergy condition';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    RoundTextField(
                      hitText: "Enter any of your medical condition",
                      keyboardType: TextInputType.text,
                      controller: _medicalConditionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your medical condition';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    _buildDropdown("Dietary Preference"),

                    const SizedBox(height: 10),
                    RoundTextField(
                      hitText: "Enter any of your current injury condition",
                      keyboardType: TextInputType.text,
                      controller: _currentInjuryConditionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current injury condition';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    // Next Button
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00F260), Color(0xFFFFDD00)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(AuthEventDoProfileCompletion(
                                age: _ageController.text,
                                height: _heightController.text,
                                weight: _weightController.text,
                                allergyCondition:
                                    _allergyConditionController.text,
                                medicalCondition:
                                    _medicalConditionController.text,
                                dietaryPreference:
                                    _dietaryPreferenceController.text,
                                currentInjuryCondition:
                                    _currentInjuryConditionController.text,
                                gender: _genderController.text,
                              ));
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30), // Increased bottom padding
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: "Select your gender",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        items: const [
          'Male',
          'Female',
          'Other',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              _genderController.text = value;
            });
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select your gender';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        items: const [
          'Vegetarian',
          'Vegan',
          'Non Vegetarian',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              _dietaryPreferenceController.text = value;
            });
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select your dietary preference';
          }
          return null;
        },
      ),
    );
  }
}
