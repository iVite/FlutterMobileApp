import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//where you offload the auth forms to another widget
import 'package:ivite_flutter/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  final _firebaseFireStore = FirebaseFirestore.instance;
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
  }

  Future<void> _login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on PlatformException catch (err) {
      var message = 'Invalid password/email';

      if (err.message != null) {
        message = err.message;
      }
      _showErrorMessage(message);

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorMessage(String errMsg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(errMsg),
        backgroundColor: Theme.of(context).errorColor,
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

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        await _login(email, password);
      } else {
        await _createNewUser(email, password, username, image);
      }
    }  catch (err) {
      _showErrorMessage('An error occurred. Please try again');
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
