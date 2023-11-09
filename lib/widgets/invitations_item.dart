import 'package:flutter/material.dart';
import 'package:meal_planner/models/invitation.dart';
import 'package:meal_planner/utilities/firebase.dart' as firebase;

class InvitationItem extends StatelessWidget {
  const InvitationItem({super.key, required this.invitation});

  final Invitation invitation;

  void _acceptInvitation() async {
    await firebase.acceptInvitation(invitation);
    _deleteInvitation();
  }

  void _deleteInvitation() {
    firebase.deleteInvitation(invitation);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: InkWell(
          onTap: _acceptInvitation,
          child: Icon(Icons.check, color: Colors.green)),
      title: Text('Invitation from: ${invitation.invitedBy}'),
      trailing: InkWell(
        onTap: _deleteInvitation,
        child: Icon(
          Icons.delete,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
