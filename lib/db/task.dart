class Tasks {
  int? id;
  String task;
  String desc;
  int? groupid;
  bool isComplated;
  Tasks(
      {this.id,
      required this.task,
      this.isComplated = false,
      required this.desc,
      required this.groupid});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'desc': desc,
      'groupid': groupid,
      'is_completed': isComplated ? 1 : 0,
    };
  }

  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
        id: map['id'],
        task: map['task'],
        desc: map['desc'],
        groupid: map['groupid'],
        isComplated: map['is_completed'] == 1);
  }
}
