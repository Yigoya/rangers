import 'package:flutter/material.dart';

class Calander extends StatefulWidget {
  const Calander({super.key});

  @override
  State<Calander> createState() => _CalanderState();
}

List<int> monthday = [31, 28, 31, 30, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
DateTime time = DateTime.now();
int weekday = time.weekday;
int month = time.month;
int day = time.day;
int nextday = 0;
int? next;
Widget week(int num) {
  if (num == 0) {
    int nums = monthday[month - 2];
    int wday = weekday - 1;
    return Row(
      children: [
        Text(weekday == 1
            ? nums.toString()
            : weekday < 1
                ? '${++nextday}'
                : '${nums - (wday--)}'),
        Text(weekday == 2
            ? nums.toString()
            : weekday < 2
                ? '${++nextday}'
                : '${nums - (wday--)}'),
        Text(weekday == 3
            ? nums.toString()
            : weekday < 3
                ? '${++nextday}'
                : '${nums - (wday--)}'),
        Text(weekday == 4
            ? nums.toString()
            : weekday < 4
                ? '${++nextday}'
                : '${nums - (wday--)}'),
        Text(weekday == 5
            ? nums.toString()
            : weekday < 5
                ? '${++nextday}'
                : '${nums - (wday--)}'),
        Text(weekday == 6
            ? nums.toString()
            : weekday < 6
                ? '${++nextday}'
                : '${nums - (wday--)}'),
        Text(weekday == 7
            ? nums.toString()
            : weekday < 7
                ? '${++nextday}'
                : '${nums - (wday--)}'),
      ],
    );
  }
  int monthnum = monthday[month - 1];
  int endday = 0;
  return Row(
    children: [
      Text(monthnum < ((num * 7) + 1)
          ? (++endday).toString()
          : ((num * 7) + 1).toString()),
      Text(monthnum < ((num * 7) + 2)
          ? (++endday).toString()
          : ((num * 7) + 2).toString()),
      Text(monthnum < ((num * 7) + 3)
          ? (++endday).toString()
          : ((num * 7) + 3).toString()),
      Text(monthnum < ((num * 7) + 4)
          ? (++endday).toString()
          : ((num * 7) + 4).toString()),
      Text(monthnum < ((num * 7) + 5)
          ? (++endday).toString()
          : ((num * 7) + 5).toString()),
      Text(monthnum < ((num * 7) + 6)
          ? (++endday).toString()
          : ((num * 7) + 6).toString()),
      Text(monthnum < ((num * 7) + 7)
          ? (++endday).toString()
          : ((num * 7) + 7).toString()),
    ],
  );
}

class _CalanderState extends State<Calander> {
  Widget WeekCalander() {
    int numday = (day - weekday) ~/ 7;
    return week(numday);
  }

  Widget MonthCalander() {
    return Column(children: [
      week(0),
      week(1),
      week(2),
      week(3),
      week(4),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("calander")),
      body: MonthCalander(),
    );
  }
}
