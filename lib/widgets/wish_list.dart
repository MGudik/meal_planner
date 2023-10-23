import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/providers/wish_provider.dart';
import 'package:http/http.dart' as http;

class WishList extends ConsumerWidget {
  const WishList({super.key, required this.onTap});

  final void Function(Food meal) onTap;

  void _removeWish(Food meal, WidgetRef ref) async {
    final url = Uri.https('flutter-prep-37902-default-rtdb.firebaseio.com',
        'wish-list/${meal.id}.json');

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      return;
    }
    ref.read(wishProvider.notifier).removeWish(meal);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(wishProvider.notifier).getWishList();
    final wishes = ref.watch(wishProvider);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
          color:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1)),
      child: Column(
        children: [
          Text(
            "Wish List",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: wishes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    onTap(wishes[index]);
                    _removeWish(wishes[index], ref);
                  },
                  title: Text(wishes[index].title),
                  leading: const Icon(Icons.star),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
