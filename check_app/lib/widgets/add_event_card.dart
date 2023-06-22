import 'dart:io';

import 'package:check_app/services/crud/event_service.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import '../utilities/pallete.dart';
import 'gradient_button.dart';

class AddEventCard extends StatefulWidget {
  const AddEventCard({
    super.key,
  });

  @override
  State<AddEventCard> createState() => _AddEventCardState();
}

class _AddEventCardState extends State<AddEventCard> {
  late final TextEditingController _todo;
  late final TextEditingController _dateStart;
  late final TextEditingController _dateEnd;
  late final TextEditingController _timeStart;
  late final TextEditingController _timeEnd;

  String? selectedTag;
  String? selectedTagEventType;
  final List<String> _tagsList = ['Blue', 'Green', 'Purple', 'Pink', 'Cyan'];
  final List<String> _tagsListEventType = ['Timed', 'All Day'];
  late DateTime? _dateValueStart;
  late DateTime? _dateValueEnd;
  late TimeOfDay _timeValue;
  Time _timePickerValueEnd =
      Time(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
  Time _timePickerValueStart =
      Time(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
  final EventService _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _todo = TextEditingController();
    _dateStart = TextEditingController();
    _dateEnd = TextEditingController();
    _timeStart = TextEditingController();
    _timeEnd = TextEditingController();
    _dateValueStart = null;
    _dateValueEnd = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  onTimeValueChanged(TimeOfDay time) {
    setState(() {
      _timeValue = time;
    });
  }

  void _selectDate(BuildContext context, String isFor) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (isFor == 'start')
            ? (_dateValueStart == null ? DateTime.now() : _dateValueStart!)
            : (_dateValueEnd == null ? DateTime.now() : _dateValueEnd!),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));

    if (picked != null) {
      setState(
        () {
          (isFor == 'start')
              ? _dateValueStart = picked
              : _dateValueEnd = picked;
          if (picked.day == DateTime.now().day) {
            (isFor == 'start')
                ? _dateStart.text = 'Today'
                : _dateEnd.text = 'Today';
          } else {
            (isFor == 'start')
                ? _dateStart.text =
                    '${_dateValueStart?.day}/${_dateValueStart?.month}/${_dateValueStart?.year}'
                : _dateEnd.text =
                    '${_dateValueEnd?.day}/${_dateValueEnd?.month}/${_dateValueEnd?.year}';
          }
        },
      );
    }
  }

  String getFormatedTime(Time time) {
    String formattedTime = '';
    int hour = time.hourOfPeriod;
    String hourString = (hour == 0 ? '12' : hour.toString());
    String minuteString = time.minute.toString().padLeft(2, '0');
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    formattedTime = '$hourString:$minuteString $period';
    return formattedTime;
  }

  // void _addTodo() {

  //   _eventService.addEvent(startTime: startTime, endTime: endTime, subject: subject, color: color, isAllDay: isAllDay)
  //   //print('${selectedTag} ${_todo.text} ${due} ${DateTime.now()}');
  // }

  void _addEvent() {
    DateTime end = DateTime.utc(
        _dateValueEnd!.year,
        _dateValueEnd!.month,
        _dateValueEnd!.day,
        _timePickerValueEnd.hour,
        _timePickerValueEnd.minute);
    DateTime start = DateTime.utc(
        _dateValueStart!.year,
        _dateValueStart!.month,
        _dateValueStart!.day,
        _timePickerValueStart.hour,
        _timePickerValueStart.minute);
    bool isAllDay = selectedTagEventType == 'All Day' ? true : false;
    //print(
    //  '$start\n$end\n${_todo.text}\n${isAllDay}\n${selectedTag!.toLowerCase()}');
    _eventService.addEvent(
        startTime: start,
        endTime: end,
        subject: _todo.text,
        color: selectedTag!.toLowerCase(),
        isAllDay: isAllDay);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 500,
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Card(
            color: Palette.backgroundColor,
            margin: const EdgeInsets.only(bottom: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 30),
                      TextField(
                        controller: _todo,
                        maxLength: 15,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectDate(context, 'start'),
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: _dateStart,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: const InputDecoration(
                                    hintText: 'Start Date',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  showPicker(
                                    width: 350,
                                    // minHour: TimeOfDay.now().hour.toDouble(),
                                    // minMinute: TimeOfDay.now().minute.toDouble(),
                                    disableAutoFocusToNextInput: true,
                                    iosStylePicker:
                                        (Platform.isIOS || Platform.isAndroid)
                                            ? true
                                            : false,
                                    value: _timePickerValueStart,
                                    onChange: (Time time) {
                                      setState(() {
                                        _timePickerValueStart = time;
                                      });
                                      _timeStart.text = getFormatedTime(time);
                                    },
                                  ),
                                );
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: _timeStart,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: const InputDecoration(
                                    hintText: 'Start Time',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectDate(context, 'end'),
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: _dateEnd,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: const InputDecoration(
                                    hintText: 'End Date',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  showPicker(
                                    width: 350,
                                    // minHour: TimeOfDay.now().hour.toDouble(),
                                    // minMinute: TimeOfDay.now().minute.toDouble(),
                                    disableAutoFocusToNextInput: true,
                                    iosStylePicker:
                                        (Platform.isIOS || Platform.isAndroid)
                                            ? true
                                            : false,
                                    value: _timePickerValueEnd,
                                    onChange: (Time time) {
                                      setState(() {
                                        _timePickerValueEnd = time;
                                      });
                                      _timeEnd.text = getFormatedTime(time);
                                    },
                                  ),
                                );
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: _timeEnd,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: const InputDecoration(
                                    hintText: 'End Time',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            //SizedBox(child: Icon(Icons.),),
                            Container(
                              width: 156,
                              height: 60,
                              // padding: const EdgeInsets.symmetric(5
                              //     horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Palette.backgroundColorVariant,
                                borderRadius: BorderRadius.circular(8),
                                //border: Border.all(color: Pal)
                              ),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Palette.backgroundColorShade),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Palette.accentColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedTag,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  isExpanded: true,
                                  underline: Container(),
                                  hint: const Text(
                                    'Color',
                                    style: TextStyle(
                                        color: Palette.textColorVariant),
                                  ),
                                  items: _tagsList
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item, child: Text(item)))
                                      .toList(),
                                  onChanged: (item) {
                                    setState(() {
                                      selectedTag = item;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Container(
                              width: 156,
                              height: 60,
                              // padding: const EdgeInsets.symmetric(5
                              //     horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Palette.backgroundColorVariant,
                                borderRadius: BorderRadius.circular(8),
                                //border: Border.all(color: Pal)
                              ),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Palette.backgroundColorShade),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Palette.accentColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedTagEventType,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  isExpanded: true,
                                  underline: Container(),
                                  hint: const Text(
                                    'Type',
                                    style: TextStyle(
                                        color: Palette.textColorVariant),
                                  ),
                                  items: _tagsListEventType
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item, child: Text(item)))
                                      .toList(),
                                  onChanged: (item) {
                                    setState(() {
                                      selectedTagEventType = item;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 200,
                    child: GradientButton(
                      onPressed: () {
                        _addEvent();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
