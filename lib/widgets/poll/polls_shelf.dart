import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PollsShelf extends StatefulWidget {
  @override
  _PollsShelfState createState() => _PollsShelfState();
}

class _PollsShelfState extends State<PollsShelf> {
  var pollData;

  void initState() {
    super.initState(); //
    // fetchPoll();
    print("hi there");
  }

  // void fetchPoll() async {
  //   // FocusScope.of(context).unfocus();/
  //   final user = FirebaseAuth.instance.currentUser;
  //   final pollData = await FirebaseFirestore.instance.collection('poll').get();
  //   print(pollData.data()["pollLocation"]);
  // }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;
    return Container(
      color: Theme.of(context).accentColor,
      height: 100,
      width: double.infinity,
      child: Text(
        "Poll Results Here",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }
}
