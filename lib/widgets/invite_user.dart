import 'package:flutter/material.dart';

class InviteUserWidget extends StatefulWidget {
  const InviteUserWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InviteUserWidgetState();
  }
}

class _InviteUserWidgetState extends State<InviteUserWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text('Invite family member to your meal plan'),
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: "family email"),
          ),
        ),
        ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.mail),
            label: Text("Invite Family Member"))
      ]),
    );
  }
}
