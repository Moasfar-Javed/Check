import 'package:flutter/material.dart';

class ClockTab extends StatefulWidget {
  const ClockTab({super.key});

  @override
  State<ClockTab> createState() => _ClockTabState();
}

class _ClockTabState extends State<ClockTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('clock'),
    );
  }
}
