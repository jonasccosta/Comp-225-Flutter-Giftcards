import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Home_Screen.dart';
import 'package:flutter_app/User_Info.dart';
import 'package:flutter_app/Databases/User_Info_Database.dart';

import '../User_Info.dart';

class ForgotPasswordScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ForgotPasswordScreenState();
  }
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  void initState() {
    setUpUserList();


    //Retrieves the gift cards that are currently in the database when the user opens the app
    super.initState();
  }

  //Stores a list of the current gift cards
  List<UserInfo> userInfoList = [];

  //Transforms each gift card stored in the database in a button widget
  List<Widget> get userInfoWidgets => userInfoList.map((item) => seeUserInfoButton(item)).toList();

  final TextEditingController _passwordHintAnswerController = new TextEditingController();
  final TextEditingController _passwordHintQuestionController = new TextEditingController();

  // Allows variables to be used across the page.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<List<UserInfo>> getUserInfoList() async {
    final List<Map<String, dynamic>> maps = await UserDB.query(UserInfo.table);

    return List.generate(maps.length, (index) {
      return UserInfo(
        id: maps[index]['id'],
        username: maps[index]['username'],
        password: maps[index]['password'],
        passwordHintQuestion: maps[index]['passwordHintQuestion'],
        passwordHintAnswer: maps[index]['passwordHintAnswer'],

      );
    });
  }

  //Updates the list of gift cards when there is a change
  void setUpUserList() async{
    print('set up check');
    List<Map<String, dynamic>> _results  = await UserDB.query(UserInfo.table);
    userInfoList = _results.map((item) => UserInfo.fromMap(item)).toList();
    setState(() {    });
  }

  Widget seeUserInfoButton(UserInfo info){
    return DefaultTextStyle(
        child: ListTile(
          title: Text(info.username, style: TextStyle(fontSize: 28, color: Colors.black38)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Username: \$' + info.username, style: TextStyle(fontSize: 16, color: Colors.black38),),
            ],
          ),

        )
    );
  }

  Widget _buildPasswordHintQuestionText(UserInfo info) {
    return Text(
        info.passwordHintQuestion
    );
  }

  _buildYourPasswordPopup(BuildContext context, UserInfo info) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Your Password is:"),
      content: Text(info.password),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// Builds the [HintAnswerInput] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_username] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildPasswordHintInputField(UserInfo info) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password Hint Answer'),
      controller: _passwordHintAnswerController,
      validator: (String value) {
        // Produces the error if no name is entered.
        if (value.isEmpty) {
          return 'Please enter an answer';
        }

        if (_passwordHintAnswerController.text != info.passwordHintAnswer) {
          print('text: ' + _passwordHintAnswerController.text);
          print('database answer: ' + info.passwordHintAnswer);
          return 'Password answer is not correct';
        }

        // Produces no error if a name is provided.
        return null;
      },
    );
  }

  /// Builds the [ForgotPasswordScreen] page.
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // Fixes the error that is caused by a pixel overflow.
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,

        appBar: AppBar(
            title: Text("Forgot Password",
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
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

                          _buildPasswordHintQuestionText(userInfoList[0]),
                          SizedBox(height: 20),
                          _buildPasswordHintInputField(userInfoList[0]),
                          SizedBox(height: 10),

                          RaisedButton(
                            elevation: 4,
                            child: Text(
                                'What is my password?',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16
                                )
                            ),

                            // Button clicked action happens here
                            onPressed: () async {
                              // Makes sure all the text boxes have valid information.
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              _buildYourPasswordPopup(context, userInfoList[0]);
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
