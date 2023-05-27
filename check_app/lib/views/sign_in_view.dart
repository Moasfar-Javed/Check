import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/auth_user.dart';
import '../services/base_client.dart';
import '../utilities/pallete.dart';
import '../utilities/routes.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  late final FocusNode _focusNode1;
  late final FocusNode _focusNode2;

  bool _obscureText = true;

  @override
  void initState() {
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
                  color: Palette.textColor,
                ),
              ),
              Image.asset(
                'assets/images/login.png',
                height: 200,
                width: 200,
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
                        onSubmitted: (_) {
                          _focusNode1.unfocus();
                          FocusScope.of(context).requestFocus(_focusNode2);
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Palette.appColorPalette[400]!,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        focusNode: _focusNode2,
                        controller: _password,
                        obscureText: _obscureText,
                        autocorrect: false,
                        enableSuggestions: false,
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
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Palette.appColorPalette[400]!,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 180,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    var response = await BaseClient()
                        .getUserApi('/users?email=$email&password=$password')
                        .catchError((e) {});
                    if (response != null) {
                      List<dynamic> jsonResponse = jsonDecode(response);

                      if (jsonResponse.isNotEmpty) {
                        AuthUser user = AuthUser.fromJson(jsonResponse[0]);
                        print(user.email);
                        //AuthUser.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              homeRoute, (route) => false);
                        }
                      }
                    } else {
                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 25),
              const Text("Don't have an account?"),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(signUpRoute, (route) => false);
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
