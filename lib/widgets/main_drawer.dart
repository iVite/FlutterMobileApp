import 'dart:ui';

import 'package:flutter/material.dart';
import "../screens/poll_screen.dart";

class MainDrawer extends StatelessWidget {
  //passed props down from chat screen to poll screen
  // final pollLocation;
  // final pollDate;
  // final createdPoll;/

  // MainDrawer(this.pollLocation, this.pollDate, this.createdPoll);

  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(builder: (_) {
        return PollScreen();
      }),
    ); //ctx here is just function input placeholder
  }

  //builder method
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            child: Text(
              'Navigation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile(
              'Create a Poll', Icons.poll, () => selectCategory(context)),
          buildListTile('Settings', Icons.settings, () {}),
        ],
      ),
    );
  }
}
