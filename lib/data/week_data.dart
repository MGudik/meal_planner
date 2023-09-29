import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/models/food.dart';

final meal1 = Food(title: "Pasta og pølser");
final meal2 = Food(title: "Koldskål");
final meal3 = Food(title: "Frikadeller");
final meal4 = Food(title: "Lasange");
final meal5 = Food(title: "Toast");

final testWeek = Week()
    .addFood(meal1, WeekDay.monday)
    .addFood(meal2, WeekDay.tuesday)
    .addFood(meal3, WeekDay.thursday)
    .addFood(meal4, WeekDay.friday)
    .addFood(meal5, WeekDay.sunday);
