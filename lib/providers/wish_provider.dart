import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:http/http.dart' as http;

class WishNotifier extends StateNotifier<List<Food>> {
  WishNotifier() : super([]);

  final url = Uri.https(
      'flutter-prep-37902-default-rtdb.firebaseio.com', 'wish-list.json');

  void makeWish(Food meal) async {
    state = [meal, ...state];
  }

  void removeWish(Food meal) {
    state = state.where((element) => element.id != meal.id).toList();
  }

  void getWishList() async {
    final url = Uri.https(
        'flutter-prep-37902-default-rtdb.firebaseio.com', 'wish-list.json');

    final response = await http.get(url);
    if (response.statusCode >= 400) {
      return;
    }
    List<Food> newState = [];
    Map<String, dynamic> data = json.decode(response.body);
    for (final entry in data.entries) {
      final title = entry.value["title"];
      final id = entry.key;
      final meal = Food.withID(id: id, title: title);
      newState.add(meal);
    }
    state = newState;
  }
}

final wishProvider =
    StateNotifierProvider<WishNotifier, List<Food>>((ref) => WishNotifier());
