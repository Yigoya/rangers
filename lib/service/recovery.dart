import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rangers/db/dbService.dart';
import 'package:rangers/db/event.dart';
import 'package:rangers/db/note.dart';
import 'package:rangers/db/task.dart';
import 'package:rangers/service/auth/auth_service.dart';

class Recover {
  DBService dbService = DBService.instance;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> snap;
  Recover({required this.snap});
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<void> addEvent(Events event) async {
    final String id = _firebaseAuth.currentUser!.uid;
    await _fireStore
        .collection('data')
        .doc(id)
        .collection('event')
        .doc('${event.id}')
        .set(event.toMap());
  }

  Future<String> getDirectory() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> recEvent() async {
    List<Events> events = await dbService.fetchEvent();
    List<Notes> notes = await dbService.fetchnote();
    List<Tasks> tasks = await dbService.fetchTask();

    for (Events event in events) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> firesnap in snap) {
        Map<String, dynamic> data = firesnap.data() as Map<String, dynamic>;
        if (event.id != data['id']) {
          await addEvent(event);
        }
      }
    }
    print(await getDirectory());
  }

  Future<void> signIn() async {
    List<Events> events = await dbService.fetchEvent();
    List<Notes> notes = await dbService.fetchnote();
    List<Tasks> tasks = await dbService.fetchTask();
    for (Events event in events) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> firesnap in snap) {
        Map<String, dynamic> data = firesnap.data() as Map<String, dynamic>;
        if (event.id != data['id']) {
          Events newEvents = Events(
              event: data['event'],
              day: data['day'],
              month: data['month'],
              year: data['year'],
              hour: data['hour'],
              endhour: data['endhour'],
              minute: data['minute'],
              endminute: data['endminute']);
          await dbService.insertEvent(newEvents);
        }
      }
    }
  }
}
