import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_format/date_format.dart';
import 'package:ivite_flutter/model/chat_message.dart';
import 'package:ivite_flutter/model/poll_data.dart';


class CreateEventWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateEventWidgetState();
  }
}



class _CreateEventWidgetState extends State<CreateEventWidget> {

  String _eventName;
  String _eventAddress;
  DateTime _eventTime = DateTime.now();

  final _formKey = GlobalKey<FormState>(); //_formKey to form to validate

  final _currentUser = FirebaseAuth.instance.currentUser;
  final _firebaseFireStore = FirebaseFirestore.instance;

  final descTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 18,
    height: 5,
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


  void _submitEvent() async {
    _formKey.currentState.save();

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();


    final pollData = PollData(_eventName, _eventTime, _eventAddress, {});

    // create poll
    DocumentReference docReference = await _firebaseFireStore.collection('polls').add(
        pollData.toJson()
    );

    // send poll as a chat message
    await _firebaseFireStore.collection('chat').add({
      'message': ChatMessage(MessageType.poll, docReference.id).toJson(),
      'createdAt': Timestamp.now(),
      'userId': _currentUser.uid,
      'username': userData.data()['username'],
      'userImage': userData.data()['image_url']
    });

    Navigator.pop(context);
  }

  Widget _eventNameField() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
          key: ValueKey('event_name'),
          autocorrect: true,
          enableSuggestions: true,
          decoration: InputDecoration(labelText: 'Event Name'),
          onSaved: (value) {
            _eventName = value;
        },
      )
    );
  }

  Widget _locationField() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: TextFormField(
          key: ValueKey('location'),
          autocorrect: true,
          enableSuggestions: true,
          decoration: InputDecoration(labelText: 'Location'),
          onSaved: (value) {
            _eventAddress = value;
          },
        )
    );
  }


  Widget _timeField() {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Text("Time: "),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(formatDate(_eventTime, [M, ' ', d, ',', yyyy, ' ', HH, ':', nn])),
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
        onPressed: _submitEvent,
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
        style: descTextStyle,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
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
          ),
        ));
  }
}