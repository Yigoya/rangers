class Users {
  int? id;
  String name;
  String email;
  String password;
  String? picimage;
  Users(
      {this.id,
      required this.name,
      this.picimage,
      required this.email,
      required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'is_completed': picimage,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        password: map['password'],
        picimage: map['picimage']);
  }
}
