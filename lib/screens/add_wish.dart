import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/providers/wish_provider.dart';
import 'package:meal_planner/widgets/wish_list.dart';

class AddWishScreen extends ConsumerWidget {
  AddWishScreen({super.key});

  final _titleController = TextEditingController();

  void _makeWish(BuildContext context, WidgetRef ref) {
    String enteredTitle = _titleController.text.trim();

    if (enteredTitle.length > 1) {
      ref.read(wishProvider.notifier).makeWish(Food(title: enteredTitle));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wish a Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Meal Title"),
              controller: _titleController,
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton.icon(
              onPressed: () => _makeWish(context, ref),
              icon: const Icon(Icons.star),
              label: const Text('Make a Wish!'),
            ),
            const SizedBox(
              height: 16,
            ),
            const Expanded(child: WishList()),
          ]),
        ),
      ),
    );
  }
}
