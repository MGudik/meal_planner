import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';

String baseUrl = "flutter-prep-37902-default-rtdb.firebaseio.com";
String planID = "-NhNoO5bOJwpboPYAyW3";

Future<bool> updateDay(String? title, WeekDay day) async {
  final url = Uri.https(baseUrl, 'meal-plan/$planID.json');

  final response =
      await http.patch(url, body: json.encode({day.toString(): title}));
  if (response.statusCode >= 400) {
    return false;
  }
  return true;
}

Future<bool> removeDay(WeekDay day) async {
  return updateDay(null, day);
}

Future<Map<WeekDay, Food?>?> getMealPlan() async {
  final url = Uri.https(baseUrl, 'meal-plan/$planID.json');

  final response = await http.get(url);
  if (response.statusCode >= 400) {
    return null;
  }
  Map<String, dynamic> data = json.decode(response.body);
  Map<WeekDay, Food?> newState = {};
  for (final entry in data.entries) {
    WeekDay day = WeekDay.values.firstWhere((e) => e.toString() == entry.key);
    newState[day] = Food(title: entry.value);
  }
  return newState;
}

Future<String?> addWish(String title) async {
  final url = Uri.https(baseUrl, 'wish-list.json');
  final response = await http.post(url, body: json.encode({"title": title}));

  if (response.statusCode >= 400) {
    return null;
  }
  return json.decode(response.body)["name"];
}

Future<bool> removeWish(Wish wish) async {
  final url = Uri.https(baseUrl, 'wish-list/${wish.id}.json');
  final response = await http.delete(url);

  if (response.statusCode >= 400) {
    return false;
  }
  return true;
}

Future<List<Wish>> getAllWishes() async {
  final url = Uri.https(baseUrl, 'wish-list.json');

  final response = await http.get(url);
  if (response.statusCode >= 400) {
    return [];
  }
  List<Wish> newState = [];
  Map<String, dynamic> data = json.decode(response.body);
  for (final entry in data.entries) {
    final title = entry.value["title"];
    final id = entry.key;
    final wish = Wish(id: id, title: title, wishedBy: "Gudiksen");
    newState.add(wish);
  }
  return newState;
}
