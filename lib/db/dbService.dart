import 'package:rangers/db/event.dart';
import 'package:rangers/db/groups.dart';
import 'package:rangers/db/note.dart';
import 'package:rangers/db/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:rangers/db/user.dart';

class DBService {
  static const _databaseName = 'render.db';
  static const _databaseVersion = 1;

  DBService._privateConstructor();
  static final DBService instance = DBService._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    String event = '''
            CREATE TABLE event(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              event TEXT,
              day int,
              month int,
              year int,
              hour int,
              endhour int,
              minute int,
              endminute int
            )
          ''';
    await db.execute(event);
    String user = '''
            CREATE TABLE user(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              email TEXT,
              password TEXT,
              picimage TEXT
            )
          ''';
    await db.execute(user);
    String groups = '''
            CREATE TABLE groups(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              groups TEXT,
              num int,
              icon Text
            )
          ''';
    await db.execute(groups);
    String note = '''
            CREATE TABLE note(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              note TEXT,
              day int,
              month int,
              year int,
              hour int,
              minute int
            )
          ''';
    await db.execute(note);
    String tasks = '''
            CREATE TABLE tasks(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              task TEXT,
              desc TEXT,
              groupid INTEGER,
              is_completed INTEGER,
              FOREIGN KEY (groupid) REFERENCES groups(id) ON DELETE CASCADE
            )
          ''';
    await db.execute(tasks);
  }

  Future<List<Users>> getUser() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db.query('user');
    return users.map((user) => Users.fromMap(user)).toList();
  }

  Future<int> addUser(Users user) async {
    Database db = await instance.database;
    return await db.insert('user', user.toMap());
  }

  Future<int> deleteUser() async {
    Database db = await instance.database;
    return await db.delete('user');
  }

  Future<List<Groups>> fetchGroup() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> groups = await db.query('groups');
    return groups.map((group) => Groups.fromMap(group)).toList();
  }

  Future<int> insertGroup(Groups group) async {
    Database db = await instance.database;
    return await db.insert('groups', group.toMap());
  }

  Future<int> insertEvent(Events Event) async {
    Database db = await instance.database;
    return await db.insert('event', Event.toMap());
  }

  Future<List<Events>> fetchDayEvent(int day) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> events =
        await db.query('event', where: 'day = ?', whereArgs: [day]);
    return events.map((Event) => Events.fromMap(Event)).toList();
  }

  Future<List<Events>> fetchEvent() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> events = await db.query('event');
    return events.map((Event) => Events.fromMap(Event)).toList();
  }

  Future<List<Events>> fetchREvent() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> events =
        await db.query('event', orderBy: 'id DESC', limit: 1);
    return events.map((Event) => Events.fromMap(Event)).toList();
  }

  Future<int> updateEvent(Events Event) async {
    Database db = await instance.database;
    return await db
        .update('event', Event.toMap(), where: 'id = ?', whereArgs: [Event.id]);
  }

  Future<int> daleteEvent(int id) async {
    Database db = await instance.database;
    return await db.delete('event', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertTask(Tasks task) async {
    Database db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Tasks>> fetchTask() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> tasks = await db.query('tasks');
    return tasks.map((task) => Tasks.fromMap(task)).toList();
  }

  Future<List<Tasks>> fetchOneTask() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> tasks =
        await db.query('tasks', orderBy: 'id DESC', limit: 1);
    return tasks.map((task) => Tasks.fromMap(task)).toList();
  }

  Future<List<Tasks>> fetchGroupTask(int? id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> tasks = await db.query('tasks',
        where: 'groupid = ?', whereArgs: [id], orderBy: 'id DESC');
    return tasks.map((task) => Tasks.fromMap(task)).toList();
  }

  Future<int> updateTask(Tasks task) async {
    Database db = await instance.database;
    return await db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int? id) async {
    Database db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertnote(Notes note) async {
    Database db = await instance.database;
    return await db.insert('note', note.toMap());
  }

  Future<List<Notes>> fetchnote() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> notes =
        await db.query('note', orderBy: 'id DESC');
    return notes.map((note) => Notes.fromMap(note)).toList();
  }

  Future<List<Notes>> fetchRNote() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> notes =
        await db.query('note', orderBy: 'id DESC', limit: 1);
    return notes.map((note) => Notes.fromMap(note)).toList();
  }

  Future<List<Notes>> fetchOneNote(int? id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> notes =
        await db.query('note', where: 'id = ?', whereArgs: [id]);
    return notes.map((note) => Notes.fromMap(note)).toList();
  }

  Future<int> updateNote(Notes note) async {
    Database db = await instance.database;
    return await db
        .update('note', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    Database db = await instance.database;
    return await db.delete('note', where: 'id = ?', whereArgs: [id]);
  }
}
