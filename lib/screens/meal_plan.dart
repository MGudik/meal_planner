import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/models/week.dart';
import 'package:meal_planner/screens/user_screen.dart';
import 'package:meal_planner/widgets/week_day.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  void _openUserTab(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => UserScreen(
              onSignOut: () {
                _signOutUser(context);
              },
            )));
  }

  void _signOutUser(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(
          title: true
              ? Text(
                  "Weekly Meal Plan",
                  style: GoogleFonts.dancingScript(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                )
              : Row(
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
          child: const Icon(Icons.account_circle),
          onPressed: () {
            _openUserTab(context);
          },
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
                              day: day)
                      ],
                    ),
                  );
                });
          },
        ));
  }
}
