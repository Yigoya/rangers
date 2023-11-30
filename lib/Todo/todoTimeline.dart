import 'dart:html';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rangers/Todo/group.dart';
import 'package:rangers/component/MyTimeLine.dart';
import 'package:rangers/component/form.dart';
import 'package:rangers/db/dbService.dart';
import 'package:rangers/db/task.dart';
import 'package:rangers/service/auth/auth_service.dart';

class TodoPage extends StatefulWidget {
  final int? groupid;
  final String group;
  const TodoPage({super.key, required this.groupid, required this.group});

  @override
  State<TodoPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TodoPage> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final DBService _dbService = DBService.instance;
  List<Tasks> _tasks = [];
  @override
  void initState() {
    super.initState();
    _refreshTaskList();
  }

  void _refreshTaskList() async {
    List<Tasks> tasks = await _dbService.fetchGroupTask(widget.groupid);
    if (mounted) {
      setState(() {
        _tasks = tasks;
      });
    }
  }

  void _addTask() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult.toString());
    final authService = Provider.of<AuthService>(context, listen: false);
    String taskName = _taskController.text;
    String descName = _descController.text;
    if (taskName.isNotEmpty) {
      Tasks newTask = Tasks(
          task: taskName,
          desc: descName,
          groupid: widget.groupid,
          isComplated: false);
      await _dbService.insertTask(newTask);
      List<Tasks> newDBTask = await _dbService.fetchOneTask();
      newTask = newDBTask[0];
      await authService.addTask(newTask);
      _refreshTaskList();
      _taskController.clear();
    }
  }

  void _toggleTask(Tasks task) async {
    task.isComplated = !task.isComplated;
    await _dbService.updateTask(task);
    _refreshTaskList();
  }

  void _deleteTask(int? taskId) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await _dbService.deleteTask(taskId!);
    await authService.deleteTask(taskId);
    _refreshTaskList();
  }

  void popForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Container(
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: const Text("Enter your Task"),
                    ),
                    textfield(_taskController, 'add your task'),
                    textfield(_descController, 'describe your task'),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                        onTap: () async {
                          TimeOfDay? newTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                          if (newTime != null) {
                            setState(() {
                              // daytime = newTime;
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
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10, right: 10),
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                          onPressed: () {
                            _addTask();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyGroup()),
                  (route) => false);
            },
            icon: Icon(Icons.arrow_circle_left_outlined)),
        title: Text(widget.group),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Expanded(
            child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return MyTimeLine(
                    task: _tasks[index],
                    delete: _deleteTask,
                    update: _toggleTask,
                    isFirst: index == 0 ? true : false,
                    isLast: index == _tasks.length - 1 ? true : false,
                    isPast: _tasks[index].isComplated,
                  );
                }),
          )
        ]),
      ),
      floatingActionButton: IconButton(
          onPressed: () {
            popForm(context);
          },
          icon: const Icon(Icons.add)),
    );
  }
}
