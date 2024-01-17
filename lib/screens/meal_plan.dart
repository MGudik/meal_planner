import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/widgets/settings_drawer.dart';
import 'package:meal_planner/widgets/week_day.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    DateTime date = DateTime.now();
    final today = date.weekday;
    return Scaffold(
        drawer: SettingsDrawer(),
        appBar: AppBar(
          title: Text(
            "Weekly Meal Plan",
            style: GoogleFonts.dancingScript(
              color: Colors.white,
              fontSize: 36,
            ),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(authenticatedUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final mealPlanID = snapshot.data!.get('mealId');
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('mealplans')
                    .doc(mealPlanID)
                    .snapshots(),
                builder: (ctx, snaps) {
                  if (snaps.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snaps.hasData) {
                    return const Center(
                      child: Text('No mealplan found.'),
                    );
                  }
                  final loadedWeek = snaps.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final (index, day) in WeekDay.values.indexed)
                          WeekDayWidget(
                              key: ValueKey(index),
                              meal: loadedWeek.get(day.toString()) == null
                                  ? null
                                  : Food(title: loadedWeek.get(day.toString())),
                              day: day,
                              isCurrentDay: today == index + 1,)
                      ],
                    ),
                  );
                });
          },
        ));
  }
}
