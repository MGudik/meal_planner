import 'package:meal_planner/models/food.dart';
import "package:string_extension/string_extension.dart";
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  @override
  String toString() => name.capitalize();
}

class Week {
  Week() : id = uuid.v4();

  final String id;
  Map<WeekDay, Food?> plan = {};

  Week addFood(Food food, WeekDay day) {
    plan[day] = food;
    return this;
  }

  Food? fromDay(WeekDay day) {
    return plan[day];
  }

  Week removeFood(WeekDay day) {
    plan[day] = null;
    return this;
  }
}
