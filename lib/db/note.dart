class Notes {
  int? id;
  String title;
  String note;
  int day;
  int month;
  int year;
  int hour;
  int minute;
  Notes(
      {this.id,
      required this.title,
      required this.note,
      required this.day,
      required this.month,
      required this.year,
      required this.hour,
      required this.minute});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'minute': minute,
      'hour': hour,
      'day': day,
      'month': month,
      'year': year,
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      day: map['day'],
      month: map['month'],
      year: map['year'],
      hour: map['hour'],
      minute: map['minute'],
    );
  }
}
