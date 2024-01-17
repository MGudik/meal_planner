import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/screens/add_food.dart';
import 'package:meal_planner/utilities/firebase.dart' as firebase;
import 'package:meal_planner/utilities/strings.dart';

class WeekDayWidget extends ConsumerWidget {
  const WeekDayWidget(
      {super.key,
      required this.meal,
      required this.day,
      required this.isCurrentDay});

  final Food? meal;
  final WeekDay day;
  final bool isCurrentDay;

  void _clearDay() async {
    firebase.clearDay(day);
  }

  void _addFood(BuildContext context, Food? meal, WidgetRef ref) async {
    Navigator.of(context).push(MaterialPageRoute<String>(
      builder: (context) => AddFoodScreen(day: day, meal: meal),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height - (20 * 7) - (16 * 7);
    String content;
    if (meal == null) {
      content = "Click to add a meal...";
    } else {
      content = meal!.title;
    }

    return InkWell(
      onTap: () => _addFood(context, meal, ref),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: isCurrentDay
            ? Colors.blue.withOpacity(0.1)
            : null, // Highlight color
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: height / 8,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      day.toString().toCapitalized(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    meal == null
                        ? const Spacer()
                        : InkWell(
                            onTap: () => _clearDay(),
                            child: Icon(Icons.delete,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.2)),
                          ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: Text(
                      content,
                      softWrap: true,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: meal == null ? 9 : 15,
                          ),
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
