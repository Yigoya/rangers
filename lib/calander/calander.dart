import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rangers/component/form.dart';
import 'package:rangers/db/dbService.dart';
import 'package:rangers/db/event.dart';
import 'package:rangers/service/auth/auth_service.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  final DBService calenderDB = DBService.instance;

  List<Events> _events = [];
  DateTime time = DateTime.now();
  TimeOfDay? daytime = const TimeOfDay(hour: 12, minute: 12);
  TimeOfDay? enddaytime = const TimeOfDay(hour: 12, minute: 12);
  @override
  void initState() {
    super.initState();
    _refreshTaskList(time);
  }

  Future<List<Events>> _getSingleDayTaskList(int day) async {
    List<Events> events = await calenderDB.fetchDayEvent(day);
    // setState(() {
    //   _events = events;
    // });
    return events;
  }

  TextEditingController eventController = TextEditingController();

  void popForm(BuildContext context, DateTime time) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
            child: Container(
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: const Text("Enter your Event"),
                    ),
                    textfield(eventController, 'enter your event'),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );
                              if (newTime != null) {
                                setState(() {
                                  daytime = newTime;
                                });
                              }
                            },
                            child: Container(
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          blurRadius: 1,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 2))
                                    ],
                                    color: Colors.amber),
                                child: const Center(child: Text("set time")))),
                        GestureDetector(
                            onTap: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );
                              if (newTime != null) {
                                setState(() {
                                  enddaytime = newTime;
                                });
                              }
                            },
                            child: Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          blurRadius: 1,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 2))
                                    ],
                                    color: Colors.amber),
                                child:
                                    const Center(child: Text("set end time"))))
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10, right: 10),
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                          onPressed: () {
                            _addEvents();
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text("add Event")),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  double height = 580;
  Map<CalendarFormat, String> availableCalendarFormats = const {
    CalendarFormat.month: 'Month',
    CalendarFormat.week: 'Week'
  };
  CalendarFormat calenderFormater = CalendarFormat.week;
  DateTime _selectedDay = DateTime.now();
  DateTime? _focusedDay;

  void _refreshTaskList(DateTime setime) async {
    List<Events> events = await calenderDB.fetchDayEvent(setime.day);
    setState(() {
      _events = events;
      _selectedDay = setime;
    });
  }

  void _addEvents() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    String taskName = eventController.text;
    if (taskName.isNotEmpty) {
      Events events = Events(
        event: eventController.text,
        day: int.parse(_selectedDay.day.toString()),
        month: int.parse(_selectedDay.month.toString()),
        year: int.parse(_selectedDay.year.toString()),
        hour: daytime!.hour,
        endhour: daytime!.hour,
        minute: daytime!.minute,
        endminute: daytime!.minute,
      );
      await calenderDB.insertEvent(events);
      List<Events> event = await calenderDB.fetchREvent();
      await authService.addEvent(event[0]);
      await _getSingleDayTaskList(_selectedDay.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
                headerVisible: true,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) async {
                  List<Events> events =
                      await calenderDB.fetchDayEvent(selectedDay.day);
                  setState(() {
                    _events = events;
                    _selectedDay = selectedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    calenderFormater = format;
                    if (format == CalendarFormat.week) {
                      height = 580;
                    } else {
                      height = 366;
                    }
                  });
                },
                calendarFormat: calenderFormater,
                availableCalendarFormats: availableCalendarFormats,
              ),
              SingleChildScrollView(
                child: SizedBox(
                  width: 500,
                  height: height,
                  child: ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 500,
                        height: 80,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                    '${_events[index].hour > 12 ? _events[index].hour - 12 : _events[index].hour}:${_events[index].minute < 10 ? '0${_events[index].minute}' : _events[index].minute}'),
                                const Spacer(),
                                Text(
                                    '${_events[index].endhour > 12 ? _events[index].endhour - 12 : _events[index].endhour}:${_events[index].endminute < 10 ? '0${_events[index].endminute}' : _events[index].endminute}')
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                width: 270,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black.withOpacity(0.1)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_events[index].event,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 22,
                                            color:
                                                Colors.black.withOpacity(0.7))),
                                    Text(
                                        '${_events[index].hour > 12 ? _events[index].hour - 12 : _events[index].hour}:${_events[index].minute < 10 ? '0${_events[index].minute}' : _events[index].minute} ${_events[index].endhour > 12 ? 'PM' : 'AM'} - ${_events[index].endhour > 12 ? _events[index].endhour - 12 : _events[index].endhour}:${_events[index].endminute < 10 ? '0${_events[index].endminute}' : _events[index].endminute} ${_events[index].endhour > 12 ? 'PM' : 'AM'}')
                                  ],
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          popForm(context, _selectedDay);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
