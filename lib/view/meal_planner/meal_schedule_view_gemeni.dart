import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/view/meal_planner/meal_details_screen.dart';
import 'package:flutter/material.dart';

class MealScheduleViewGemeni extends StatefulWidget {
  final Map<String, dynamic> mealData;

  const MealScheduleViewGemeni({super.key, required this.mealData});

  @override
  State<MealScheduleViewGemeni> createState() => _MealScheduleViewGemeniState();
}

class _MealScheduleViewGemeniState extends State<MealScheduleViewGemeni> {
  final CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset("assets/img/black_btn.png", width: 15),
          ),
        ),
        title: Text(
          "Meal Planner",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset("assets/img/more_btn.png", width: 15),
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CalendarAgenda(
            controller: _calendarAgendaControllerAppBar,
            appbar: false,
            selectedDayPosition: SelectedDayPosition.center,
            weekDay: WeekDay.short,
            dayNameFontSize: 12,
            dayNumberFontSize: 16,
            dayBGColor: Colors.grey.withOpacity(0.15),
            titleSpaceBetween: 15,
            backgroundColor: Colors.transparent,
            fullCalendarScroll: FullCalendarScroll.horizontal,
            fullCalendarDay: WeekDay.short,
            selectedDateColor: Colors.white,
            dateColor: Colors.black,
            locale: 'en',
            initialDate: DateTime.now(),
            calendarEventColor: TColor.primaryColor2,
            firstDate: DateTime.now().subtract(const Duration(days: 140)),
            lastDate: DateTime.now().add(const Duration(days: 60)),
            onDateSelected: (date) {},
            selectedDayLogo: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: TColor.primaryG,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Today's Meal",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: TColor.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                mealCard("Breakfast", "breakfast", TColor.customYellow),
                mealCard("Lunch", "lunch", TColor.customGreen),
                mealCard("Afternoon snacks", "snacks", TColor.customYellow),
                mealCard("Dinner", "dinner", TColor.customGreen),
                const SizedBox(height: 20),
                Center(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: TColor.primaryColor1),
                    ),
                    child: Text(
                      "Back to Menu",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: TColor.black,
                          fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mealCard(String title, String mealKey, Color color) {
    final meal = widget.mealData[mealKey];
    final mealName =
        meal is Map ? meal['name']?.toString() : 'No details provided';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: TColor.black)),
          const SizedBox(height: 6),
          Text(
            mealName!,
            style:
                TextStyle(fontSize: 13, color: TColor.black.withOpacity(0.7)),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealDetailScreen(
                    meal: meal,
                    mealType: title,
                  ),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Read More",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
                Icon(Icons.fiber_manual_record, size: 14, color: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
