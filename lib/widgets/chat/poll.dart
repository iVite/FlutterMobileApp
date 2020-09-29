import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ivite_flutter/model/poll_data.dart';
import 'package:firebase_auth/firebase_auth.dart';


class PollWidget extends StatefulWidget {
  final String pollId;

  PollWidget({Key key, this.pollId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PollWidgetState(pollId);
  }
}

class _PollWidgetState extends State<PollWidget> {
  final String _pollId;
  final _firebaseFireStore = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;
  static final responseTypes = ["YES", "NO", "MAYBE"];
  PollData _pollData;

  _PollWidgetState(this._pollId);


  final descTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 18,
    height: 3,
  );


  Future<void> submitPollResponse(String pollResponse) async {
    await _firebaseFireStore.collection('polls').doc(_pollId).update(
      {'responses.${_currentUser.email}': pollResponse}
    );
    setState(() {
      _pollData.responses[_currentUser.email] = pollResponse;
    });
  }

  int _getPollResponseCount(String response) {
    var count = 0;
    _pollData.responses.values.forEach((element) {
      if (element == response) {
        count += 1;
      }
    });
    return count;
  }

  void submitYesResponse() async {
    await submitPollResponse("YES");
  }

  void submitNoResponse() async {
    await submitPollResponse("NO");
  }

  void submitMaybeResponse() async {
    await submitPollResponse("MAYBE");
  }




  Widget _titleContainer(String eventName) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Text(
        eventName,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _timeRow(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM d, y, jm');

    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 5, right: 20),
          child: Icon(
            Icons.access_time,
            color: Colors.green,
            size: 18,
          ),
        ),
        Text(formatter.format(date))
      ],
    );
  }


  Widget _locationRow(String location) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 5, right: 20),
          child: Icon(
            Icons.location_on,
            color: Colors.green,
            size: 18,
          ),
        ),
        Text(location)
      ],
    );
  }

  Widget _votingRow() {
    final responseFunctions = {
      "YES": submitYesResponse,
      "NO": submitNoResponse,
      "MAYBE": submitMaybeResponse,
    };

    final buttons = responseTypes.map((r) =>
      OutlineButton(
        child: Text(r),
        textColor: Colors.white,
        color: Colors.lightGreen,
        disabledTextColor: Colors.black87,
        onPressed: _pollData.responses[_currentUser.email] == r ? null: responseFunctions[r],
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
      )
    ).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  Widget responseCountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: responseTypes.map((r) =>
        Text("$r: ${_getPollResponseCount(r)}")
      ).toList(),
    );
  }

  Future<PollData> _getPollData() async{
    final firebasePollData = await _firebaseFireStore.collection('polls').doc(_pollId).get();
    return PollData.fromJson(firebasePollData.data());
  }

  Widget _getMainPollContainer() {
    return DefaultTextStyle.merge(
      style: descTextStyle,
      child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.white38,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _titleContainer(_pollData.eventName),
              _timeRow(_pollData.time),
              _locationRow(_pollData.address),
              _votingRow(),
            ],
          )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _pollData == null ?
        FutureBuilder(
          future: _getPollData(),
          builder: (context, AsyncSnapshot<PollData> pollData) {
            _pollData = pollData.data;
            return _getMainPollContainer();

          }
        ):
        _getMainPollContainer();
  }
}