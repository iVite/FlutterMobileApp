import 'dart:io';

import 'package:flutter/material.dart';

import 'package:ivite_flutter/widgets/pickers/user_image_picker.dart';
import 'package:email_validator/email_validator.dart';

//les 317
//manage different input states of users
//stateful widget, need to switch between login and sign up mode and update DUI
class AuthForm extends StatefulWidget {
  //les 320 - add constructor by repeating the classname
  AuthForm(
    this.submitFunction,
    this.isLoading,
  );

  final bool isLoading;

//oh you are define the submitFn function
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
  ) submitFunction;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>(); //_formKey to form to validate
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid =
        _formKey.currentState.validate(); //this triggers all validators in form
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFunction(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
      );
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
      return 'Username must start with an alphbet';
    }
    return null;
  }

  String _validatePassword(String password) {
    if (password == null || password.isEmpty || password.length < 8) {
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
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading) _accountButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
