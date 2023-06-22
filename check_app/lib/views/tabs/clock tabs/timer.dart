import 'dart:async';
import 'dart:typed_data';

import 'package:alarm/alarm.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:check_app/main.dart';
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
  late final StopWatchTimer _stopWatchTimer;

  late AnimationController _animationController;
  bool isStarted = false;

  Duration initialtimer = Duration.zero;

  Future<void> scheduleOneTimeTimer(Duration scheduledTime) async {
    await AndroidAlarmManager.oneShot(
      scheduledTime,
      46, // Alarm ID
      _showNotification,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _stopWatchTimer = StopWatchTimer(
        mode: StopWatchMode.countDown,
        presetMillisecond: initialtimer.inMilliseconds);
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

  void changeStateAfterDelay(Duration delay) {
    Timer(delay, () {
      setState(() {
        if (mounted) {
          isStarted = !isStarted;
        }
      });
      print('State changed!');
    });
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
                    if (isStarted == false) {
                      await scheduleOneTimeTimer(initialtimer);
                      changeStateAfterDelay(initialtimer);
                      _stopWatchTimer.setPresetTime(
                          mSec: initialtimer.inMilliseconds);
                      _stopWatchTimer.onStartTimer();
                    } else {
                      await AndroidAlarmManager.cancel(46);
                      await flutterLocalNotificationsPlugin.cancel(46);
                      _stopWatchTimer.onStopTimer();
                      _stopWatchTimer.onResetTimer();
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

void _showNotification() async {
  const int notificationId = 46;
  const String notificationTitle = 'Timer Expired';
  const String notificationBody = 'Your time is up';
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('check_application_0401', 'CheckApp',
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          vibrationPattern: Int64List.fromList(
              [0, 1000, 500, 1000, 500, 1000]), // Custom vibration pattern
          sound: const RawResourceAndroidNotificationSound(
              'alarm'), // Replace 'your_custom_sound' with your custom sound file name
          playSound: true,
          //sound: const UriAndroidNotificationSound("assets/sounds/alarm.mp3"),
          icon: '@drawable/app_icon');
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    notificationId,
    notificationTitle,
    notificationBody,
    platformChannelSpecifics,
  );
}
