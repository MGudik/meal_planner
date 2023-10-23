import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/providers/plan_provider.dart';
import 'package:meal_planner/screens/add_wish.dart';
import 'package:meal_planner/widgets/wish_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AddFoodScreen extends ConsumerWidget {
  AddFoodScreen({super.key, required this.day, required this.meal});

  final WeekDay day;
  final Food? meal;
  final titleController = TextEditingController();
  static const planId = "-NhNoO5bOJwpboPYAyW3";
  final url = Uri.https('flutter-prep-37902-default-rtdb.firebaseio.com',
      'meal-plan/$planId.json');

  void _selectWish(Food meal, BuildContext context, WidgetRef ref) {
    titleController.text = meal.title;
    _addMeal(context, ref);
  }

  void _addMeal(BuildContext context, WidgetRef ref) async {
    String enteredTitle = titleController.text.trim();
    if (enteredTitle.length <= 1) {
      return;
    }
    final response = await http.patch(url,
        body: json.encode({day.toString(): enteredTitle}));
    if (response.statusCode >= 400) {
      return;
    }
    final meal = Food(title: enteredTitle);
    ref.read(mealPlanProvider.notifier).setMeal(meal, day);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    titleController.text = meal == null ? "" : meal!.title;
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
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onBackground,
                foregroundColor: Theme.of(context).colorScheme.background,
              ),
              onPressed: () => _addMeal(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Meal!'),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(child: WishList(
              onTap: (Food meal) {
                _selectWish(meal, context, ref);
              },
            )),
          ]),
        ),
      ),
    );
  }
}
