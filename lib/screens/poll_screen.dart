import 'package:flutter/material.dart';
import 'package:polls/polls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PollScreen extends StatefulWidget {
  PollScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _PollScreenState();
  }
}

//
class _PollScreenState extends State<PollScreen> {
  double option1 = 2.0;
  double option2 = 0.0;
  double option3 = 2.0;
  double option4 = 3.0;
  // current user email
  String user = "king@mail.com";

  //Users who voted Map data
  Map usersWhoVoted = {
    'sam@mail.com': 3,
    'mike@mail.com': 4,
    'john@mail.com': 1,
    'kenny@mail.com': 1
  };

  //Creator of the polls email
  String creator = "eddy@mail.com";

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("My First App"),
            ),
            body: Polls(
              children: [
                // This cannot be less than 2, else will throw an exception
                Polls.options(title: 'Cairo', value: option1),
                Polls.options(title: 'Mecca', value: option2),
                Polls.options(title: 'Denmark', value: option3),
                Polls.options(title: 'Mogadishu', value: option4),
              ],
              question: Text('Where is the capital of Egypt?'),
              currentUser: this.user,
              creatorID: this.creator,
              voteData: usersWhoVoted,
              userChoice: usersWhoVoted[this.user],
              onVoteBackgroundColor: Colors.blue,
              leadingBackgroundColor: Colors.blue,
              backgroundColor: Colors.white,
              onVote: (choice) {
                setState(() {
                  this.usersWhoVoted[this.user] = choice;
                });
                if (choice == 1) {
                  setState(() {
                    option1 += 1.0;
                  });
                }
                if (choice == 2) {
                  setState(() {
                    option2 += 1.0;
                  });
                }
                if (choice == 3) {
                  setState(() {
                    option3 += 1.0;
                  });
                }
                if (choice == 4) {
                  setState(() {
                    option4 += 1.0;
                  });
                }
              },
            )));
  }
}
