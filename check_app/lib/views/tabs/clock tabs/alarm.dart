import 'package:check_app/utilities/pallete.dart';
import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';

class AlarmTab extends StatefulWidget {
  const AlarmTab({super.key});

  @override
  State<AlarmTab> createState() => _AlarmTabState();
}

class _AlarmTabState extends State<AlarmTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(
          height: 220,
          width: 220,
          child: AnalogClock(
            width: 150.0,
            isLive: true,
            hourHandColor: Colors.white,
            minuteHandColor: Colors.white,
            secondHandColor: Palette.primaryColor,
            showSecondHand: true,
            numberColor: Palette.textColorDarker,
            showNumbers: true,
            showAllNumbers: false,
            textScaleFactor: 1.4,
            showTicks: true,
            tickColor: Palette.textColorDarker,
            showDigitalClock: false,
            ),
        ),

        
      ],
    );
  }
}
