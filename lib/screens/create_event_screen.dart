import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ivite_flutter/model/chat_message.dart';
import 'package:ivite_flutter/model/poll_data.dart';


class CreateEventScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateEventScreenState();
  }
}



class _CreateEventScreenState extends State<CreateEventScreen> {

  String _eventName;
  String _eventAddress;
  DateTime _eventTime = DateTime.now();

  final _currentUser = FirebaseAuth.instance.currentUser;
  final _firebaseFireStore = FirebaseFirestore.instance;

  static final DateFormat dateFormatter = DateFormat('MMMM d, y, jm');

  final descTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 18,
    height: 3,
  );


  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _eventTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != _eventTime)
      setState(() {
        _eventTime = picked;
      });
  }


  Future<void> _submitEvent() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();


    final pollData = PollData(_eventName, _eventTime, _eventAddress, {});

    // create poll
    DocumentReference docReference = await FirebaseFirestore.instance.collection('polls').add(
      pollData.toJson()
    );

    // send poll as a chat message
    FirebaseFirestore.instance.collection('chat').add({
      'message': ChatMessage(MessageType.poll, docReference.id).toJson(),
      'createdAt': Timestamp.now(),
      'userId': _currentUser,
      'username': userData.data()['username'],
      'userImage': userData.data()['image_url']
    });
  }

  Widget _eventNameField() {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            Text('Event Name:  '),
            TextFormField(
              key: ValueKey('event_name'),
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Enter event name'),
              onSaved: (value) {
                _eventName = value;
              },
            )
          ],
        ),
      );
  }

  Widget _locationField() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Text('Location:  '),
          TextFormField(
            key: ValueKey('location'),
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(labelText: 'location'),
            onSaved: (value) {
              _eventAddress = value;
            },
          )
        ],
      ),
    );
  }


  Widget _timeField() {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            Text("Time: "),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dateFormatter.format(_eventTime)),
                SizedBox(height: 10),
                RaisedButton(
                  onPressed: () => _selectDate(),
                  child: Text("Select Date"),
                  color: Colors.lightGreen,
                )
              ],
            )
          ],
        )
    );
  }


  Widget _submitEventButton() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child:
        RaisedButton(
          child: Text("Submit"),
          textColor: Colors.white,
          color: Colors.lightGreen,
          disabledColor: Colors.black,
          onPressed: () => {
          },
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
        style: descTextStyle,
        child: Container(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Create Event"),
              _eventNameField(),
              _locationField(),
              _timeField(),
              _submitEventButton()
            ],
          ),
        ));
  }
}