import 'dart:async';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Screens/Home_Screen.dart';
import 'package:flutter_app/Screens/Forgot_Password_Screen.dart';
import 'package:flutter_app/User_Info.dart';
import 'package:flutter_app/Databases/User_Info_Database.dart';
import 'package:flutter_app/Screens/Add_Account_Screen.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import '../User_Info.dart';
import 'package:passcode_screen/passcode_screen.dart';

/// Screen in which the user logs in the app.
class LoginScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  
  @override
  void initState() {

    /// Retrieves the users that are currently in the database when the user opens the app.
    setUpUserList();
    super.initState();

    /// Creates the keypad when the app starts.
    _buildKeypadWhenInitialized(context);
  }

  /// Stores a list of the current gift cards
  List<UserInfo> userInfoList = [];

  /// Boolean check for the keypad pin input.
  bool isAuthenticated = false;
  bool needAccount;

  /// Transforms each gift card stored in the database in a button widget
  List<Widget> get userInfoWidgets => userInfoList.map((item) => seeUserInfoButton(item)).toList();

  /// Controllers for the input values.
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _pinController = new TextEditingController();
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  
  /// Allows variables to be used across the page.
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

  /// Builds the [Keypad] pin input.
  /// 
  /// When the app is started, the keypad is the first thing that is loaded.
  /// The user can also hit 'Cancel' in order to go to a page that allows 
  /// them to create  pin if they don't have one, or get a security question
  /// to figure out their old pin.
  _buildKeypadWhenInitialized(BuildContext context) {
    Timer.run(() => _showLockScreen(
      context,
      opaque: false,
      cancelButton: Text(
        'Cancel',
        style: const TextStyle(fontSize: 16, color: Colors.white),
        semanticsLabel: 'Cancel',
      ),
    ));
  }

  /// Creates the [Keypad] screen.
  ///
  /// This is the actual build of the keypad. This holds all the variables and
  /// text that is shown when the user is in the keypad.
  _showLockScreen(BuildContext context,
      {bool opaque,
        CircleUIConfig circleUIConfig,
        KeyboardUIConfig keyboardUIConfig,
        Widget cancelButton,
        List<String> digits}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) => PasscodeScreen(
            title: Text(
              'Enter Pin',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
          ),
        ));
  }

  /// Action for then the pin is entered
  ///
  /// If the pin makes it past the verification, the user gets sent to the
  /// HomeScreen page. If the pin is incorrect, the user's input pin is deleted
  /// and they have to put in a new pin.
  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = userInfoList[0].password == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      setState(() {
        this.isAuthenticated = isValid;
      });
    }
  }

  /// Action for if the user cancels their pin input.
  ///
  /// If the user hits cancel and deletes their input, the user will be sent
  /// to the page that allows them to figure out their old password, or make
  /// a new password.
  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  /// Updates the list of gift cards when there is a change
  void setUpUserList() async{
    List<Map<String, dynamic>> _results  = await UserDB.query(UserInfo.table);
    userInfoList = _results.map((item) => UserInfo.fromMap(item)).toList();
    setState(() {    });
  }

  /// Builds the button for the user info.
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

  /// Builds the [Login] button.
  /// 
  /// Once the 'Login' button is clicked on, it brings up the keypad.
  Widget _buildLoginButton() {
    return MaterialButton(
      elevation: 4,
      color: Colors.grey,
      child: Text(
          'Login',
          style: TextStyle(
              color: Colors.black,
              fontSize: 16
          )
      ),

      // Button clicked action happens here
      onPressed: () async {
        _showLockScreen(
          context,
          opaque: false,
          cancelButton: Text(
            'Cancel',
            style: const TextStyle(fontSize: 16, color: Colors.white),
            semanticsLabel: 'Cancel',
          ),
        );
      },
    );
  }

  /// Builds the [Create_New_Account] button.
  /// 
  /// This button can be clicked on when a user doesn't have an account.
  /// The pin then changes from 'TEST' which is what it is initialized to, to
  /// whatever the user sets it to be.
  Widget _buildCreateNewAccountButton() {
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      height: 20,
      elevation: 0,
      color: Colors.transparent,
      child: Text(
          "Don't have an account?",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          )
      ),

      // Button clicked action happens here, and it creates the pin popup.
      onPressed: () async {
        //_buildPinPopup(context, info);
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddAccountScreen()));
        },
    );
  }

  /// Builds the [Forgot_Password] button.
  ///
  /// This button can be clicked on when a user forgets their password.
  Widget _buildForgotPasswordButton() {
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      height: 20,
      elevation: 0,
      color: Colors.transparent,
      child: Text(
          "Forgot Password?",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          )
      ),

      // Button clicked action happens here, and it creates the pin popup.
      onPressed: () async {
        //_buildPinPopup(context, info);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
      },
    );
  }

  /// Builds the [Pin_Popup] popup.
  ///
  /// This popup allows the user to create a pin in order to log into the app.
  /// Currently it also allows the user to change the password whenever they
  /// want, and they don't have to know the previous password. This issue
  /// needs to be changed at some point.
  ///
  /// This isn't used currently, but it could be used for the for the forgot
  /// password screen to make it easier for the user.
  _buildPinPopup(BuildContext context, UserInfo info) {
    // Set up the button.
    Widget okButton = FlatButton(
      child: Text("Save Pin"),

      // Button clicked action happens here.
      onPressed: () async {

        // Updates the database with the user's new pin.
        await UserDB.update(UserInfo.table, UserInfo(
          id: info.id,
          username: info.username,
          password: _pinController.text,
          passwordHintAnswer: info.passwordHintAnswer,
          passwordHintQuestion: info.passwordHintQuestion,
        ));
        setState(() {
          info.password = _pinController.text;
        });

        // Makes the app go to the login page.
        Navigator.of(context).pop();
      },
    );

    // Creates the text field that takes in the user's new pin.
    Widget inputPin = TextFormField(
      textInputAction: TextInputAction.go,
      keyboardType: TextInputType.number,
      controller: _pinController,
      maxLength: 4,
      decoration: InputDecoration(hintText: "Enter a pin"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Create Pin:"),
      content:
        inputPin,
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

  /// Builds the [AddOrForgotPin] button.
  ///
  /// If the user already has a pin set up, this function will allow the user
  /// to retrieve the pin if they forgot it. If they don't have a pin set up,
  /// it will bring the user to a 'Create Account' screen to set up a pin.
  Widget _buildAddOrForgotPinButton() {

    setUpUserList();

    if(userInfoList.isEmpty) {
      needAccount = true;
    }

    else {
      if(userInfoList[0].password != "TEST") {
        needAccount = false;
      }
    }

    if(needAccount) {
      return _buildCreateNewAccountButton();
    }
    else {
      return _buildForgotPasswordButton();
    }
  }

  /// Builds the [LoginScreen] page.
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // Fixes the error that is caused by a pixel overflow.
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,

        appBar: AppBar(
            title: Text("Login",
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
            centerTitle: true,
            backgroundColor: Color(0xff1100FF)
        ),

        body: Center(
          child: Container(
              margin: EdgeInsets.all(24),
              child: Form(
                  key: _formKey,

                  // Makes sure the text box that is being filled in is on the page.
                  child: SingleChildScrollView(
                      child: Column(
                          children: <Widget>[

                            SizedBox(height: 5),
                            _buildAddOrForgotPinButton(),

                            SizedBox(height: 50),
                            _buildLoginButton(),

                          ]
                      )
                  )
              )
          ),
        )
    );
  }
}
