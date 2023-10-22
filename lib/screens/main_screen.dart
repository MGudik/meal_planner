import 'package:flutter/material.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/screens/add_wish.dart';
import 'package:meal_planner/widgets/week_day.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {

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
              WeekDayWidget(
                  key: ValueKey(index), day: day)
          ],
        ),
      ),
    );
  }
}
