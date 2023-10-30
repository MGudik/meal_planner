import 'package:flutter/material.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/providers/plan_provider.dart';
import 'package:meal_planner/widgets/wish_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/utilities/http.dart' as http;

class AddFoodScreen extends ConsumerWidget {
  AddFoodScreen({super.key, required this.day, required this.meal});

  final WeekDay day;
  final Food? meal;
  final titleController = TextEditingController();

  void _selectWish(Wish wish, BuildContext context, WidgetRef ref) {
    titleController.text = wish.title;
    _addMeal(context, ref);
    Navigator.pop(context);
  }

  Future<bool> _addMeal(BuildContext context, WidgetRef ref) async {
    String enteredTitle = titleController.text.trim();

    if (enteredTitle.length <= 1) {
      http.removeDay(day);
      ref.read(mealPlanProvider.notifier).removeMeal(day);
      return true;
    }

    http.updateDay(enteredTitle, day);
    final meal = Food(title: enteredTitle);
    ref.read(mealPlanProvider.notifier).setMeal(meal, day);
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    titleController.text = meal == null ? "" : meal!.title;
    return WillPopScope(
      onWillPop: () async {
        return _addMeal(context, ref);
      },
      child: Scaffold(
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
              Expanded(child: WishList(
                onTap: (Wish wish) {
                  _selectWish(wish, context, ref);
                },
              )),
            ]),
          ),
        ),
      ),
    );
  }
}
