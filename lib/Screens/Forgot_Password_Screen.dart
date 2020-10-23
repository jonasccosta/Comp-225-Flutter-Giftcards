import 'package:flutter/material.dart';
import 'package:flutter_app/User_Info.dart';
import 'package:flutter_app/Databases/User_Info_Database.dart';
import '../User_Info.dart';
import 'Login_Screen.dart';

/// Screen in which the user can reset their pin.
class ForgotPasswordScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ForgotPasswordScreenState();
  }
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  void initState() {
    // Retrieves the users that are currently in the database when the user opens the app.
    setUpUserList();
    super.initState();
  }

  /// Stores a list of the current users.
  List<UserInfo> userInfoList = [];

  Color specialGrey = Color.fromRGBO(174, 174, 174, 1.0);

  final TextEditingController _passwordHintAnswerController = new TextEditingController();

  /// Allows variables to be used across the page.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Returns a list that has the User information in it.
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

  /// Updates the list of users when there is a change.
  void setUpUserList() async{
    List<Map<String, dynamic>> _results  = await UserDB.query(UserInfo.table);
    userInfoList = _results.map((item) => UserInfo.fromMap(item)).toList();
    setState(() {    });
  }

  /// Builds the [SecurityQuestion] text box.
  Widget _buildSecurityQuestionTextBox() {
    return Text(
      "Security Question:",
      style: TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.start,
    );
  }

  /// Builds the [SecurityQuestion] that comes from the user.
  Widget _buildSecurityQuestionText(UserInfo info) {
    return Text(
        info.passwordHintQuestion,
        style: TextStyle(fontSize: 18, color: specialGrey), textAlign: TextAlign.start,
    );
  }

  /// Builds the [Password] popup.
  ///
  /// Once the user clicks on the 'What is my pin?' button, this creates
  /// a popup that contains the user's pin.
  _buildYourPasswordPopup(BuildContext context, UserInfo info) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Your Pin is:"),
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

  /// Builds the [SecurityAnswer] TextFormField.
  Widget _buildSecurityAnswerInputField(UserInfo info) {
    return TextFormField(
      style: TextStyle(color: specialGrey),
      maxLength: 10,
      decoration: InputDecoration(
          labelText: 'Security Answer',
          labelStyle: TextStyle(color: specialGrey),

          border: UnderlineInputBorder(
            borderSide: BorderSide(color: specialGrey),
          ),

          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: specialGrey),
          ),

          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: specialGrey),
          ),

          counterStyle: TextStyle(color: specialGrey)
      ),

      controller: _passwordHintAnswerController,
      validator: (String value) {
        // Produces the error if no name is entered.
        if (value.isEmpty) {
          return 'Please enter an answer';
        }

        if (_passwordHintAnswerController.text != info.passwordHintAnswer) {
          return 'Password answer is not correct';
        }

        // Produces no error if a name is provided.
        return null;
      },
    );
  }

  /// Builds the [WhatIsMyPassword] Button.
  ///
  /// Once this button is clicked on, it checks to see if the security answer
  /// that the user put in matches the security answer that is in the database.
  /// If it does match it displays the user's pin in a popup window. If it
  /// doesn't match, it will display an error for the user.
  Widget _buildWhatIsMyPasswordButton() {
    return RaisedButton(
      color: specialGrey,
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
            title: Text("Forgot Pin",
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(32, 32, 48, 1.0)
        ),

        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromRGBO(53, 51, 81, 1.0), Color.fromRGBO(21, 21, 25, 1.0)])
          ),

          child: Container(
              margin: EdgeInsets.all(24),
              child: Form(
                  key: _formKey,

                  // Makes sure the text box that is being filled in is on the page.
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[

                            SizedBox(height: 90),
                            _buildSecurityQuestionTextBox(),

                            SizedBox(height: 20),
                            _buildSecurityQuestionText(userInfoList[0]),

                            SizedBox(height: 20),
                            _buildSecurityAnswerInputField(userInfoList[0]),

                            SizedBox(height: 10),
                            _buildWhatIsMyPasswordButton(),

                          ]
                      )
                  )
              )
          ),
        )
    );
  }
}
