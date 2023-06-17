import 'package:alarm/alarm.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:check_app/utilities/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerTab extends StatefulWidget {
  const TimerTab({super.key});

  @override
  State<TimerTab> createState() => _TimerTabState();
}

class _TimerTabState extends State<TimerTab>
    with SingleTickerProviderStateMixin {
  final StopWatchTimer _stopWatchTimer =
      StopWatchTimer(mode: StopWatchMode.countDown);

  late AnimationController _animationController;
  bool isStarted = false;

  Duration initialtimer = new Duration();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          isStarted
              ? Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 4,
                      style: BorderStyle.solid,
                      color: isStarted
                          ? Palette.primaryColorVariant
                          : Palette.textColorDarker,
                    ),
                  ),
                  child: Center(
                    child: StreamBuilder<int>(
                      stream: _stopWatchTimer.rawTime,
                      initialData: _stopWatchTimer.rawTime.value,
                      builder: (context, snapshot) {
                        final value = snapshot.data;
                        final displayTime = StopWatchTimer.getDisplayTime(
                          value!,
                          hours: false,
                        );
                        return Text(
                          displayTime,
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w800),
                        );
                      },
                    ),
                  ),
                )
              : CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.ms,
                  minuteInterval: 1,
                  secondInterval: 1,
                  initialTimerDuration: initialtimer,
                  onTimerDurationChanged: (Duration changedtimer) {
                    setState(() {
                      initialtimer = changedtimer;
                    });
                  },
                ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 44,
                width: 80,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isStarted ? Palette.redTodo : Palette.success,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () async {
                    // _stopWatchTimer.setPresetTime(
                    //     mSec: initialtimer.inMilliseconds);
                    // //print(initialtimer.inMilliseconds);
                    // if (isStarted) {
                    //   _stopWatchTimer.onStopTimer();
                    // } else {
                    // final scheduledTime = DateTime.now()
                    //     .add(initialtimer); // Calculate the scheduled time
                    //  await scheduleOneTimeTimer(initialtimer);
                    //   _stopWatchTimer.onResetTimer();
                    //   _stopWatchTimer.onStartTimer();
                    // }
                    if (!isStarted) {
                      _stopWatchTimer.setPresetTime(
                          mSec: initialtimer.inMilliseconds);
                      _stopWatchTimer.onStartTimer();
                      final timerTime = DateTime.now().add(initialtimer);
                      final alarmSettings = AlarmSettings(
                          id: 45,
                          dateTime: timerTime,
                          assetAudioPath: 'assets/sounds/alarm.mp3',
                          notificationTitle: 'Timer Expired',
                          notificationBody: 'Your timer has run out');
                      await Alarm.set(alarmSettings: alarmSettings);
                    } else {
                      _stopWatchTimer.onStopTimer();
                      _stopWatchTimer.onResetTimer();
                      //print(_stopWatchTimer.rawTime.toString());
                      await Alarm.stop(45);
                    }
                    setState(() {
                      isStarted = !isStarted;
                    });
                  },
                  child: Text(
                    isStarted ? 'Cancel' : 'Start',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
