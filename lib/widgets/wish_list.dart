import 'package:flutter/material.dart';
import 'package:meal_planner/models/food.dart';
import 'package:meal_planner/screens/add_wish.dart';
import 'package:meal_planner/utilities/firebase.dart' as firebase;

class WishList extends StatelessWidget {
  WishList({super.key, required this.onTap});

  final void Function(Wish wish) onTap;

  void _removeWish(Wish wish) async {
    firebase.removeWish(wish);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase.getWishList(),
        builder: (ctx, snapshop) {
          if (snapshop.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final wishes = snapshop.data;
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
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        "Wish List",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 24,
                            ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddWishScreen()));
                        },
                        child: Icon(
                          Icons.add_box_rounded,
                          size: 32,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: wishes!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          wishes[index].title,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Icon(
                          Icons.star_rounded,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onTap: () {
                          onTap(wishes[index]);
                          _removeWish(wishes[index]);
                        },
                      );
                    },
                  )),
                ],
              ),
            ),
          );
        });
  }
}
