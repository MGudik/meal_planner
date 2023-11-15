import 'package:flutter/material.dart';
import 'package:meal_planner/models/invitation.dart';
import 'package:meal_planner/utilities/firebase.dart' as firebase;
import 'package:meal_planner/utilities/snackbars.dart';

class InvitationItem extends StatelessWidget {
  const InvitationItem({super.key, required this.invitation});

  final Invitation invitation;

  void _acceptInvitation(BuildContext context) async {
    await firebase.acceptInvitation(invitation);
    printSnackBar(context,
        "You have accepted the invitation from ${invitation.invitedBy}.");
    firebase.deleteInvitation(invitation);
  }

  void _deleteInvitation(BuildContext context) {
    firebase.deleteInvitation(invitation);
    printSnackBar(context,
        "You have declined the invitation from ${invitation.invitedBy}.");
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: InkWell(
          onTap: () => _acceptInvitation(context),
          child: Icon(Icons.check, color: Colors.green)),
      title: Text('Invitation from: ${invitation.invitedBy}'),
      trailing: InkWell(
        onTap: () => _deleteInvitation(context),
        child: Icon(
          Icons.delete,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
