import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rangers/component/form.dart';

class MyTimer extends StatefulWidget {
  const MyTimer({super.key});

  @override
  State<MyTimer> createState() => _TimerState();
}

class _TimerState extends State<MyTimer> {
  static int maxSeconds = 30 * 60;
  int seconds = maxSeconds;
  Timer? timer;
  void starTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0 && mounted) {
        setState(() {
          seconds--;
        });
      } else {
        stopTimer(reset: false);
      }
    });
  }

  void resetTimer() => setState(() {
        seconds = maxSeconds;
      });

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    if (mounted) {
      setState(() => timer?.cancel());
    }
  }

  TextEditingController secondCOntroller = TextEditingController();
  TextEditingController minuteCOntroller = TextEditingController();
  void popForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
            child: Container(
              padding: EdgeInsets.all(10),
              width: 200,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: secondCOntroller,
                    decoration: InputDecoration(
                        hintText: 'second', border: InputBorder.none),
                  ),
                  TextField(
                      controller: minuteCOntroller,
                      decoration: InputDecoration(
                          hintText: 'minute', border: InputBorder.none)),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          maxSeconds = int.parse(secondCOntroller.text) * 60 +
                              int.parse(secondCOntroller.text);
                        });
                      },
                      child: Text('start'))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timer")),
      body: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [buildTimer(), buildButtons()],
        )),
      ),
    );
  }

  Widget buildTimer() => SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: seconds / maxSeconds,
              valueColor: AlwaysStoppedAnimation(Colors.blue),
              strokeWidth: 12,
            ),
            Center(
              child: buildTime(),
            )
          ],
        ),
      );
  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == maxSeconds || seconds == 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(
            onClicked: () {
              starTimer();
            },
            icon: Icons.restore_sharp),
        ButtonWidget(
            onClicked: () {
              if (isRunning) {
                stopTimer(reset: false);
              } else {
                starTimer(reset: false);
              }
            },
            icon: isRunning ? Icons.pause : Icons.play_arrow),
        ButtonWidget(
            onClicked: () {
              popForm(context);
            },
            icon: Icons.mode_edit_rounded),
      ],
    );
  }

  Widget buildTime() {
    if (seconds == 0) {
      return Icon(Icons.done, color: Colors.green);
    }
    return Text(
        '${(seconds / 60).toInt() < 10 ? '0${(seconds / 60).toInt()}' : (seconds / 60).toInt()}:${seconds % 60 < 10 ? '0${seconds % 60}' : seconds % 60}');
  }
}
