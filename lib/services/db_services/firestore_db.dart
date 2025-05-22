import 'package:fitness/services/db_services/db_constant.dart';
import 'package:fitness/services/db_services/db_model.dart';
import 'package:fitness/services/db_services/firestore_db_exception.dart';
import 'package:fitness/services/db_services/models/power_gems_model.dart';
import 'package:fitness/services/db_services/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreDB implements DBModel {
  bool _isInitialized = false;
  late final FirebaseFirestore _db;

  @override
  Future<void> init() async {
    if (_isInitialized) {
      return;
    }
    try {
      _db = FirebaseFirestore.instance;
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize FirestoreDB: $e');
      rethrow;
    }
  }

  CollectionReference get userCollection => _db.collection(DbConstant.users);
  CollectionReference get powerGemsCollection =>
      _db.collection(DbConstant.powerGems);

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      await userCollection.doc(user.uid).set(user.toMap());
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      throw CouldNotCreateUserException();
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
    return user;
  }

  @override
  Future<void> deleteUser(String uid) async {
    try {
      await userCollection.doc(uid).delete();
    } on FirebaseException {
      throw CouldNotDeleteUserException();
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<UserModel?> getUser(String uid) async {
    try {
      var user = await userCollection.doc(uid).get();
      if (user.exists) {
        return UserModel.fromMap(user.data() as Map<String, dynamic>);
      }
      return null;
    } on FirebaseException {
      throw CouldNotGetUserException();
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      await userCollection.doc(user.uid).update(user.toMap());
    } on FirebaseException {
      throw CouldNotUpdateUserException();
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }

    return user;
  }

  @override
  Future<PowerGemsModel> createPowerGems(PowerGemsModel model) async {
    try {
      await powerGemsCollection.doc(model.uid).set(model.toMap());
      return model;
    } on FirebaseException {
      throw GenericDbException("Failed to create PowerGems");
    }
  }

  @override
  Future<PowerGemsModel?> getPowerGems(String uid) async {
    try {
      final doc = await powerGemsCollection.doc(uid).get();
      if (doc.exists) {
        return PowerGemsModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } on FirebaseException {
      throw GenericDbException("Failed to get PowerGems");
    }
  }

  @override
  Future<PowerGemsModel> updatePowerGems(PowerGemsModel model) async {
    try {
      await powerGemsCollection.doc(model.uid).update(model.toMap());
      return model;
    } on FirebaseException {
      throw GenericDbException("Failed to update PowerGems");
    }
  }
}
