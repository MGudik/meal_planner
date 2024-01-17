import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_planner/utilities/firebase.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:meal_planner/models/todos.dart';
import 'package:meal_planner/widgets/addItem.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

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
                                docSnap.data!.get('todos') as List;
                            final todos = wishList.asMap().entries.map((entry) {
                              int idx = entry.key;
                              Map<String, dynamic> val = entry.value;
                              final todo = Todo.withID(
                                  id: idx.toString(), title: val['title']);
                              todo.setCompleation(val['compleated']);
                              return todo;
                            }).toList();
                            todos.sort((a, b) => a.compleated ? 1 : -1);
                            return ListView.builder(
                              itemCount: todos.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      key: ValueKey(todos[index].id),
                                      todos[index].title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  leading: InkWell(
                                    child: Icon(
                                      todos[index].compleated
                                          ? Icons.check_box_outlined
                                          : Icons.check_box_outline_blank,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                    onTap: () {
                                      firebase
                                          .toggleTodoCompleation(todos[index]);
                                    },
                                  ),
                                );
                              },
                            );
                          })),
                  NewItemWidget(
                    onAdd: (String title) => firebase.addTodo(title),
                    onDelete: firebase.removeCheckedTodos,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
