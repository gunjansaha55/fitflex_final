import 'package:fitness/services/db_services/models/app_model.dart';
import 'package:fitness/services/db_services/models/model_constant.dart';

class UserModel implements AppModel {
  final String uid;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? height;
  final String? weight;
  final String? age;
  final String? gender;
  final String? allergyCondition;
  final String? medicalCondition;
  final String? dietaryPreference;
  final String? currentInjuryCondition;
  final String? bodyShape;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.gender,
    this.photoUrl,
    this.height,
    this.weight,
    this.age,
    this.allergyCondition,
    this.medicalCondition,
    this.dietaryPreference,
    this.currentInjuryCondition,
    this.bodyShape,
  });

  UserModel.newUser({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    this.gender,
    this.height,
    this.weight,
    this.age,
    this.allergyCondition,
    this.medicalCondition,
    this.dietaryPreference,
    this.currentInjuryCondition,
    this.bodyShape,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? photoUrl,
    String? height,
    String? weight,
    String? age,
    String? gender,
    String? allergyCondition,
    String? medicalCondition,
    String? dietaryPreference,
    String? currentInjuryCondition,
    String? bodyShape,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      allergyCondition: allergyCondition ?? this.allergyCondition,
      medicalCondition: medicalCondition ?? this.medicalCondition,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      currentInjuryCondition:
          currentInjuryCondition ?? this.currentInjuryCondition,
      bodyShape: bodyShape ?? this.bodyShape,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ModelConstant.uid: uid,
      ModelConstant.gender: gender,
      ModelConstant.email: email,
      ModelConstant.name: name,
      ModelConstant.photoUrl: photoUrl,
      ModelConstant.height: height,
      ModelConstant.weight: weight,
      ModelConstant.age: age,
      ModelConstant.allergyCondition: allergyCondition,
      ModelConstant.medicalCondition: medicalCondition,
      ModelConstant.dietaryPreference: dietaryPreference,
      ModelConstant.currentInjuryCondition: currentInjuryCondition,
      ModelConstant.bodyShape: bodyShape,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map[ModelConstant.uid],
      gender: map[ModelConstant.gender],
      email: map[ModelConstant.email],
      name: map[ModelConstant.name],
      photoUrl: map[ModelConstant.photoUrl],
      height: map[ModelConstant.height],
      weight: map[ModelConstant.weight],
      age: map[ModelConstant.age],
      allergyCondition: map[ModelConstant.allergyCondition],
      medicalCondition: map[ModelConstant.medicalCondition],
      dietaryPreference: map[ModelConstant.dietaryPreference],
      currentInjuryCondition: map[ModelConstant.currentInjuryCondition],
      bodyShape: map[ModelConstant.bodyShape],
    );
  }
}
