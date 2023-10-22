import 'package:flutter/material.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/providers/plan_provider.dart';
import 'package:meal_planner/widgets/wish_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFoodScreen extends ConsumerWidget {
  AddFoodScreen({super.key, required this.day, required this.meal});

  final WeekDay day;
  final Food? meal;
  final titleController = TextEditingController();

  void _addMeal(BuildContext context, WidgetRef ref) {
    String enteredTitle = titleController.text.trim();
    final meal = Food(title: enteredTitle);
    ref.read(mealPlanProvider.notifier).setMeal(meal, day);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal for ${day.toString()}'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Meal Title"),
              controller: titleController,
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton.icon(
              onPressed: () => _addMeal(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Meal!'),
            ),
            const SizedBox(
              height: 16,
            ),
            const Expanded(child: WishList()),
          ]),
        ),
      ),
    );
  }
}
