import 'package:check_app/services/crud/user_service.dart';
import 'package:check_app/services/defined_exceptions.dart';
import 'package:check_app/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import '../utilities/routes.dart';
import '../widgets/gradient_button.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> with TickerProviderStateMixin {
  late final GifController ctrlr;
  late final TextEditingController _email;
  late final TextEditingController _password;
  Dialogs _dialogs = Dialogs();

  late final FocusNode _focusNode1;
  late final FocusNode _focusNode2;

  bool _obscureText = true;
  bool _emailValid = true;
  bool _passwordValid = true;

  @override
  void initState() {
    ctrlr = GifController(vsync: this);
    _email = TextEditingController();
    _password = TextEditingController();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _emailValid = _email.text.isNotEmpty;
      _passwordValid = _password.text.isNotEmpty;
    });
  }

  bool validate() {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      _dialogs.showTimedDialog(
          context: context, title: 'Error', text: 'One or more fields empty');
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
                'Sign In',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Gif(
                controller: ctrlr,
                width: 200,
                height: 200,
                //duration: const Duration(seconds: 4),
                autostart: Autostart.once,
                placeholder: (context) =>
                    const Center(child: CircularProgressIndicator()),
                image: const AssetImage('assets/images/login.gif'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: FocusTraversalGroup(
                  policy: OrderedTraversalPolicy(),
                  child: Column(
                    children: [
                      TextField(
                        focusNode: _focusNode1,
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        enableSuggestions: false,
                        onChanged: (_) => _validateFields(),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          errorText: _emailValid ? null : 'Email is required',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        focusNode: _focusNode2,
                        controller: _password,
                        obscureText: _obscureText,
                        autocorrect: false,
                        enableSuggestions: false,
                        onChanged: (_) => _validateFields(),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          errorText:
                              _passwordValid ? null : 'Password is required',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              GradientButton(
                onPressed: () async {
                  if (validate()) {
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      await UserService()
                          .signInUser(email: email, password: password);
                      if (context.mounted) {
                        Dialogs.showLoadingDialog(
                            context: context, text: 'Signing you in');
                      }
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            homeRoute, (route) => false);
                      }
                    } catch (e) {
                      if (e is InvalidLoginException) {
                        _dialogs.showTimedDialog(
                            context: context,
                            title: 'Invalid Credentials',
                            text: 'Either email, password or both are incorrect');
                      } else {
                        _dialogs.showTimedDialog(
                            context: context,
                            title: 'Services Unavailable',
                            text: 'Please try again later');
                      }
                    }
                  }
                },
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 25),
              const Text("Don't have an account?"),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(demoRoute, (route) => false);
                  }
                },
                child: const Text(
                  'Sign Up instead',
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
