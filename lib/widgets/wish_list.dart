import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/providers/wish_provider.dart';

class WishList extends ConsumerWidget {
  const WishList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    ref.read(wishProvider.notifier).removeWish(wishes[index]);
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
