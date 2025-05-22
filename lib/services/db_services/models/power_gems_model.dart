import 'package:fitness/services/db_services/models/app_model.dart';
import 'package:fitness/services/db_services/models/model_constant.dart';

class PowerGemsModel implements AppModel {
  final String uid;
  final int totalGems;
  final int currentStreak;
  final DateTime lastLoginDate;
  final List<DateTime> loginDates;

  PowerGemsModel({
    required this.uid,
    required this.totalGems,
    required this.currentStreak,
    required this.lastLoginDate,
    required this.loginDates,
  });

  factory PowerGemsModel.newUser(String uid) {
    return PowerGemsModel(
      uid: uid,
      totalGems: 0,
      currentStreak: 0,
      lastLoginDate: DateTime.now(),
      loginDates: [],
    );
  }

  factory PowerGemsModel.fromMap(Map<String, dynamic> map) {
    return PowerGemsModel(
      uid: map[ModelConstant.uid] as String,
      totalGems: map[ModelConstant.totalGems] as int,
      currentStreak: map[ModelConstant.currentStreak] as int,
      lastLoginDate: DateTime.fromMillisecondsSinceEpoch(
          map[ModelConstant.lastLoginDate] as int),
      loginDates: (map[ModelConstant.loginDates] as List<dynamic>)
          .map((date) => DateTime.fromMillisecondsSinceEpoch(date as int))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ModelConstant.uid: uid,
      ModelConstant.totalGems: totalGems,
      ModelConstant.currentStreak: currentStreak,
      ModelConstant.lastLoginDate: lastLoginDate.millisecondsSinceEpoch,
      ModelConstant.loginDates:
          loginDates.map((date) => date.millisecondsSinceEpoch).toList(),
    };
  }

  // Check if user can collect daily gem
  bool canCollectDailyGem() {
    final now = DateTime.now();
    final durationSinceLastLogin = now.difference(lastLoginDate);
    return durationSinceLastLogin.inHours >= 24;
  }

  // Create a copy with updated values
  PowerGemsModel copyWith({
    String? uid,
    int? totalGems,
    int? currentStreak,
    DateTime? lastLoginDate,
    List<DateTime>? loginDates,
  }) {
    return PowerGemsModel(
      uid: uid ?? this.uid,
      totalGems: totalGems ?? this.totalGems,
      currentStreak: currentStreak ?? this.currentStreak,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      loginDates: loginDates ?? this.loginDates,
    );
  }

  // Add daily login gem and update streak
  PowerGemsModel addDailyLogin() {
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    // Check if this is a consecutive day login
    bool isConsecutive = lastLoginDate.year == yesterday.year &&
        lastLoginDate.month == yesterday.month &&
        lastLoginDate.day == yesterday.day;

    // Calculate new streak
    int newStreak = isConsecutive ? currentStreak + 1 : 1;

    // Calculate gems to add (1 for daily + 1 extra for 7-day streak)
    int gemsToAdd = 1;
    if (newStreak % 7 == 0) {
      gemsToAdd += 1; // Bonus gem for 7-day streak
    }

    return copyWith(
      totalGems: totalGems + gemsToAdd,
      currentStreak: newStreak,
      lastLoginDate: now,
      loginDates: [...loginDates, now],
    );
  }
}
