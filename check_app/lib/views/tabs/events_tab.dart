import 'package:check_app/services/crud/event_service.dart';
import 'package:check_app/services/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  late final EventSevice _eventService;

  @override
  void initState() {
    _eventService = EventSevice();
    super.initState();
  }




  // List<Appointment> getAppointments(List<Event> allEvents) {
  //   List<Appointment> meetings = <Appointment>[];

  //   // Mapping List<Event> to List<Appointment>
  //   for (var event in allEvents) {
  //     Appointment appointment = Appointment(
  //       startTime: event.startTime,
  //       endTime: event.endTime,
  //       subject: event.subject,
  //       color: getTileColor(event.color),
  //       isAllDay: event.isAllDay,
  //     );
  //     meetings.add(appointment);
  //   }

  //   return meetings;
  // }

  Color getTileColor(String colorText) {
    switch (colorText) {
      case 'blue':
        return Colors.blue;
      case 'pink':
        return Colors.pink;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.cyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showAnimatedDialog(
          //   context: context,
          //   animationType: DialogTransitionType.slideFromBottom,
          //   barrierDismissible: true,
          //   builder: (BuildContext context) {
          //     return const AddEventCard();
          //   },
          // );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color(0xFFFC9E3A),
              Color(0xFFC43726),
            ]),
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: const Icon(Icons.add),
        ),
      ),
       body: Column(),
       // SfCalendar(),
      // Column(children: [
      //   FutureBuilder(
      //     future: _eventService.cacheEvents(),
      //     builder: (context, snapshot) {
      //       switch (snapshot.connectionState) {
      //         case ConnectionState.done:
      //           return StreamBuilder<List<Event>>(
      //             stream: _eventService.allEvents,
      //             builder: (context, snapshot) {
      //               switch (snapshot.connectionState) {
      //                 case ConnectionState.waiting:
      //                   return const CircularProgressIndicator();
      //                 case ConnectionState.active:
      //                   var allEvents = snapshot.data as List<Event>;

      //                   return SfCalendar(
      //                     // view: CalendarView.week,
      //                     // firstDayOfWeek: 6,
      //                     // dataSource:
      //                     //     MeetingDataSource(getAppointments(allEvents)),
      //                   );

      //                 default:
      //                   return const CircularProgressIndicator();
      //               }
      //             },
      //           );
      //         default:
      //           return const CircularProgressIndicator();
      //       }
      //     },
      //   ),
      // ]),
    );
  }
}

// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }
