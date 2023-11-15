import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/models/invitation.dart';
import 'package:meal_planner/widgets/invitations_item.dart';

class InvitationList extends StatelessWidget {
  const InvitationList({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Invitations',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Divider(),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser!.uid)
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final data = snapshot.data!;
                List<dynamic> invitations = data.get('invitations');
                if (invitations.isEmpty) {
                  return Text("You have no invitations yet.");
                }
                List<Invitation> invitationItems = invitations
                    .map((e) => Invitation(
                        planID: e['planID']!, invitedBy: e['invitedBy']!))
                    .toList();

                return SizedBox(
                    height: 64,
                    child: ListView(
                      children: invitationItems.isEmpty
                          ? []
                          : invitationItems
                              .map((e) => InvitationItem(invitation: e))
                              .toList(),
                    ));
              }),
        ],
      ),
    );
  }
}
