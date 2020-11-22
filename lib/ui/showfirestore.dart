import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CustomShowFb extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;

  const CustomShowFb({Key key, this.snapshot, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          child: Text('T'),
        ),
      ),
    );
  }
}
