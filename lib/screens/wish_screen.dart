import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/utilities/firebase.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:meal_planner/widgets/addItem.dart';

class WishScreen extends StatelessWidget {
  const WishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: StreamBuilder(
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
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
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
                                  key: ValueKey(wishes[index].id),
                                  title: Text(wishes[index].title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  subtitle: Text(
                                      'Wished by: ${wishes[index].wishedBy}',
                                      style: TextStyle(
                                        fontSize: 9.0,
                                      )),
                                  trailing: InkWell(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                    onTap: () =>
                                        firebase.removeWish(wishes[index]),
                                  ),
                                  leading: Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                );
                              },
                            );
                          })),
                  NewItemWidget(
                    onAdd: (String title) => firebase.addWish(title),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
