import 'package:flutter/material.dart';
import 'package:rangers/Todo/todoTimeline.dart';
import 'package:rangers/db/dbService.dart';
import 'package:rangers/db/groups.dart';
import 'package:rangers/main.dart';

class MyGroup extends StatefulWidget {
  const MyGroup({super.key});

  @override
  State<MyGroup> createState() => _MyGroupState();
}

class _MyGroupState extends State<MyGroup> {
  TextEditingController topicController = TextEditingController();
  DBService dbService = DBService.instance;
  String iconname = 'message';
  List<Groups> _group = [];
  @override
  void initState() {
    super.initState();
    _refrash();
  }

  void _refrash() async {
    List<Groups> groups = await dbService.fetchGroup();
    setState(() {
      _group = groups;
    });
    print(_group);
  }

  void popForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          String iconname = 'message';

          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              width: 350,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose a topic name and icon',
                    style: TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: topicController,
                    decoration: InputDecoration(
                        hintText: 'what is you want to track',
                        border: InputBorder.none),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              iconname = 'message';
                            });
                          },
                          icon: Icon(
                            Icons.message,
                            color: iconname == 'message'
                                ? Colors.blueAccent
                                : Colors.black45,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              iconname = 'accessibility_new';
                            });
                          },
                          icon: Icon(
                            Icons.accessibility_new,
                            color: iconname == 'accessibility_new'
                                ? Colors.blueAccent
                                : Colors.black45,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              iconname = 'gamepad_outlined';
                            });
                          },
                          icon: Icon(
                            Icons.gamepad_outlined,
                            color: iconname == 'gamepad_outlined'
                                ? Colors.blueAccent
                                : Colors.black45,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              iconname = 'key';
                            });
                          },
                          icon: Icon(
                            Icons.key,
                            color: iconname == 'key'
                                ? Colors.blueAccent
                                : Colors.black45,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              iconname = 'zoom_in_map_rounded';
                            });
                          },
                          icon: Icon(
                            Icons.zoom_in_map_rounded,
                            color: iconname == 'zoom_in_map_rounded'
                                ? Colors.blueAccent
                                : Colors.black45,
                          )),
                    ],
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        onPressed: () async {
                          Groups groups = Groups(
                              groups: topicController.text, icon: iconname);
                          await dbService.insertGroup(groups);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyGroup()),
                              (route) => false);
                          setState(() {});
                        },
                        child: Text('start')),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyHome()),
                  (route) => false);
            },
            icon: Icon(Icons.arrow_circle_left_outlined)),
        title: Container(
            child: Row(
          children: [
            Icon(Icons.calendar_view_month_rounded),
            SizedBox(
              width: 5,
            ),
            Text("My plans"),
          ],
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: _group.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TodoPage(
                            groupid: _group[index].id,
                            group: _group[index].groups)));
              },
              child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.not_started_sharp),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 250,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            '${_group[index].groups}',
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.chevron_right)
                    ],
                  )),
            );
          },
        ),
      ),
      floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue,
          ),
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(right: 20, bottom: 30),
          child: IconButton(
              onPressed: () {
                popForm(context);
              },
              icon: Icon(
                Icons.add_box_outlined,
                color: Colors.white,
              ))),
    );
  }
}
