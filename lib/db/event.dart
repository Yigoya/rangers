class Events {
  int? id;
  String event;
  int day;
  int month;
  int year;
  int hour;
  int endhour;
  int minute;
  int endminute;
  Events({
    this.id,
    required this.event,
    required this.day,
    required this.month,
    required this.year,
    required this.hour,
    required this.endhour,
    required this.minute,
    required this.endminute,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event': event,
      'minute': minute,
      'endminute': endminute,
      'hour': hour,
      'endhour': endhour,
      'day': day,
      'month': month,
      'year': year,
    };
  }

  factory Events.fromMap(Map<String, dynamic> map) {
    return Events(
      id: map['id'],
      event: map['event'],
      day: map['day'],
      month: map['month'],
      year: map['year'],
      hour: map['hour'],
      endhour: map['endhour'],
      minute: map['minute'],
      endminute: map['endminute'],
    );
  }
}
