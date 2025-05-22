import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/tab_button.dart';
import 'package:fitness/services/auth/auth_user.dart';
import 'package:fitness/services/db_services/db_model.dart';
import 'package:fitness/services/db_services/models/power_gems_model.dart';
import 'package:fitness/view/main_tab/select_view.dart';
import 'package:flutter/material.dart';

import '../home/home_view.dart';
import '../photo_progress/photo_progress_view.dart';
import '../profile/profile_view.dart';

class MainTabView extends StatefulWidget {
  final AuthUser authUser;
  final DBModel dbModel;
  const MainTabView({
    super.key,
    required this.dbModel,
    required this.authUser,
  });

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  late Widget currentTab;

  @override
  void initState() {
    super.initState();
    currentTab = HomeView(dbModel: widget.dbModel);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleDailyLogin();
    });
  }

  Future<void> _handleDailyLogin() async {
    final userId = widget.authUser.id;
    final powerGemsModel = await widget.dbModel.getPowerGems(userId);

    final today = DateTime.now();

    if (powerGemsModel == null) {
      final powerGemsModel = PowerGemsModel(
        uid: userId,
        totalGems: 1,
        currentStreak: 1,
        lastLoginDate: today,
        loginDates: [today],
      );

      await widget.dbModel.createPowerGems(powerGemsModel);

      // Show gem collection dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPowerGemDialog(1);
      });
      return;
    }

    final lastLogin = powerGemsModel.lastLoginDate;

    // Already collected today
    if (DateUtils.isSameDay(today, lastLogin)) {
      return;
    }

    final yesterday = today.subtract(const Duration(days: 1));
    bool isConsecutive = DateUtils.isSameDay(lastLogin, yesterday);

    int newStreak = isConsecutive ? powerGemsModel.currentStreak + 1 : 1;
    int addedGems = 1;

    if (newStreak == 7) {
      addedGems += 5; // Bonus for 7-day streak
      newStreak = 0; // Reset the streak after reward
    }

    final updatedModel = powerGemsModel.copyWith(
      totalGems: powerGemsModel.totalGems + addedGems,
      currentStreak: newStreak,
      lastLoginDate: today,
      loginDates: [...powerGemsModel.loginDates, today],
    );

    await widget.dbModel.updatePowerGems(updatedModel);

    // Show gem collection dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPowerGemDialog(addedGems);
    });
  }

  void _showPowerGemDialog(int count) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("🎉 Daily Reward"),
          content: Text(
              "You've earned $count PowerGem${count > 1 ? 's' : ''} today!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: PageStorage(bucket: pageBucket, child: currentTab),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: TColor.primaryG,
                ),
                borderRadius: BorderRadius.circular(35),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                  )
                ]),
            child: Icon(
              Icons.search,
              color: TColor.white,
              size: 35,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: TColor.white,
          elevation: 2,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                  icon: "assets/img/home_tab.png",
                  selectIcon: "assets/img/home_tab_select.png",
                  isActive: selectTab == 0,
                  onTap: () {
                    selectTab = 0;
                    currentTab = HomeView(
                      dbModel: widget.dbModel,
                    );
                    if (mounted) {
                      setState(() {});
                    }
                  }),
              TabButton(
                  icon: "assets/img/activity_tab.png",
                  selectIcon: "assets/img/activity_tab_select.png",
                  isActive: selectTab == 1,
                  onTap: () {
                    selectTab = 1;
                    currentTab = const SelectView();
                    if (mounted) {
                      setState(() {});
                    }
                  }),
              const SizedBox(
                width: 40,
              ),
              TabButton(
                  icon: "assets/img/camera_tab.png",
                  selectIcon: "assets/img/camera_tab_select.png",
                  isActive: selectTab == 2,
                  onTap: () {
                    selectTab = 2;
                    currentTab = const PhotoProgressView();
                    if (mounted) {
                      setState(() {});
                    }
                  }),
              TabButton(
                  icon: "assets/img/profile_tab.png",
                  selectIcon: "assets/img/profile_tab_select.png",
                  isActive: selectTab == 3,
                  onTap: () {
                    selectTab = 3;
                    currentTab = ProfileView(
                      dbModel: widget.dbModel,
                    );
                    if (mounted) {
                      setState(() {});
                    }
                  })
            ],
          )),
    );
  }
}
