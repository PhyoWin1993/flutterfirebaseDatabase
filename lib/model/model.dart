import 'package:firebase_database/firebase_database.dart';

class Users {
  String name, email, key;
  Users(this.name, this.email);

  Users.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    name = snapshot.value['name'];
    email = snapshot.value['email'];
  }

  toJson() {
    return {"name": name, "email": email};
  }
}
