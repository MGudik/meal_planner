import 'package:flutter/material.dart';
import 'package:meal_planner/screens/meal_plan.dart';
import 'package:meal_planner/screens/shopping_screen.dart';
import 'package:meal_planner/screens/todo_screen.dart';
import 'package:meal_planner/screens/user_screen.dart';
import 'package:meal_planner/screens/wish_screen.dart';
import 'package:meal_planner/widgets/navigation_bar.dart';
import 'package:meal_planner/widgets/settings_drawer.dart';

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
      } else if (screenIndex == 1) {
        content = WishScreen();
      } else if (screenIndex == 2) {
        content = TodoScreen();
      } else if (screenIndex == 3) {
        content = ShoppingScreen();
      } else if (screenIndex == 4) {
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
      drawer: SettingsDrawer(),
      body: content,
    );
  }
}
