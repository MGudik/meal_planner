import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/providers/user_provider.dart';

class NewUserScreen extends ConsumerWidget {
  const NewUserScreen({super.key, required this.onAdd});

  final void Function(String) onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String _enteredName = "";
    ref.read(userProvider.notifier).loadUser();

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text("First name")),
                initialValue: _enteredName,
                onChanged: (value) {
                  _enteredName = value.trim();
                },
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    onAdd(_enteredName);
                  },
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
