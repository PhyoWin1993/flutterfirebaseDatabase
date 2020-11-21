import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestoresample/ui/card.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(new MaterialApp(
    home: new MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameInputCtrl;
  TextEditingController titleInputCtrl;
  TextEditingController desInputCtrl;

  @override
  void initState() {
    super.initState();
    nameInputCtrl = new TextEditingController();
    titleInputCtrl = new TextEditingController();
    desInputCtrl = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var reference = FirebaseFirestore.instance
        .collection("board")
        .snapshots(); // get stream data for snapshots

    return new Scaffold(
      appBar: new AppBar(
        title: Text("My Firebase Store"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDiaload(context);
        },
        child: Icon(Icons.edit),
      ),
      body: StreamBuilder(
          stream: reference,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, int index) {
                  return CustomCard(snapshot: snapshot.data, index: index);
                });
          }),
    );
  }

  void _showDiaload(BuildContext context) async {
    await showDialog(
        context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.all(10),
          content: Column(
            children: [
              Text("Fill Out This Form"),

              //
              Expanded(
                child: TextField(
                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Your Name",
                  ),
                  controller: nameInputCtrl,
                ),
              ),

              //
              Expanded(
                child: TextField(
                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Title",
                  ),
                  controller: titleInputCtrl,
                ),
              ),

              //
              Expanded(
                child: TextField(
                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                  controller: desInputCtrl,
                ),
              )
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () {
                nameInputCtrl.clear();
                titleInputCtrl.clear();
                desInputCtrl.clear();
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            FlatButton(
              onPressed: () {
                if (nameInputCtrl.text.isNotEmpty &&
                    titleInputCtrl.text.isNotEmpty &&
                    desInputCtrl.text.isNotEmpty) {
                  FirebaseFirestore.instance.collection("board").add({
                    "name": nameInputCtrl.text,
                    "title": titleInputCtrl.text,
                    "description": desInputCtrl.text,
                    "timestm": new DateTime.now()
                  }).then((value) {
                    print("Value is ==> ${value.id}");
                  }).catchError((error) => print("Failed to add user: $error"));
                  nameInputCtrl.clear();
                  titleInputCtrl.clear();
                  desInputCtrl.clear();
                  Navigator.pop(context);
                } else {
                  print("edit field");
                }
              },
              child: Text("Save"),
            )
          ],
        ));
  }
}
