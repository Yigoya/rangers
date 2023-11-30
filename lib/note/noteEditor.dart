import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rangers/db/dbService.dart';
import 'package:rangers/db/note.dart';
import 'package:rangers/note/noteViewer.dart';
import 'package:rangers/service/auth/auth_service.dart';

class NoteEditor extends StatefulWidget {
  final int? id;
  const NoteEditor({super.key, required this.id});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _notecontroller = TextEditingController();
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
  late Notes note;
  final DBService _noteDb = DBService.instance;
  List<Notes> _note = [];
  @override
  void initState() {
    super.initState();
    _getNote(widget.id);
  }

  TextEditingController controller = TextEditingController();
  void _getNote(int? id) async {
    List<Notes> newnote = await _noteDb.fetchOneNote(id);
    // print(newnote[0].toMap());
    setState(() {
      _note = newnote;
    });
  }

  Future<List<Notes>> getNote(int? id) async {
    List<Notes> newnote = await _noteDb.fetchOneNote(id);
    print(newnote[0].toMap());
    return newnote;
  }

  void _updateNote(Notes note) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await _noteDb.updateNote(note);
    List<Notes> newNote = await _noteDb.fetchOneNote(note.id);
    await authService.updateNote(newNote[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
        actions: [
          IconButton(
            onPressed: () {
              note.title = _titlecontroller.text;
              note.note = _notecontroller.text;
              _updateNote(note);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteViewer(id: note.id)),
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
              SizedBox(
                width: 400,
                height: 600,
                child: ListView.builder(
                    itemCount: _note.length,
                    itemBuilder: (context, index) {
                      note = _note[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: TextField(
                              style: TextStyle(fontSize: 30),
                              controller: _titlecontroller
                                ..text = _note[index].title,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(fontSize: 30),
                                  hintStyle: TextStyle(fontSize: 30),
                                  border: InputBorder.none,
                                  hintText: 'Title'),
                            ),
                          ),
                          Text(
                            '${_note[index].day} ${month[_note[index].month]} ${_note[index].year} ${_note[index].hour > 12 ? _note[index].hour - 12 : _note[index].hour}:${_note[index].minute < 10 ? '0${_note[index].minute}' : _note[index].minute} ${_note[index].hour > 12 ? 'PM' : 'AM'} ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 199, 152, 10)),
                          ),
                          Container(
                            child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: _notecontroller
                                  ..text = _note[index].note,
                                decoration: InputDecoration(
                                    labelStyle: TextStyle(fontSize: 17),
                                    hintStyle: TextStyle(fontSize: 17),
                                    border: InputBorder.none,
                                    hintText: 'add your note')),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
