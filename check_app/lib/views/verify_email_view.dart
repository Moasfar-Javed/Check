import 'package:check_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Please verify your email'),
          GradientButton(onPressed: () {}, child: const Text('Verified'))
        ],
      ),
    );
  }
}
