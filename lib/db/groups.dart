class Groups {
  int? id;
  String groups;
  String icon;
  int num;
  Groups({this.id, required this.groups, required this.icon, this.num = 0});

  Map<String, dynamic> toMap() {
    return {'id': id, 'groups': groups, 'icon': icon, 'num': num};
  }

  factory Groups.fromMap(Map<String, dynamic> map) {
    return Groups(
        id: map['id'],
        groups: map['groups'],
        icon: map['icon'],
        num: map['num']);
  }
}
