import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/providers/plan_provider.dart';
import 'package:meal_planner/providers/wish_provider.dart';
import 'package:meal_planner/screens/add_wish.dart';
import 'package:meal_planner/widgets/week_day.dart';
import 'package:riverpod/riverpod.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(mealPlanProvider.notifier).getMealPlan();
    ref.read(wishProvider.notifier).getWishList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weekly Meal Plan",
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.small(
          child: const Icon(Icons.star),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddWishScreen(),
            ));
          }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (final (index, day) in WeekDay.values.indexed)
              WeekDayWidget(key: ValueKey(index), day: day)
          ],
        ),
      ),
    );
  }
}
