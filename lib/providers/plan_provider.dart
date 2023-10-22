import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';

class MealPlanNotifier extends StateNotifier<Map<WeekDay, Food?>> {
  MealPlanNotifier()
      : super({
          WeekDay.monday: null,
          WeekDay.tuesday: null,
          WeekDay.wednesday: null,
          WeekDay.thursday: null,
          WeekDay.friday: null,
          WeekDay.saturday: null,
          WeekDay.sunday: null
        });

  void setMeal(Food meal, WeekDay day) {
    state = {...state, day: meal};
  }

  void removeMeal(WeekDay day) {
    state = state;
  }
}

final mealPlanProvider =
    StateNotifierProvider<MealPlanNotifier, Map<WeekDay, Food?>>(
        (ref) => MealPlanNotifier());
