import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/providers/wish_provider.dart';
import 'package:meal_planner/widgets/wish_list.dart';
import 'package:http/http.dart' as http;

class AddWishScreen extends ConsumerWidget {
  AddWishScreen({super.key});

  final _titleController = TextEditingController();

  void _makeWish(BuildContext context, WidgetRef ref) async {
    String enteredTitle = _titleController.text.trim();

    if (enteredTitle.length <= 1) {
      return;
    }

    final url = Uri.https(
        'flutter-prep-37902-default-rtdb.firebaseio.com', 'wish-list.json');
    final response =
        await http.post(url, body: json.encode({"title": enteredTitle}));
    if (response.statusCode >= 400) {
      return;
    }
    final meal = Food.withID(
        id: json.decode(response.body)["name"], title: enteredTitle);
    ref.read(wishProvider.notifier).makeWish(meal);

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
