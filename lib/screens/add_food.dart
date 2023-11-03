import 'package:flutter/material.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/utilities/firebase.dart' as firebase;
import 'package:meal_planner/widgets/wish_list.dart';

class AddFoodScreen extends StatelessWidget {
  AddFoodScreen({super.key, required this.day, required this.meal});

  final WeekDay day;
  final Food? meal;
  final titleController = TextEditingController();

  void _selectWish(Wish wish, BuildContext context) {
    //titleController.text = wish.title;
    //_addMeal(context, ref);
    Navigator.pop(context);
  }

  void _addMeal() {
    String enteredTitle = titleController.text.trim();

    if (enteredTitle.length <= 2) {
      firebase.clearDay(day);
    }

    firebase.updateDay(day, enteredTitle);
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = meal == null ? "" : meal!.title;
    return PopScope(
      onPopInvoked: (didPop) => _addMeal(),
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
                  _selectWish(wish, context);
                },
              )),
            ]),
          ),
        ),
      ),
    );
  }
}
