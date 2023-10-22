import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/providers/plan_provider.dart';
import 'package:meal_planner/providers/wish_provider.dart';
import 'package:meal_planner/screens/add_food.dart';

class WeekDayWidget extends ConsumerWidget {
  const WeekDayWidget({super.key, required this.day});

  final WeekDay day;

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
      content = "No Meal is planned for that day";
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
                    )
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
