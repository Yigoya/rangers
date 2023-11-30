import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rangers/db/dbService.dart';
import 'package:rangers/db/event.dart';
import 'package:rangers/db/note.dart';
import 'package:rangers/db/task.dart';
import 'package:rangers/db/user.dart';
import 'package:connectivity/connectivity.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final DBService dbService = DBService.instance;
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  Future<UserCredential> signUpWithEmailandPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<void> post(String title, String description, String place,
      String price, String catagory, String url) async {
    final Timestamp timestamp = Timestamp.now();
    final String id = _firebaseAuth.currentUser!.uid;
    print(catagory);
    await _fireStore.collection('posts').doc(catagory).collection('post').add({
      'title': title,
      'description': description,
      'place': place,
      'money': price,
      'catagory': catagory,
      'ImageUrl': url,
      'timestamp': timestamp,
      'userid': _firebaseAuth.currentUser!.uid
    });
  }

  Future<void> addTask(Tasks task) async {
    final String id = _firebaseAuth.currentUser!.uid;
    await _fireStore
        .collection('data')
        .doc(id)
        .collection('task')
        .doc('${task.id}')
        .set(task.toMap());
  }

  Future<void> addEvent(Events event) async {
    final String id = _firebaseAuth.currentUser!.uid;
    await _fireStore
        .collection('data')
        .doc(id)
        .collection('event')
        .doc('${event.id}')
        .set(event.toMap());
  }

  Future<void> addNote(Notes note) async {
    final String id = _firebaseAuth.currentUser!.uid;
    await _fireStore
        .collection('data')
        .doc(id)
        .collection('note')
        .doc('${note.id}')
        .set(note.toMap());
  }

  Future<void> deleteTask(int? id) async {
    final String uid = _firebaseAuth.currentUser!.uid;
    await _fireStore
        .collection('data')
        .doc(uid)
        .collection('task')
        .doc('${id}')
        .delete();
  }

  Future<void> updateNote(Notes note) async {
    final String id = _firebaseAuth.currentUser!.uid;
    await _fireStore
        .collection('data')
        .doc(id)
        .collection('note')
        .doc('${note.id}')
        .update(note.toMap());
  }

  Future<void> getTask(Tasks task, String type) async {
    final String id = _firebaseAuth.currentUser!.uid;
    await _fireStore
        .collection(type)
        .doc(id)
        .collection(type)
        .add(task.toMap());
  }

  // Check initial connectivity status

  // Subscribe to connectivity changes
  // Connectivity().onConnectivityChanged.listen((result) {
  //   setState(() {
  //     _connectivityResult = result;
  //   });
  // });

  Future<dynamic> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult);
    return connectivityResult;
  }
}
