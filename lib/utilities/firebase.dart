import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';

Future<String> createEmptyMealPlan() async {
  final response =
      await FirebaseFirestore.instance.collection('mealplans').add({
    'monday': null,
    'tuesday': null,
    'wednesday': null,
    'thursday': null,
    'friday': null,
    'saturday': null,
    'sunday': null,
    'wishes': [],
  });

  return response.id;
}

void updateDay(WeekDay day, String? meal) async {
  final mealPlanId = await getMealPlanId();
  FirebaseFirestore.instance
      .collection('mealplans')
      .doc(mealPlanId)
      .update({day.toString(): meal == null ? null : meal});
}

void clearDay(WeekDay day) async {
  updateDay(day, null);
}

Future<String?> addWish(String wish) async {
  final mealPlanId = await getMealPlanId();
  final document = await FirebaseFirestore.instance
      .collection('mealplans')
      .doc(mealPlanId)
      .get();
  final currentWishes = document.get('wishes') as List;
  currentWishes.add(wish);

  FirebaseFirestore.instance
      .collection('mealplans')
      .doc(mealPlanId)
      .update({'wishes': currentWishes});
}

void removeWish(Wish wish) {}

Future<String> getMealPlanId() async {
  final authenticatedUser = FirebaseAuth.instance.currentUser!;
  final userStore = await FirebaseFirestore.instance
      .collection('users')
      .doc(authenticatedUser.uid)
      .get();
  final mealPlanId = userStore.get('mealId');
  return mealPlanId;
}

Future<List<Wish>> getWishList() async {
  final mealPlanId = await getMealPlanId();
  final document = await FirebaseFirestore.instance
      .collection('mealplans')
      .doc(mealPlanId)
      .get();
  final currentWishes = document.get('wishes') as List;
  
  return currentWishes.asMap().entries.map((entry) {
    int idx = entry.key;
    String val = entry.value;
    return Wish(id: idx.toString(), title: val, wishedBy: "Gudiksen");
  }).toList();
}
