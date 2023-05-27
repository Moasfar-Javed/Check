import 'package:flutter/material.dart';

class RemindersTab extends StatefulWidget {
  const RemindersTab({super.key});

  @override
  State<RemindersTab> createState() => _RemindersTabState();
}

class _RemindersTabState extends State<RemindersTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('reminders'),
    );
  }
}