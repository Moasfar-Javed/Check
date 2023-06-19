import 'package:check_app/utilities/pallete.dart';
import 'package:check_app/views/tabs/clock%20tabs/stopwatch.dart';
import 'package:check_app/views/tabs/clock%20tabs/timer.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';

class ClockTab extends StatefulWidget {
  const ClockTab({super.key});

  @override
  State<ClockTab> createState() => _ClockTabState();
}

class _ClockTabState extends State<ClockTab> {
  int tabValue = 0;
  final List<Widget> _tabs = const [StopwatchTab(), TimerTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CustomSlidingSegmentedControl<int>(
                  initialValue: 0,
                  children: {
                    0: Text(
                      'Stopwatch',
                      style: TextStyle(
                          color: (tabValue == 0)
                              ? Palette.textColorDarker
                              : Palette.textColor),
                    ),
                    1: Text(
                      'Timer',
                      style: TextStyle(
                          color: (tabValue == 1)
                              ? Palette.textColorDarker
                              : Palette.textColor),
                    ),
                  },
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xFFFC9E3A),
                      Color(0xFFC43726),
                    ]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: Palette.textColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                        offset: const Offset(
                          0.0,
                          2.0,
                        ),
                      ),
                    ],
                  ),
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInToLinear,
                  onValueChanged: (v) {
                    setState(() {
                      tabValue = v;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 0),
                child: _tabs[tabValue],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
