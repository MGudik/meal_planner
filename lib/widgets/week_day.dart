import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/providers/plan_provider.dart';
import 'package:meal_planner/utilities/http.dart' as http;
import 'package:meal_planner/screens/add_food.dart';

class WeekDayWidget extends ConsumerWidget {
  const WeekDayWidget({super.key, required this.day});

  final WeekDay day;

  void _clearDay(WidgetRef ref) async {
    http.removeDay(day);
    ref.read(mealPlanProvider.notifier).removeMeal(day);
  }

  void _addFood(BuildContext context, Food? meal, WidgetRef ref) async {
    final title = await Navigator.of(context).push(MaterialPageRoute<String>(
      builder: (context) => AddFoodScreen(day: day, meal: meal),
    ));
    if (title == null) {
      return;
    }
    String enteredTitle = title.trim();

    if (enteredTitle.length <= 1) {
      return;
    }

    http.updateDay(enteredTitle, day);
    final newMeal = Food(title: enteredTitle);
    ref.read(mealPlanProvider.notifier).setMeal(newMeal, day);
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
      onTap: () => _addFood(context, mealPlan[day], ref),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
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
                                .withOpacity(0.5),
                            fontWeight: FontWeight.bold,
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
                  Expanded(
                    child: Text(
                      content,
                      softWrap: true,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: mealPlan[day] == null ? 9 : 15,
                          ),
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
