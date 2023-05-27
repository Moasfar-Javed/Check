import 'dart:io';

import 'package:check_app/services/todo_service.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import '../utilities/pallete.dart';

class AddTodoCard extends StatefulWidget {
  const AddTodoCard({
    super.key,
  });

  @override
  State<AddTodoCard> createState() => _AddTodoCardState();
}

class _AddTodoCardState extends State<AddTodoCard> {
  late final TextEditingController _todo;
  late final TextEditingController _date;
  late final TextEditingController _time;
  String? selectedTag;
  final List<String> _tagsList = ['Home', 'Work', 'Study'];
  late DateTime? _dateValue;
  late TimeOfDay _timeValue;
  Time _timePickerValue =
      Time(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
  final TodoService _todoService = TodoService();

  @override
  void initState() {
    super.initState();
    _todo = TextEditingController();
    _date = TextEditingController();
    _time = TextEditingController();
    _dateValue = null;
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

  bool _isDateEnabled(DateTime date) {
    // Logic to check if the date is within the desired range
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 7));

    return date.isAfter(startDate.subtract(const Duration(days: 1))) &&
        date.isBefore(endDate.add(const Duration(days: 1)));
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateValue == null ? DateTime.now() : _dateValue!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      selectableDayPredicate: _isDateEnabled,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Palette.appColorPalette,
              onSurface: Colors.black12,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(
        () {
          _dateValue = picked;
          if (_dateValue?.day == DateTime.now().day) {
            _date.text = 'Today';
          } else {
            _date.text =
                '${_dateValue?.day}/${_dateValue?.month}/${_dateValue?.year}';
          }
        },
      );
    }
  }

  String getFormatedTime(Time time){
    String formattedTime = '';
    int hour = time.hourOfPeriod;
    String hourString = (hour == 0 ? '12' : hour.toString());
    String minuteString = time.minute.toString().padLeft(2, '0');
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    formattedTime = '$hourString:$minuteString $period';
    return formattedTime;
  }

  void _addTodo() {
    DateTime due = DateTime(_dateValue!.year, _dateValue!.month,
        _dateValue!.day, _timePickerValue.hour, _timePickerValue.minute);
    
    _todoService.postTodoApi(
        description: _todo.text, due: due, tag: selectedTag!);
    //print('${selectedTag} ${_todo.text} ${due} ${DateTime.now()}');
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
                    color: Palette.textColor,
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            //SizedBox(child: Icon(Icons.),),
                            SizedBox(
                              width: 100,
                              child: DropdownButton<String>(
                                value: selectedTag,
                                icon: const Icon(Icons.arrow_drop_down),
                                isExpanded: true,
                                underline: Container(
                                  height: 2,
                                  color: Palette.appColorPalette[400],
                                ),
                                hint: const Text('Tag'),
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _todo,
                        maxLength: 50,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'To-do',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Palette.appColorPalette[400]!,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: _date,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: 'Due Date',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Palette.appColorPalette[400]!,
                                      ),
                                    ),
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
                                    value: _timePickerValue,
                                    onChange: (Time time) {
                                      setState(() {
                                        _timePickerValue = time;
                                      });
                                      _time.text = getFormatedTime(time);
                                    },
                                  ),
                                );
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: _time,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: 'Due Time',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Palette.appColorPalette[400]!,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        _addTodo();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
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
