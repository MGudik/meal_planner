import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/widgets/invitation_list.dart';
import 'package:meal_planner/widgets/invite_user.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  void _signoutUser() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 36),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InviteUserWidget(),
            Spacer(),
            InvitationList(),
            ElevatedButton(onPressed: _signoutUser, child: Text('Sign out')),
          ],
        ),
      ),
    );
  }
}
