import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:rangers/Todo/group.dart';
import 'package:rangers/Todo/todoTimeline.dart';
import 'package:rangers/calander/calander.dart';
import 'package:rangers/db/dbService.dart';
import 'package:rangers/downloadAndSave.dart';
import 'package:rangers/firebase_options.dart';
import 'package:rangers/homepage.dart';
import 'package:rangers/mediaplayer.dart';
import 'package:rangers/note/noteWidget.dart';
import 'package:rangers/service/auth/auth_gete.dart';
import 'package:rangers/service/auth/auth_service.dart';
import 'package:rangers/service/recovery.dart';
import 'package:rangers/timer/timer.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

DBService dbService = DBService.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dbService.database;
  await FirebaseAppCheck.instance.activate();
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({
    super.key,
  });

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final List<Widget> _pages = [
    const HomePage(),
    const Calender(),
    const MyGroup(),
    const MyNote(),
    const DownloadAndSaveFile()
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_index]),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              padding: const EdgeInsets.all(16),
              onTabChange: (value) {
                setState(() {
                  _index = value;
                });
              },
              gap: 8,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'today',
                ),
                GButton(
                  icon: Icons.calendar_month,
                  text: 'calender',
                ),
                GButton(
                  icon: Icons.add_task_rounded,
                  text: 'task',
                ),
                GButton(
                  icon: Icons.note_alt_rounded,
                  text: 'notes',
                ),
                GButton(
                  icon: Icons.timer,
                  text: 'timer',
                )
              ]),
        ),
      ),
    );
  }
}
