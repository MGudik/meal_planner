import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/utilities/http.dart' as http;

class WishNotifier extends StateNotifier<List<Wish>> {
  WishNotifier() : super([]);

  final url = Uri.https(
      'flutter-prep-37902-default-rtdb.firebaseio.com', 'wish-list.json');

  void makeWish(Wish wish) async {
    state = [wish, ...state];
  }

  void removeWish(Wish wish) {
    state = state.where((element) => element.id != wish.id).toList();
  }

  void getWishList() async {
    state = await http.getAllWishes();
  }
}

final wishProvider =
    StateNotifierProvider<WishNotifier, List<Wish>>((ref) => WishNotifier());
