import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//where you offload the auth forms to another widget
import 'package:ivite_flutter/widgets/auth/auth_form.dart';
import 'package:logger/logger.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  final _firebaseFireStore = FirebaseFirestore.instance;
  final Logger LOGGER = Logger();
  var _isLoading = false;


  Future<void> _createNewUser(String email, String password, String username, File image) async {
    UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );

    var imageUrl = '';

    if (image != null) {
      final imageRef = _firebaseStorage
          .ref()
          .child('user_image')
          .child('${authResult.user.uid}.jpg');
      await imageRef.putFile(image).onComplete;
      imageUrl = await imageRef.getDownloadURL();
    }

    await _firebaseFireStore
      .collection('users')
      .doc(authResult.user.uid)
      .set({
        'username': username,
        'email': email,
        'image_url': imageUrl.isEmpty ? null : imageUrl,
      });
      // .catchError((err) {
      //   _showErrorMessage('An error occurred. Please try again');
      // });
  }

  Future<void> _login(String email, String password) async {
    void handleLoginError(PlatformException e) {
      var message = 'Invalid password/email';

      if (e.message != null) {
        message = e.message;
      }
      _showErrorMessage(message);
    }

    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    //.catchError(handleLoginError, test: (e) => e is PlatformException);
  }

  void _showErrorMessage(String errMsg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(errMsg),
        backgroundColor: Theme.of(context).errorColor,
        duration: Duration(seconds: 5),
      ),
    );
  }

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (isLogin) {
        await _login(email, password);
      } else {
        await _createNewUser(email, password, username, image);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      //styling
      body: AuthForm(
        _submitAuthForm, //passing the function down
        _isLoading,
      ),
    );
  }
}
