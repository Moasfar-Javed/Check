import 'package:alarm/alarm.dart';
import 'package:check_app/services/crud/user_service.dart';
import 'package:check_app/utilities/pallete.dart';
import 'package:check_app/utilities/routes.dart';
import 'package:check_app/views/crud_note_view.dart';
import 'package:check_app/views/home_view.dart';
import 'package:check_app/views/demo_page_view.dart';
import 'package:check_app/views/sign_in_view.dart';
import 'package:check_app/views/sign_up_view.dart';

import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await AndroidAlarmManager.initialize();
  await Alarm.init();
  //Firebase.initializeApp();
  runApp(
    MaterialApp(
      theme: Palette.appTheme,
      home: const Guider(),
      routes: {
        demoRoute: (context) => const DemoPageView(),
        signUpRoute: (context) => const SignUpView(),
        signInRoute: (context) => const SignInView(),
        homeRoute: (context) => const HomeView(),
        crudNotesRoute: (context) => const CrudNoteView(),
      },
    ),
  );
}

class Guider extends StatefulWidget {
  const Guider({super.key});

  @override
  State<Guider> createState() => _GuiderState();
}

class _GuiderState extends State<Guider> {
  bool isUserLoggedIn = false;

  Future<bool> fetchUserLoginStatus() async {
    try {
      bool loggedIn = await UserService().currentUser;
      return loggedIn;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserService.initializeFirebase(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return FutureBuilder(
              future: fetchUserLoginStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  isUserLoggedIn = snapshot.data as bool;
                  if (isUserLoggedIn) {
                    // if (user.emailVerified) {
                    //   return const NotesView();
                    // } else {
                    //   return const VerifyEmailView();
                    // }
                    return const HomeView();
                  } else {
                    return const DemoPageView();
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
