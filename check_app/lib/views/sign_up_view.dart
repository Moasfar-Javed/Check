import 'package:check_app/services/crud/user_service.dart';
import 'package:check_app/services/defined_exceptions.dart';
import 'package:check_app/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import '../utilities/routes.dart';
import '../widgets/gradient_button.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  Dialogs _dialogs = Dialogs();
  @override
  void initState() {
    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  bool validate() {
    if (_email.text.isEmpty ||
        _password.text.isEmpty ||
        _confirmPassword.text.isEmpty ||
        _username.text.isEmpty) {
      _dialogs.showTimedDialog(
          context: context,
          title: 'Fields Empty',
          text: 'One or more fields are left empty');
      return false;
    } else if (_password.text != _confirmPassword.text) {
      _dialogs.showTimedDialog(
          context: context,
          title: 'Passwords Not Same',
          text: 'The passwords do not match');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: _username,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _confirmPassword,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              GradientButton(
                onPressed: () async {
                  if (validate()) {
                    final username = _username.text;
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await UserService().addUser(
                          username: username, email: email, password: password);

                      if (context.mounted) {
                        _dialogs.showTimedDialog(
                            context: context,
                            title: 'Account Created',
                            text:
                                'Account successfully created you may proceed to signin');
                      }
                    } catch (e) {
                      if (e is InvalidLoginException) {
                        _dialogs.showTimedDialog(
                            context: context,
                            title: 'Invalid Email',
                            text: 'Please enter a valid email');
                      } else if (e is WeakPassword) {
                        _dialogs.showTimedDialog(
                            context: context,
                            title: 'Weak Password',
                            text: 'Please choose a stronger password');
                      } else if (e is EmailAlreadyInUse) {
                        _dialogs.showTimedDialog(
                            context: context,
                            title: 'Email Already in Use',
                            text: 'This is email is already in use');
                      }
                    }
                  }
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 25),
              const Text('Already have an account?'),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(signInRoute, (route) => false);
                  }
                },
                child: const Text(
                  'Sign In instead',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
