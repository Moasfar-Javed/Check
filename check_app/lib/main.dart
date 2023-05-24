import 'package:check_app/utilities/pallete.dart';
import 'package:check_app/utilities/routes.dart';
import 'package:check_app/views/demo_page_view.dart';
import 'package:check_app/views/sign_in_view.dart';
import 'package:check_app/views/sign_up_view.dart';
import 'package:check_app/views/todo_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          primarySwatch: Palette.appColorPalette,
          scaffoldBackgroundColor: Palette.appColorPalette[900],
          fontFamily: 'Inter',
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Palette.textColor,
            ),
            bodySmall: TextStyle(
              color: Palette.text2Color,
            ),
          )),
      home: const SplashPageView(),
      routes: {
        demoRoute: (context) => const DemoPageView(),
        signUpRoute:(context) => const SignUpView(),
        signInRoute:(context) => const SignInView(),
        todoRoute:(context) => const TodoView(),
      },
    ),
  );
}

class SplashPageView extends StatefulWidget {
  const SplashPageView({super.key});

  @override
  State<SplashPageView> createState() => _SplashPageViewState();
}

class _SplashPageViewState extends State<SplashPageView> {
  @override
  Widget build(BuildContext context) {
    return const SignInView();
  }
}
