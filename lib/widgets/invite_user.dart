import 'package:flutter/material.dart';
import 'package:meal_planner/utilities/firebase.dart' as firebase;
import 'package:meal_planner/utilities/snackbars.dart';

class InviteUserWidget extends StatefulWidget {
  const InviteUserWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InviteUserWidgetState();
  }
}

class _InviteUserWidgetState extends State<InviteUserWidget> {
  final _form = GlobalKey<FormState>();
  String _enteredEmail = "";

  String? validateEmail(String? value) {
    if (value == null ||
        value.trim().isEmpty ||
        value.trim().length < 3 ||
        !value.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  void _inviteMember() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    firebase.inviteUser(_enteredEmail);
    printSnackBar(context, "Invitation sent to $_enteredEmail.");
    _form.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(children: [
      Text('Invite family member to your meal plan'),
      Form(
        key: _form,
        child: TextFormField(
          decoration: InputDecoration(labelText: "Family Email Address"),
          validator: validateEmail,
          onSaved: (newValue) {
            _enteredEmail = newValue!;
          },
        ),
      ),
      const SizedBox(
        height: 16,
      ),
      ElevatedButton.icon(
          onPressed: _inviteMember,
          icon: Icon(Icons.mail),
          label: Text("Invite Family Member"))
    ]));
  }
}
