import 'package:flutter/material.dart';
import 'package:rangers/db/dbService.dart';
import 'package:rangers/db/note.dart';
import 'package:rangers/main.dart';
import 'package:rangers/note/noteEditor.dart';
import 'package:rangers/note/noteWidget.dart';

class NoteViewer extends StatefulWidget {
  final int? id;
  const NoteViewer({super.key, required this.id});

  @override
  State<NoteViewer> createState() => _NoteViewerState();
}

class _NoteViewerState extends State<NoteViewer> {
  final DBService _noteDb = DBService.instance;
  List<Notes> _note = [];
  @override
  void initState() {
    super.initState();
    _getNote(widget.id);
  }

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
  int? id;
  void _getNote(int? id) async {
    List<Notes> newnote = await _noteDb.fetchOneNote(id);
    setState(() {
      _note = newnote;
    });
  }

  Future<List<Notes>> getNote(int? id) async {
    List<Notes> newnote = await _noteDb.fetchOneNote(id);
    print(newnote[0].toMap());
    return newnote;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyNote()),
                  (route) => false);
            },
            icon: Icon(Icons.arrow_circle_left_outlined)),
        title: const Text("HOME"),
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
                      id = _note[index].id;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                _note[index].title,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.7)),
                              )),
                          Text(
                            '${_note[index].day} ${month[_note[index].month]} ${_note[index].year} ${_note[index].hour > 12 ? _note[index].hour - 12 : _note[index].hour}:${_note[index].minute < 10 ? '0${_note[index].minute}' : _note[index].minute} ${_note[index].hour > 12 ? 'PM' : 'AM'} ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 199, 152, 10)),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(_note[index].note,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.7)))),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => NoteEditor(id: id)));
          },
          icon: const Icon(Icons.edit)),
    );
  }
}
