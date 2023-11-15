import 'package:flutter/material.dart';
import 'package:meal_planner/screens/add_wish.dart';
import 'package:meal_planner/screens/meal_plan.dart';
import 'package:meal_planner/screens/user_screen.dart';
import 'package:meal_planner/widgets/navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget content = MealPlanScreen();

  void _changeScreen(int screenIndex) {
    setState(() {
      if (screenIndex == 0) {
        content = MealPlanScreen();
      }
      if (screenIndex == 1) {
        content = AddWishScreen();
      }
      if (screenIndex == 2) {
        content = UserScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BotNavBar(
        onChangeScreen: _changeScreen,
      ),
      body: content,
    );
  }
}
