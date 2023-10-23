import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';
import 'package:http/http.dart' as http;

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
    state = {...state, day: null};
  }

  void getMealPlan() async {
    const planId = "-NhNoO5bOJwpboPYAyW3";
    final url = Uri.https('flutter-prep-37902-default-rtdb.firebaseio.com',
        'meal-plan/$planId.json');

    final response = await http.get(url);
    if (response.statusCode >= 400) {
      return;
    }
    Map<String, dynamic> data = json.decode(response.body);
    Map<WeekDay, Food?> newState = {};
    for (final entry in data.entries) {
      WeekDay day = WeekDay.values.firstWhere((e) => e.toString() == entry.key);
      newState[day] = Food(title: entry.value);

      state = newState;
    }
  }
}

final mealPlanProvider =
    StateNotifierProvider<MealPlanNotifier, Map<WeekDay, Food?>>(
        (ref) => MealPlanNotifier());
