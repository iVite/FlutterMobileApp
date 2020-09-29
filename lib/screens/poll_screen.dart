import 'dart:async';
import 'package:flutter/material.dart';
import './chat_screen.dart';
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
  var pollLocation;

  void _sendPoll() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('poll').add(
      {
        'pollDate': selectedDate,
        'pollLocation': pollLocation,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.data()['username']
      },
    );
  }

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(
            () {
          selectedDate = picked;
        },
      );
  }

  void selectCategory(BuildContext ctx) {
    _sendPoll();
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return ChatScreen();
        },
      ),
    ); //ctx here is just function input placeholder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Your Poll",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                'Select date',
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 2.0),
                  ),
                  hintText: 'Enter a location',
                ),
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                enableSuggestions: false,
                onChanged: (value) {
                  pollLocation = value;
                  print(pollLocation);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                onPressed: () => {
                  selectCategory(context),
                },
                child: Text('Create Poll!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:polls/polls.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class PollScreen extends StatefulWidget {
//   PollScreen({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   State<StatefulWidget> createState() {
//     return _PollScreenState();
//   }
// }

// //
// class _PollScreenState extends State<PollScreen> {

//   DateTime selectedDate = DateTime.now();

//   double option1 = 1.0;
//   double option2 = 0.0;
//   double option3 = 1.0;

//   // current user email
//   String user = "king@mail.com";

//   //Users who voted Map data
//   Map usersWhoVoted = {
//     'sam@mail.com': 3,
//     'mike@mail.com': 4,
//     'john@mail.com': 1,
//     'kenny@mail.com': 1
//   };

//   //Creator of the polls email
//   String creator = "eddy@mail.com";

//   @override
//   Widget build(BuildContext context) {
//     // final user = FirebaseAuth.instance.currentUser;
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Your Poll",
//               style: TextStyle(
//                 color: Colors.black,
//               )),
//           backgroundColor: Theme.of(context).primaryColor,
//         ),
//         body: Polls(
//           children: [
//             // This cannot be less than 2, else will throw an exception
//             Polls.options(title: 'Yes', value: option1),
//             Polls.options(title: 'No', value: option2),
//             Polls.options(title: 'Maybe', value: option3),
//           ],
//           question: Text('Where is the capital of Egypt?',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//                 color: Colors.black,
//               )),
//           currentUser: this.user,
//           creatorID: this.creator,
//           voteData: usersWhoVoted,
//           userChoice: usersWhoVoted[this.user],
//           onVoteBackgroundColor: Theme.of(context).primaryColor,
//           leadingBackgroundColor: Theme.of(context).primaryColor,
//           backgroundColor: Colors.white,
//           onVote: (choice) {
//             setState(
//               () {
//                 this.usersWhoVoted[this.user] = choice;
//               },
//             );
//             if (choice == 1) {
//               setState(
//                 () {
//                   option1 += 1.0;
//                 },
//               );
//             }
//             if (choice == 2) {
//               setState(
//                 () {
//                   option2 += 1.0;
//                 },
//               );
//             }
//             if (choice == 3) {
//               setState(() {
//                 option3 += 1.0;
//               });
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
