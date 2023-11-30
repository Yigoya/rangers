import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rangers/Todo/group.dart';
import 'package:rangers/Todo/todoTimeline.dart';
import 'package:rangers/calander/calander.dart';
import 'package:rangers/component/form.dart';
import 'package:rangers/db/dbService.dart';
import 'package:rangers/db/event.dart';
import 'package:rangers/db/task.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rangers/service/recovery.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  DBService dbService = DBService.instance;
  List<Events> _event = [];
  List<Tasks> _task = [];
  DateTime time = DateTime.now();
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() async {
    List<Events> event = await dbService.fetchDayEvent(time.day);
    List<Tasks> task = await dbService.fetchTask();
    setState(() {
      _event = event;
      _task = task;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: SingleChildScrollView(
            child: Column(
          children: [
            ProfileHome('Good morning', 'Alisia'),
            const SizedBox(
              height: 20,
            ),
            DateLayout(),
            const SizedBox(
              height: 40,
            ),
            MyTasks(),
          ],
        )));
  }

  Widget DateLayout() {
    List<String> week = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];
    List<String> month = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  '${week[time.weekday - 1]} ${time.day} ${month[time.month - 1]}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 20),
                )
              ],
            ),
            const SizedBox(
              width: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Now",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  '${time.hour > 12 ? time.hour - 12 : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}   ${time.hour > 12 ? 'PM' : 'AM'}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 20),
                )
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        searchBar('Serch for event and tasks'),
        const SizedBox(
          height: 40,
        ),
        EventUp(),
      ],
    );
  }

  Widget MyTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("My tasks",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25,
                    color: Colors.black.withOpacity(0.7))),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyGroup()));
              },
              child: const Text("See all",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.blue)),
            )
          ],
        ),
        SizedBox(
          width: 340,
          height: 200,
          child: ListView.builder(
              itemCount: _task.length > 5 ? 5 : _task.length,
              itemBuilder: ((context, index) {
                return TodoElement(_task[index]);
              })),
        )
      ],
    );
  }

  Widget TodoElement(Tasks task) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: task.isComplated,
                onChanged: (bo) async {
                  task.isComplated = !task.isComplated;
                  await dbService.updateTask(task);
                  _refresh();
                }),
            SizedBox(
              width: 240,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  task.task,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: task.isComplated
                          ? Colors.black.withOpacity(0.6)
                          : Colors.black.withOpacity(0.9)),
                ),
              ),
            )
          ],
        ),
        IconButton(
            onPressed: () async {
              await dbService.deleteTask(task.id);
              _refresh();
            },
            icon: Icon(
              Icons.delete,
              color: Colors.black.withOpacity(0.4),
            ))
      ],
    );
  }

  Widget EventUp() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming event',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                  color: Colors.black.withOpacity(0.9)),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Calender()));
                },
                icon: const Icon(Icons.edit_calendar_outlined))
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/profile.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220,
                            // decoration: BoxDecoration(
                            //   color: const Color.fromARGB(255, 160, 77, 77),
                            // ),

                            child: SizedBox(
                              height: 60,
                              width: 100,
                              child: _event.length == 0
                                  ? Text(
                                      "you don't have event today",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 22,
                                          color: Colors.black.withOpacity(0.8)),
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          _event.length > 1 ? 1 : _event.length,
                                      itemBuilder: ((context, index) {
                                        print('event: ${_event[index].event}');
                                        String timeinterval =
                                            '${_event[index].hour > 12 ? _event[index].hour - 12 : _event[index].hour}:${_event[index].minute < 10 ? '0${_event[index].minute}' : _event[index].minute} ${_event[index].hour > 12 ? 'PM' : 'AM'} - ${_event[index].endhour > 12 ? _event[index].endhour - 12 : _event[index].endhour}:${_event[index].endminute < 10 ? '0${_event[index].endminute}' : _event[index].endminute} ${_event[index].endhour > 12 ? 'PM' : 'AM'}';

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _event[index].event,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 22,
                                                  color: Colors.black
                                                      .withOpacity(0.8)),
                                            ),
                                            Text(
                                              timeinterval,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Colors.black
                                                      .withOpacity(0.4)),
                                            )
                                          ],
                                        );
                                      }),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text("Discussion of the new project",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.6))),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> pickAndUploadFile() async {
    // if (!Platform.isAndroid) {
    //
    // } else {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    try {
      String url = 'images/${DateTime.now().toString()}.png';
      // Create a reference to the location you want to upload to in Firebase Storage
      final storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(url);

      // Upload the file to Firebase Storage
      await storageReference.putFile(imageTemporary);

      // Get the download URL of the uploaded image
      final imageUrl = await storageReference.getDownloadURL();
      print(imageUrl);
      // Do something with the download URL (e.g., save it to Firestore, display it in your app, etc.)
    } catch (e) {
      print('Error uploading image to Firebase: $e');
    }
  }

  Widget ProfileHome(String msg, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey[800]),
                  child: IconButton(
                      onPressed: () async {
                        await pickAndUploadFile();
                      },
                      icon: Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.6)),
                ),
                //           await dbService.deleteUser();
                // Users users = Users(name: name, email: email, password: password);
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasError) {
                        return IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.refresh_sharp,
                              color: Colors.red,
                            ));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator.adaptive();
                      }
                      // final data = snapshot.
                      return Text(
                        snapshot.data!.data()!['name'] ?? "Alisa",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.9)),
                      );
                    }))
              ],
            )
          ],
        ),
        Row(
          children: [
            Container(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('data')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('event')
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasError) {
                      return IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.refresh_sharp,
                            color: Colors.red,
                          ));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator.adaptive();
                    }
                    print(snapshot.data!.docs[0].data());
                    // print(FirebaseAuth.instance.currentUser!.uid);
                    Recover recover = Recover(snap: snapshot.data!.docs);
                    recover.recEvent();
                    recover.signIn();
                    return Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    );
                  })),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
            ),
          ],
        )
      ],
    );
  }
}
