import 'package:check_app/services/crud/user_service.dart';
import 'package:check_app/views/tabs/clock_tab.dart';
import 'package:check_app/views/tabs/events_tab.dart';
import 'package:check_app/views/tabs/notes_tab.dart';
import 'package:check_app/views/tabs/todo_tab.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:one_clock/one_clock.dart';

import '../services/auth_user.dart';
import '../utilities/pallete.dart';
import '../utilities/routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomViewState();
}

class _HomViewState extends State<HomeView> {
  int _selectedIndex = 0;
  String avatarLetter =
      AuthUser.getCurrentUser().username.substring(0, 1).toUpperCase();

  final List<String> _titles = const ['To-do', 'Events', 'Notes', 'Clock'];

  final List<Widget> _tabs = const [
    TodoTab(),
    EventsTab(),
    NotesTab(),
    ClockTab()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _titles[_selectedIndex],
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: SizedBox(
              height: 45,
              width: 45,
              child: AnalogClock(
                width: 150.0,
                isLive: true,
                hourHandColor: Colors.white,
                minuteHandColor: Colors.white,
                secondHandColor: Palette.primaryColor,
                showSecondHand: true,
                numberColor: Palette.textColorDarker,
                showNumbers: false,
                showAllNumbers: false,
                textScaleFactor: 1.4,
                showTicks: true,
                tickColor: Palette.primaryColorVariant,
                showDigitalClock: false,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'Account',
                    child: const Text('Account'),
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushNamed(account);
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'Sign Out',
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: () async {
                      // Future.delayed(const Duration(seconds: 0));
                      // print(Dialogs.showConfirmationDialog(
                      //     context: context,
                      //     type: 'neutral',
                      //     text: 'Are you sure you want to sign out?',
                      //     button: 'Sign Out'));
                      await UserService().logOut();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              demoRoute, (route) => false);
                        }
                      });
                    },
                  ),
                ],
                child: CircleAvatar(
                  backgroundColor: Palette.primaryColor,
                  child: Text(
                    avatarLetter,
                    style: const TextStyle(
                      color: Palette.textColor,
                    ),
                  ),
                ),
                onSelected: (String value) {
                  // Handle dropdown menu item selection here
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top:
                BorderSide(width: 1, color: Palette.textColor.withOpacity(0.2)),
          ),
          color: Palette.backgroundColorShade,
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10),
          child: GNav(
            backgroundColor: Colors.transparent,
            color: Palette.textColor,
            activeColor: Colors.white,
            tabBackgroundColor: Palette.primaryColor,
            gap: 0,
            iconSize: 22,
            tabBorderRadius: 20,
            padding: const EdgeInsets.all(16),
            curve: Curves.decelerate,
            duration: const Duration(milliseconds: 300),
            onTabChange: (newIndex) {
              setState(() {
                _selectedIndex = newIndex;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.playlist_add_check,
                iconSize: 26,
              ),
              GButton(
                icon: Icons.date_range,
              ),
              GButton(
                icon: Icons.library_books,
              ),
              GButton(
                icon: Icons.access_alarm,
              ),
            ],
          ),
        ),
      ),
      body: _tabs[_selectedIndex],
    );
  }
}
