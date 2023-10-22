import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';

class WishNotifier extends StateNotifier<List<Food>> {
  WishNotifier() : super([]);

  void makeWish(Food meal) {
    state = [meal, ...state];
  }

  void removeWish(Food meal) {
    state = state.where((element) => element.id != meal.id).toList();
  }
}

final wishProvider =
    StateNotifierProvider<WishNotifier, List<Food>>((ref) => WishNotifier());
