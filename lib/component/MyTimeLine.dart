import 'package:flutter/material.dart';
import 'package:rangers/db/task.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLine extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;

  final void Function(Tasks) update;
  final void Function(int?) delete;
  final Tasks task;
  const MyTimeLine(
      {super.key,
      required this.task,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      required this.update,
      required this.delete});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle:
            LineStyle(color: isPast ? Colors.green : Colors.grey.shade50),
        indicatorStyle: IndicatorStyle(
            width: 20,
            color: isPast ? Colors.green : Colors.grey.shade200,
            iconStyle: IconStyle(
                iconData: Icons.done,
                color: isPast ? Colors.white : Colors.grey.shade200)),
        endChild: GestureDetector(
          onDoubleTap: () {
            delete(task.id);
          },
          onTap: () {
            update(task);
          },
          child: TaskForm(),
        ),
      ),
    );
  }

  Widget TaskForm() {
    return Container(
        margin: const EdgeInsets.only(left: 10, bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          color: isPast
              ? const Color.fromARGB(255, 35, 14, 71)
              : Colors.black.withOpacity(0.1),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.task,
                style: TextStyle(
                  color: isPast
                      ? Colors.white
                      : const Color.fromARGB(255, 25, 12, 87),
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                task.desc,
                style: TextStyle(
                  color: isPast
                      ? Colors.white.withOpacity(0.9)
                      : Colors.deepPurple.shade800.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ));
  }
}
