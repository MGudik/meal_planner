import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/utilities/firebase.dart' as firebase;
import 'package:meal_planner/utilities/snackbars.dart';

class WishList extends StatelessWidget {
  WishList({super.key, required this.onTap, required this.doDelete});

  final void Function(Wish wish) onTap;
  final bool doDelete;

  void _removeWish(Wish wish) async {
    firebase.removeWish(wish);
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(authenticatedUser.uid)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final mealPlanID = snapshot.data!.get('mealId');
          return Card(
            elevation: 3,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Wish List",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 24,
                        ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Expanded(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('mealplans')
                              .doc(mealPlanID)
                              .snapshots(),
                          builder: (ctx, docSnap) {
                            if (docSnap.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final List<dynamic> wishList =
                                docSnap.data!.get('wishes') as List;
                            final wishes =
                                wishList.asMap().entries.map((entry) {
                              int idx = entry.key;
                              Map<String, dynamic> val = entry.value;
                              return Wish(
                                  id: idx.toString(),
                                  title: val['title'],
                                  wishedBy: val['wishedBy']);
                            }).toList();
                            return ListView.builder(
                              itemCount: wishes.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    wishes[index].title,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                      "Wished by ${wishes[index].wishedBy}"),
                                  leading: Icon(
                                    Icons.star_rounded,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                  trailing: InkWell(
                                    onTap: () {
                                      printSnackBar(
                                          context, "You deletede a wish...");
                                      _removeWish(wishes[index]);
                                    },
                                    child: Icon(Icons.delete),
                                  ),
                                  onTap: () {
                                    onTap(wishes[index]);
                                    if (doDelete) {
                                      _removeWish(wishes[index]);
                                    }
                                  },
                                );
                              },
                            );
                          })),
                ],
              ),
            ),
          );
        });
  }
}
