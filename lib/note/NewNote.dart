import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rangers/db/dbService.dart';
import 'package:rangers/db/note.dart';
import 'package:rangers/note/noteWidget.dart';
import 'package:rangers/service/auth/auth_service.dart';

class NewNote extends StatefulWidget {
  const NewNote({
    super.key,
  });

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final DBService _noteDb = DBService.instance;
  @override
  void initState() {
    super.initState();
  }

  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _notecontroller = TextEditingController();
  DateTime time = DateTime.now();
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

  void _addNote() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    Notes newnote = Notes(
        title: _titlecontroller.text,
        note: _notecontroller.text,
        year: time.year,
        month: time.month,
        day: time.day,
        hour: time.hour,
        minute: time.minute);
    if (_notecontroller.text.isNotEmpty) {
      await _noteDb.insertnote(newnote);
      List<Notes> newNote = await _noteDb.fetchRNote();
      await authService.addNote(newNote[0]);
      _notecontroller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("HOME"),
        actions: [
          IconButton(
            onPressed: () async {
              _addNote();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyNote()),
                  (route) => false);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: TextField(
                      style: TextStyle(fontSize: 30),
                      controller: _titlecontroller,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 30),
                          hintStyle: TextStyle(fontSize: 30),
                          border: InputBorder.none,
                          hintText: 'Title'),
                    ),
                  ),
                  Text(
                    '${time.day} ${month[time.month]} ${time.year} ${time.hour > 12 ? time.hour - 12 : time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute} ${time.hour > 12 ? 'PM' : 'AM'} ',
                    style: TextStyle(color: Color.fromARGB(255, 199, 152, 10)),
                  ),
                  Container(
                    child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _notecontroller,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 17),
                            hintStyle: TextStyle(fontSize: 17),
                            border: InputBorder.none,
                            hintText: 'add your note')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
