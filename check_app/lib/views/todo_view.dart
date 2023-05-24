import 'package:check_app/utilities/pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        //color:  Palette.appColorPalette[900]!,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: Palette.textColor.withOpacity(0.4)),
          ),
          color: Palette.appColorPalette[900]!,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
            backgroundColor: Palette.appColorPalette[900]!,
            color: Palette.textColor,
            activeColor: Colors.white,
            tabBackgroundColor: Palette.appColorPalette,
            gap: 0,
            iconSize: 22,
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.playlist_add_check,
              ),
              GButton(
                icon: Icons.notifications_outlined,
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
    );
  }
}
