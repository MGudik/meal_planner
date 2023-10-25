import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/providers/wish_provider.dart';
import 'package:meal_planner/screens/add_wish.dart';
import 'package:meal_planner/utilities/http.dart' as http;

class WishList extends ConsumerWidget {
  const WishList({super.key, required this.onTap});

  final void Function(Wish wish) onTap;

  void _removeWish(Wish wish, WidgetRef ref) async {
    http.removeWish(wish);
    ref.read(wishProvider.notifier).removeWish(wish);
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
          Row(
            children: [
              const Spacer(),
              Text(
                "Wish List",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddWishScreen()));
                },
                child: Icon(
                  Icons.add_box_rounded,
                  size: 32,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.5),
                ),
              )
            ],
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
                  title: Column(children: [Text(wishes[index].title), Text("Wished by " + wishes[index].wishedBy, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: const Color.fromRGBO(255, 255, 255, 0.2)),) ]),
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
