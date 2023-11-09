import 'package:flutter/material.dart';
import 'package:meal_planner/widgets/invitation_list.dart';
import 'package:meal_planner/widgets/invite_user.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key, required this.onSignOut});

  final Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InvitationList(),
            InviteUserWidget(),
            ElevatedButton(onPressed: onSignOut, child: Text('Sign out')),
          ],
        ),
      ),
    );
  }
}
