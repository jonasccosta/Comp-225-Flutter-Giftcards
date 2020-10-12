import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Home_Screen.dart';
import 'package:flutter_app/User_Info.dart';
import 'package:flutter_app/Databases/User_Info_Database.dart';

class AddAccountScreen extends StatefulWidget {
  final UserInfo userInfo;

  AddAccountScreen([this.userInfo]);

  @override
  State<StatefulWidget> createState() {
    return AddAccountScreenState();
  }
}

class AddAccountScreenState extends State<AddAccountScreen> {
  UserInfo userInfo;

  AddAccountScreenState([this.userInfo]);

  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();

  final TextEditingController _passwordHintController = new TextEditingController();
  final TextEditingController _confirmPasswordHintController = new TextEditingController();


  // The Names of the variables that the user inputs.
  String _username;
  String _password;
  String _confirmPassword;
  String _passwordHintQuestion;
  String _passwordHintAnswer;
  String _confirmPasswordAnswer;

  // Allows variables to be used across the page.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Builds the [Username] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_username] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildUsernameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Username'),
      validator: (String value) {
        // Produces the error if no name is entered.
        if(value.isEmpty) {
          return 'Username is Required';
        }
        // Produces no error if a name is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _username = value;
      },
    );
  }

  /// Builds the [Password] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_username] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      controller: _passwordController,
      validator: (String value) {
        // Produces the error if no name is entered.
        if(value.isEmpty) {
          return 'Password is Required';
        }
        // Produces no error if a name is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  /// Builds the [Confirm_Password] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_username] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Confirm Password'),
      obscureText: true,
      controller: _confirmPasswordController,
      validator: (String value) {
        // Produces the error if no name is entered.
        if(value.isEmpty) {
          return 'Empty';
        }
        if(_confirmPasswordController.text != _passwordController.text) {
          return 'Password does not match';
        }

        // Produces no error if a name is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _confirmPassword = value;
      },
    );
  }

  /// Builds the [Password_Hint_Question] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_username] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildPasswordHintQuestionField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password Hint Question'),
      validator: (String value) {
        // Produces the error if no name is entered.
        if(value.isEmpty) {
          return 'Please enter a password hint';
        }
        // Produces no error if a name is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _passwordHintQuestion = value;
      },
    );
  }

  /// Builds the [Password_Hint] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_username] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildPasswordHintField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password Hint'),
      controller: _passwordHintController,
      validator: (String value) {
        // Produces the error if no name is entered.
        if(value.isEmpty) {
          return 'Please enter a password hint';
        }
        // Produces no error if a name is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _passwordHintAnswer = value;
      },
    );
  }

  /// Builds the [Confirm_Password_Hint] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_username] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildConfirmPasswordHintField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Confirm Password Hint'),
      controller: _confirmPasswordHintController,
      validator: (String value) {
        // Produces the error if no name is entered.
        if(value.isEmpty) {
          return 'Password hint does not match';
        }
        if(_passwordHintController.text != _confirmPasswordHintController.text) {
          return 'Password does not match';
        }
        // Produces no error if a name is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _confirmPasswordAnswer = value;
      },
    );
  }

  /// Builds the [AddAccountScreen] page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fixes the error that is caused by a pixel overflow.
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
          title: Text("Add Account", style: TextStyle(color: Colors.white, fontSize: 20.0)),
          centerTitle: true,
          backgroundColor: Colors.blue
      ),

        body: Container(
            margin: EdgeInsets.all(24),
            child: Form(
                key: _formKey,

                // Makes sure the text box that is being filled in is on the page.
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // The 'SizedBox's create more space between the text fields.
                          _buildUsernameField(),
                          SizedBox(height: 10),

                          _buildPasswordField(),
                          SizedBox(height: 10),

                          _buildConfirmPasswordField(),
                          SizedBox(height: 10),

                          _buildPasswordHintQuestionField(),
                          SizedBox(height: 10),

                          _buildPasswordHintField(),
                          SizedBox(height: 10),

                          _buildConfirmPasswordHintField(),
                          SizedBox(height: 10),

                          RaisedButton(
                            elevation: 4,
                            child:Text(
                                'Create Account',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16
                                )
                            ),

                            // Button clicked action happens here/
                            onPressed: () async {

                              // Makes sure all the text boxes have valid information.
                              if(!_formKey.currentState.validate()){
                                return;
                              }

                              // Triggers all of the 'value' variables to be saved in
                              // their respective new variables.
                              _formKey.currentState.save();

                              // Currently prints out the stored data, but this is where
                              // the data can be saved to a file.
                              print(_username);
                              print(_password);
                              print(_confirmPassword);
                              print(_passwordHintQuestion);
                              print(_passwordHintAnswer);
                              print(_confirmPasswordAnswer);

                              UserInfo userInfo = UserInfo(
                                  username: _username,
                                  password: _password,
                                  passwordHintQuestion: _passwordHintQuestion,
                                  passwordHintAnswer: _passwordHintAnswer);

                              if (userInfo != null) {
                                await UserDB.insert(UserInfo.table, userInfo);
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()));
                              },
                          )
                        ]
                    )
                )
            )
        )
    );
  }
}
