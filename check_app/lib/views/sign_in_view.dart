import 'package:check_app/services/crud/user_service.dart';
import 'package:check_app/widgets/dialogs.dart';
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

  late final FocusNode _focusNode1;
  late final FocusNode _focusNode2;

  bool _obscureText = true;

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
                        onSubmitted: (_) {
                          _focusNode1.unfocus();
                          FocusScope.of(context).requestFocus(_focusNode2);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Email',
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              GradientButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  Dialogs.showLoadingDialog(context: context, text: 'Signing you in');
                  await UserService().signInUser(email: email, password: password);

                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                  }

                  // var response = await BaseClient()
                  //     .getUserApi('/users?email=$email&password=$password')
                  //     .catchError((e) {});
                  // if (response != null) {
                  //   List<dynamic> jsonResponse = jsonDecode(response);

                  //   if (jsonResponse.isNotEmpty) {
                  //     AuthUser user = AuthUser.fromJson(jsonResponse[0]);
                  //     print(user.email);
                  //     //AuthUser.signOut();
                  //     if (context.mounted) {
                  //       Navigator.of(context).pushNamedAndRemoveUntil(
                  //           homeRoute, (route) => false);
                  //     }
                  //   }
                  // } else {
                  //   return;
                  // }
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
