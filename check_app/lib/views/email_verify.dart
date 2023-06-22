import 'package:check_app/services/crud/user_service.dart';
import 'package:check_app/utilities/routes.dart';
import 'package:check_app/widgets/gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({super.key});

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  late UserService _userService;

  @override
  void initState() {
    _userService = UserService();
    if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      _userService.sendEmailVerification();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 350),
        child: Column(
          children: [
            const Text(
                'We have sent you an email with a link, click on it to complete your account creation',
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            GradientButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(signInRoute, (route) => false);
                },
                child: const Text('Go to Sign In'))
          ],
        ),
      ),
    ));
  }
}
