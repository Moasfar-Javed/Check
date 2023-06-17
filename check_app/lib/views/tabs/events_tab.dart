import 'package:check_app/services/crud/event_service.dart';
import 'package:check_app/services/models/event_model.dart';
import 'package:check_app/widgets/add_event_card.dart';
import 'package:check_app/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  Dialogs dialogs = Dialogs();
  late final EventService _eventService;

  @override
  void initState() {
    _eventService = EventService();
    super.initState();
  }

  List<Appointment> getAppointments(List<Event> allEvents) {
    List<Appointment> meetings = <Appointment>[];

    // Mapping List<Event> to List<Appointment>
    for (var event in allEvents) {
      Appointment appointment = Appointment(
        startTime: event.startTime,
        endTime: event.endTime,
        subject: event.subject,
        color: getTileColor(event.color),
        isAllDay: event.isAllDay,
      );
      meetings.add(appointment);
    }

    return meetings;
  }

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
          showAnimatedDialog(
            context: context,
            animationType: DialogTransitionType.slideFromBottom,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return const AddEventCard();
            },
          );
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
      body:
          //Column(),
          // SfCalendar(),
          Column(children: [
        FutureBuilder(
          future: _eventService.cacheEvents(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder<List<Event>>(
                  stream: _eventService.allEvents,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      case ConnectionState.active:
                        var allEvents = snapshot.data as List<Event>;

                        return Expanded(
                          child: SfCalendar(
                            view: CalendarView.week,
                            allowedViews: const [
                              CalendarView.week,
                              CalendarView.day,
                            ],
                            firstDayOfWeek: 6,
                            dataSource:
                                MeetingDataSource(getAppointments(allEvents)),
                            onTap: (CalendarTapDetails details) {
                              List<dynamic>? dynamicAppointments =
                                  details.appointments;
                              List<Appointment> appointments = [];

                              if (dynamicAppointments != null) {
                                for (dynamic appointment
                                    in dynamicAppointments) {
                                  if (appointment is Appointment) {
                                    appointments.add(appointment);
                                  }
                                }
                              }

                              if (appointments.isNotEmpty) {
                                Appointment appointment = appointments[0];
                                Event selectedEvent = allEvents.firstWhere(
                                  (event) =>
                                      event.subject == appointment.subject &&
                                      event.startTime ==
                                          appointment.startTime &&
                                      event.endTime == appointment.endTime,
                                );

                                dialogs.showEventDetailsDialog(
                                    context: context, event: selectedEvent);
                              }
                            },
                          ),
                        );

                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ]),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
