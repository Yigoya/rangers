import 'package:flutter/material.dart';
import 'package:rangers/db/event.dart';

class MyStates extends StatelessWidget {
  final List<Events>? events;
  const MyStates({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Expanded(
      child: ListView(
        children: events!
            .map((event) => Row(
                  children: [
                    Column(
                      children: [
                        Text(
                            '${event.hour > 12 ? event.hour - 12 : event.hour}:${event.minute < 10 ? '0${event.minute}' : event.minute}'),
                        const Spacer(),
                        Text(
                            '${event.endhour > 12 ? event.endhour - 12 : event.endhour}:${event.endminute < 10 ? '0${event.endminute}' : event.endminute}')
                      ],
                    ),
                    Container(
                        child: Column(
                      children: [
                        Text(event.event),
                        Text(
                            '${event.hour > 12 ? event.hour - 12 : event.hour}:${event.minute < 10 ? '0${event.minute}' : event.minute} ${event.endhour > 12 ? 'PM' : 'AM'} - ${event.endhour > 12 ? event.endhour - 12 : event.endhour}:${event.endminute < 10 ? '0${event.endminute}' : event.endminute} ${event.endhour > 12 ? 'PM' : 'AM'}')
                      ],
                    )),
                  ],
                ))
            .toList(),
      ),
    ));
  }
}
