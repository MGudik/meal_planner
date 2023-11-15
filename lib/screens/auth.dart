import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_planner/utilities/firebase.dart' as firebase;
import 'package:meal_planner/utilities/snackbars.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredFirstName = '';
  String _enteredPassword = '';
  bool _isLogin = true;
  bool _isAuthenticating = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail.toLowerCase(), password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail.toLowerCase(), password: _enteredPassword);

        final mealPlanId = await firebase.createEmptyMealPlan();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'email': _enteredEmail.toLowerCase(),
          'username': _enteredFirstName,
          'mealId': mealPlanId,
          'invitations': []
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        printSnackBar(context, "An user with that email does already exists!");
      }
      else if (error.code == 'invalid-login-credentials') {
        printSnackBar(context, "Provided information did not match!");
      } else {
        printSnackBar(context, error.message ?? 'Authentication failed');
      }
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 16,
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "First Name"),
                                keyboardType: TextInputType.name,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.trim().length < 2) {
                                    return 'Please enter a valid name.';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _enteredFirstName = newValue!;
                                },
                              ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: "Email Address"),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredEmail = newValue!;
                              },
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Password"),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Password must be atleast 6 characters long.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredPassword = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            if (_isAuthenticating)
                              const CircularProgressIndicator(),
                            if (!_isAuthenticating)
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: Text(_isLogin ? 'Login' : "Signup"),
                              ),
                            if (!_isAuthenticating)
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(_isLogin
                                      ? 'Create an account'
                                      : 'I already have an account. Login.'))
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
