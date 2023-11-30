import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rangers/component/form.dart';
import 'package:rangers/db/dbService.dart';
import 'package:rangers/db/note.dart';
import 'package:rangers/main.dart';
import 'package:rangers/note/NewNote.dart';
import 'package:rangers/note/noteViewer.dart';

class MyNote extends StatefulWidget {
  const MyNote({super.key});

  @override
  State<MyNote> createState() => _MyNoteState();
}

class _MyNoteState extends State<MyNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final DBService _noteDb = DBService.instance;
  List<Color> colors = [
    Colors.amber.shade100,
    Colors.purple.shade100,
    Colors.blue.shade100,
    Colors.red.shade100,
    Colors.grey.shade100
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
  int getRandomInteger() {
    final random = Random();
    return random.nextInt(colors.length);
  }

  List<Notes> _notes = [];
  DateTime time = DateTime.now();
  @override
  void initState() {
    super.initState();
    _refreshNoteList();
  }

  void _refreshNoteList() async {
    List<Notes> notes = await _noteDb.fetchnote();
    setState(() {
      _notes = notes;
    });
  }

  void _addNote() async {
    String noteName = _noteController.text;
    if (noteName.isNotEmpty) {
      Notes newnote = Notes(
          title: _titleController.text,
          note: _noteController.text,
          year: time.year,
          month: time.month,
          day: time.day,
          hour: time.hour,
          minute: time.minute);
      await _noteDb.insertnote(newnote);
      _refreshNoteList();
      _noteController.clear();
    }
  }

  void _updateNote(Notes note) async {
    await _noteDb.updateNote(note);
    _refreshNoteList();
  }

  void _deleteNote(int? noteId) async {
    await _noteDb.deleteNote(noteId!);
    _refreshNoteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyHome()),
                  (route) => false);
            },
            icon: Icon(Icons.arrow_circle_left_outlined)),
        centerTitle: true,
        title: Text("Notes",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 25,
                color: Colors.black.withOpacity(0.7))),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              searchBar('search your notes'),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 400,
                height: 575,
                child: ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NoteViewer(id: _notes[index].id)));
                          },
                          child: Container(
                              height: 100,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: colors[getRandomInteger()]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(_notes[index].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,
                                          color:
                                              Colors.black.withOpacity(0.7))),
                                  Text(
                                      _notes[index].note.length > 30
                                          ? _notes[index].note.substring(0, 30)
                                          : _notes[index].note,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          color:
                                              Colors.black.withOpacity(0.4))),
                                  Text(
                                      '${_notes[index].day} ${month[_notes[index].month]} ${_notes[index].year} ${_notes[index].hour > 12 ? _notes[index].hour - 12 : _notes[index].hour}:${_notes[index].minute < 10 ? '0${_notes[index].minute}' : _notes[index].minute} ${_notes[index].hour > 12 ? 'PM' : 'AM'} '),
                                ],
                              )));
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NewNote()));
          },
          icon: const Icon(Icons.add)),
    );
  }
}
