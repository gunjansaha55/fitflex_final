import 'package:fitness/services/db_services/models/power_gems_model.dart';
import 'package:fitness/services/db_services/models/user_model.dart';

abstract class DBModel {
  Future<void> init();

  Future<UserModel> createUser(UserModel user);

  Future<UserModel?> getUser(String uid);

  Future<void> deleteUser(String uid);

  Future<UserModel> updateUser(UserModel user);

  Future<PowerGemsModel> createPowerGems(PowerGemsModel model);

  Future<PowerGemsModel?> getPowerGems(String uid);

  Future<PowerGemsModel> updatePowerGems(PowerGemsModel model);
}
