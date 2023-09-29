import 'package:foodplan/models/food.dart';
import "package:string_extension/string_extension.dart";

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
  Week();

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
