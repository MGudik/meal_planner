import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/providers/wish_provider.dart';
import 'package:meal_planner/utilities/http.dart' as http;

class AddWishScreen extends ConsumerWidget {
  AddWishScreen({super.key});

  final _titleController = TextEditingController();

  void _makeWish(BuildContext context, WidgetRef ref) async {
    String enteredTitle = _titleController.text.trim();

    if (enteredTitle.length <= 1) {
      return;
    }

    final response = await http.addWish(enteredTitle);
    if (response != null) {
      final wish = Wish(id: response, title: enteredTitle);
      ref.read(wishProvider.notifier).makeWish(wish);
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
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
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onBackground,
                foregroundColor: Theme.of(context).colorScheme.background,
              ),
              onPressed: () => _makeWish(context, ref),
              icon: const Icon(Icons.star),
              label: const Text('Make a Wish!'),
            ),
            const SizedBox(
              height: 16,
            )
          ]),
        ),
      ),
    );
  }
}
