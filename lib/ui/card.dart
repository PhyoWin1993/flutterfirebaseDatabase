import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;

  const CustomCard({Key key, this.snapshot, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // var timeToDate = new DateTime.fromMillisecondsSinceEpoch(
    //     snapshot.docs[index].data()['timestm']);
    // var formatD = new DateFormat("EEE, MM d, y").format(timeToDate);
    // var timeToDate = new DateTime.fromMicrosecondsSinceEpoch(
    //     snapshot.docs[index].data()['timestm'].seconds * 1000);
    DateTime dt = new DateTime.fromMillisecondsSinceEpoch(
        snapshot.docs[index].data()['timestm'].seconds * 1000);
    var formatD = new DateFormat('EEE, MMM d').format(dt);

    var snapshotdata = snapshot.docs[index].data();
    var nameInputCtrl = new TextEditingController(text: snapshotdata['name']);
    var titleInputCtrl = new TextEditingController(text: snapshotdata['title']);
    var desInputCtrl =
        new TextEditingController(text: snapshotdata['description']);

    var docId = snapshot.docs[index].id;
    return Column(
      children: [
        Container(
          height: 160,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.blueAccent, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            color: Colors.white,
            elevation: 10,
            child: Column(
              children: [
                ListTile(
                  title: Text(snapshotdata['title']),
                  subtitle: Text(snapshotdata['description']),
                  leading: CircleAvatar(
                    radius: 22,
                    child: Text(snapshotdata['title'][0]),
                  ),
                ),

                //

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("By : ${snapshotdata['name']}"),
                      Text((formatD == null) ? "" : formatD.toString()),
                    ],
                  ),
                ),
                // Text((snapshot.docs[index].data()['timestm'] == null)
                //     ? ""
                //     : (snapshot.docs[index].data()['timestm']).toString()),

                //

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.blue,
                      ),
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            child: AlertDialog(
                              content: Column(
                                children: [
                                  // add dialog

                                  Text("Fill Update Form"),

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
                                  // add idalog
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
                                      FirebaseFirestore.instance
                                          .collection("board")
                                          .doc(docId)
                                          .update({
                                        "name": nameInputCtrl.text,
                                        "title": titleInputCtrl.text,
                                        "description": desInputCtrl.text,
                                        "timestm": new DateTime.now()
                                      });
                                      // FirebaseFirestore.instance
                                      //     .collection("board")
                                      //     .add({
                                      //   "name": nameInputCtrl.text,
                                      //   "title": titleInputCtrl.text,
                                      //   "description": desInputCtrl.text,
                                      //   "timestm": new DateTime.now()
                                      // }).then((value) {
                                      //   print("Value is ==> ${value.id}");
                                      // }).catchError((error) => print(
                                      //         "Failed to add user: $error"));
                                      nameInputCtrl.clear();
                                      titleInputCtrl.clear();
                                      desInputCtrl.clear();
                                      Navigator.pop(context);
                                    } else {
                                      print("edit field");
                                    }
                                  },
                                  child: Text("Update"),
                                )
                              ],
                            ));
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 16,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        print(docId.toString());
                        await FirebaseFirestore.instance
                            .collection("board")
                            .doc(docId)
                            .delete();
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
