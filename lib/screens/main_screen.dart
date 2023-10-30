import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/models/user.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/providers/plan_provider.dart';
import 'package:meal_planner/providers/user_provider.dart';
import 'package:meal_planner/providers/wish_provider.dart';
import 'package:meal_planner/screens/add_wish.dart';
import 'package:meal_planner/screens/new_user_screen.dart';
import 'package:meal_planner/widgets/week_day.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  void signupUser(String username, WidgetRef ref) {
    final user = User(name: username);
    ref.read(userProvider.notifier).setUser(user);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(mealPlanProvider.notifier).getMealPlan();
    ref.read(wishProvider.notifier).getWishList();
    final user = ref.watch(userProvider);

    Widget content = Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            Spacer(),
            Text(
              "Weekly Meal Plan",
              style: GoogleFonts.dancingScript(
                color: Colors.white,
                fontSize: 36,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
            )
          ],
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
    if (user.name == null) {
      content = NewUserScreen(
        onAdd: (String username) {
          signupUser(username, ref);
        },
      );
    }

    return content;
  }
}
