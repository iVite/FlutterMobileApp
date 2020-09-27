import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ivite_flutter/widgets/pickers/user_image_picker.dart';
import 'package:email_validator/email_validator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>(); //_formKey to form to validate
  var _isLogin = true;
  var _isDoingAuth = false;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  final _firebaseFireStore = FirebaseFirestore.instance;


  void _showSnackBar(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
        duration: Duration(seconds: 5),
      ),
    );
  }
  
  Future<void> _createNewUser(String email, String password, String username, File image) async {
    UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).catchError((err) => _showSnackBar('An error occurred: $err'));

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
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )
    .catchError((err) => _showSnackBar('An error occurred: $err'));
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() async{
    final isValid =
        _formKey.currentState.validate(); //this triggers all validators in form
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        _isDoingAuth = true;
      });

      try {
        if (_isLogin) {
          await _login(_userEmail, _userPassword);
        } else {
          await _createNewUser(
              _userEmail, _userPassword, _userName, _userImageFile);
        }
      } finally {
        setState(() {
          _isDoingAuth = false;
        });
      }

    }
  }

  String _validateEmail(String email) {
    if (email == null || email.isEmpty || !EmailValidator.validate(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
  
  String _validateUsername(String username) {
    if (username == null ||  username.isEmpty || username.length < 4) {
      return 'Please enter at least 4 characters';
    }
    if (username.startsWith(RegExp(r'[A-Z][a-z]'))) {
      return 'Username must start with an alphabet';
    }
    return null;
  }

  String _validatePassword(String password) {
    if (!_isLogin && (password == null || password.isEmpty || password.length < 8)) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  Widget _emailField() {
    return TextFormField(
      key: ValueKey('email'), //ValueKey is needed for flutter to identify values next to each other
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      enableSuggestions: false,
      validator: _validateEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email address',
      ),
      onSaved: (value) {
        _userEmail = value;
      },
    );
  }

  
  Widget _usernameField() {
    return TextFormField(
      key: ValueKey('username'),
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
      enableSuggestions: false,
      validator: _validateUsername,
      decoration: InputDecoration(labelText: 'Username'),
      onSaved: (value) {
        _userName = value;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      key: ValueKey('password'),
      validator: _validatePassword,
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true, //hide text
      onSaved: (value) {
        _userPassword = value;
      },
    );
  }

  Widget _accountButton() {
    return FlatButton(
      //below allows you to inherit the primaryColor of the screen
      textColor: Theme.of(context).primaryColor,
      child: Text(_isLogin
          ? 'Create new account'
          : 'I already have an account'),
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              //you can trigger all the validator at the same time bc of Form
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  _emailField(),
                  if (!_isLogin) _usernameField(),
                  _passwordField(),
                  SizedBox(height: 12),
                  if (_isDoingAuth) CircularProgressIndicator(),
                  if (!_isDoingAuth)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      onPressed: _trySubmit,
                    ),
                  if (!_isDoingAuth) _accountButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }




}
