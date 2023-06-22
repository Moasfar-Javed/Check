import 'package:alarm/alarm.dart';
import 'package:check_app/services/auth_user.dart';
import 'package:check_app/services/crud/user_service.dart';
import 'package:check_app/utilities/pallete.dart';
import 'package:check_app/utilities/routes.dart';
import 'package:check_app/views/account_view.dart';
import 'package:check_app/views/crud_note_view.dart';
import 'package:check_app/views/email_verify.dart';
import 'package:check_app/views/home_view.dart';
import 'package:check_app/views/demo_page_view.dart';
import 'package:check_app/views/sign_in_view.dart';
import 'package:check_app/views/sign_up_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  final isInit =
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  print(isInit);
  ;
  //await AndroidAlarmManager.initialize();
  await Alarm.init();

  //Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Palette.appTheme,
      home: const Guider(),
      routes: {
        demoRoute: (context) => const DemoPageView(),
        signUpRoute: (context) => const SignUpView(),
        signInRoute: (context) => const SignInView(),
        homeRoute: (context) => const HomeView(),
        crudNotesRoute: (context) => const CrudNoteView(),
        account: (context) => const AccountView(),
        verifyEmail: (context) => const EmailVerifyView(),
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
                    if (FirebaseAuth.instance.currentUser!.emailVerified) {
                      print(FirebaseAuth.instance.currentUser!.email);
                      print(AuthUser.getCurrentUser().email);
                      return const HomeView();
                    } else {
                      return const EmailVerifyView();
                    }
                  } else {
                    return const DemoPageView();
                  }
                } else {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ));
                }
              },
            );
          default:
            return SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: const Center(
                  child: CircularProgressIndicator(),
                ));
        }
      },
    );
  }
}
