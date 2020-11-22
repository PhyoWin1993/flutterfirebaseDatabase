import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firestoresample/main.dart';
import 'package:firestoresample/model/model.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  DatabaseReference userReference;
  DatabaseReference customerreference;
  GlobalKey<FormState> userKey = GlobalKey<FormState>();
  Users users = new Users("", "");
  List<Users> listUsers = List();
  Widget contents;

  var userStre =
      FirebaseDatabase.instance.reference().child("users").once().asStream();

  @override
  void initState() {
    super.initState();
    contents = _userForm();
    userReference = FirebaseDatabase.instance.reference().child("users");
    // userReference.onChildAdded.listen((event) {
    //   _onEntryAdded(event);
    // });

    userReference.onChildAdded.listen(_onEntryAdded);
    userReference.onChildChanged.listen(_onEntryChanged);
    customerreference =
        FirebaseDatabase.instance.reference().child("customers");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu_book),
          onPressed: () {
            var route = MaterialPageRoute(builder: (_) {
              return new MyHomePage();
            });
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: () {
              setState(() {
                if (contents == _showData()) {
                  contents = _userForm();
                } else {
                  contents = _showData();
                }
              });
            },
          )
        ],
        title: Text("FirebaseDatabase (Real Time)"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      // body: _userForm(),

      // body: StreamBuilder(
      //     stream: userStre,
      //     builder: (_, DataS snapshot) {
      //       if (!snapshot.hasData) return CircularProgressIndicator();
      //       return ListView.builder(
      //           itemCount: snapshot.data.length,
      //           itemBuilder: (_, int index) {
      //             return CustomShowFb(snapshot: snapshot.data, index: index);
      //           });
      //     })
      //

      //Fixed Error
      body: contents,
    );
  }

  Widget _userForm() {
    return Column(
      children: [
        Container(
          height: 40,
          alignment: Alignment.center,
          color: Colors.blue[500],
          child: Text(
            "User creation Form",
            style: TextStyle(fontSize: 20.0),
          ),
        )
        //

        ,
        Flexible(
            flex: 0,
            child: Form(
              key: userKey,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  ListTile(
                    leading: Icon(Icons.ac_unit),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: "User Name",
                      ),
                      initialValue: "",
                      onSaved: (val) => users.name = val,
                      validator: (val) {
                        if (val == "") {
                          return "Fill Name";
                        }
                        return null;
                      },
                    ),
                  ),

                  //
                  ListTile(
                    leading: Icon(Icons.ac_unit),
                    title: TextFormField(
                      decoration: InputDecoration(
                        labelText: "E mail",
                      ),
                      initialValue: "",
                      onSaved: (val) => users.email = val,
                      validator: (val) {
                        if (val == "") {
                          return "Fill Name";
                        }
                        return null;
                      },
                    ),
                  ),

                  ListTile(
                      title: FlatButton(
                    onPressed: () {
                      _userSaveHandle();
                    },
                    color: Colors.blueAccent,
                    child: Text("Register"),
                  ))
                ],
              ),
            ))
      ],
    );
  }

  void _userSaveHandle() {
    final FormState curSt = userKey.currentState;
    if (curSt.validate()) {
      curSt.save();
      curSt.reset();

      userReference.push().set(users.toJson());
    }
  }

  Widget _showData() {
    return FirebaseAnimatedList(
      query: userReference,
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int pos) {
        return Column(
          children: [
            Card(
                child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange[400],
              ),
              title: Text(listUsers[pos].name.toString()),
              subtitle: Text(listUsers[pos].key.toString()),
            )),

            //

            FlatButton(
              onPressed: () {
                _deleteCard(listUsers[pos].key);
              },
              child: Text("Delete"),
            ),
            FlatButton(
              onPressed: () {
                _updateData(listUsers[pos].key);
              },
              child: Text("Update"),
            )
          ],
        );
      },
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      listUsers.add(Users.fromSnapshot(event.snapshot));
    });
  }

  void _deleteCard(String delKey) {
    userReference.child(delKey).remove();

    print(delKey);
  }

  void _updateData(String delKey) {
    Users user = Users("Mr .Phyo Win", "mgpyaephyoWin@gmail.com");
    userReference.child(delKey).set(user.toJson());

    print(delKey);
  }

  _onEntryChanged(Event event) {
    var oldEntry = listUsers.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      listUsers[listUsers.indexOf(oldEntry)] =
          Users.fromSnapshot(event.snapshot);
    });
  }
}
