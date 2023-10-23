import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/providers/plan_provider.dart';
import 'package:http/http.dart' as http;
import 'package:meal_planner/screens/add_food.dart';

class WeekDayWidget extends ConsumerWidget {
  WeekDayWidget({super.key, required this.day});

  final WeekDay day;
  static const planId = "-NhNoO5bOJwpboPYAyW3";
  final url = Uri.https('flutter-prep-37902-default-rtdb.firebaseio.com',
      'meal-plan/$planId.json');

  void _clearDay(WidgetRef ref) async {
    final response =
        await http.patch(url, body: json.encode({day.toString(): null}));
    if (response.statusCode >= 400) {
      return;
    }
    ref.read(mealPlanProvider.notifier).removeMeal(day);
  }

  void _addFood(BuildContext context, Food? meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddFoodScreen(day: day, meal: meal),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealPlan = ref.watch(mealPlanProvider);
    String content;
    if (mealPlan[day] == null) {
      content = "Click to add a meal...";
    } else {
      content = mealPlan[day]!.title;
    }

    return InkWell(
      onTap: () => _addFood(context, mealPlan[day]),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 72,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      day.toString(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.2),
                          ),
                    ),
                    const Spacer(),
                    mealPlan[day] == null
                        ? const Spacer()
                        : InkWell(
                            onTap: () => _clearDay(ref),
                            child: Icon(Icons.delete,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.2)),
                          ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    content,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.8),
                        ),
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
