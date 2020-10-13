import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Screens/Home_Screen.dart';
import 'package:flutter_app/Screens/Forgot_Password_Screen.dart';
import 'package:flutter_app/User_Info.dart';
import 'package:flutter_app/Databases/User_Info_Database.dart';
import 'package:flutter_app/Screens/Add_Account_Screen.dart';
import '../User_Info.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  
  @override
  void initState() {
    setUpUserList();
    //Retrieves the users that are currently in the database when the user opens the app
    super.initState();
  }

  // Stores a list of the current gift cards
  List<UserInfo> userInfoList = [];

  // Transforms each gift card stored in the database in a button widget
  List<Widget> get userInfoWidgets => userInfoList.map((item) => seeUserInfoButton(item)).toList();

  // Text controllers for the input values.
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _pinController = new TextEditingController();
  
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

  /// Builds the [Password] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_username] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildPasswordField(UserInfo info) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      controller: _passwordController,
      maxLength: 4,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      validator: (String value) {

        // Produces the error if no name is entered.
        if(value.isEmpty) {
          return 'Password is Required';
        }

        if (_passwordController.text != info.password) {
          print(info.password);
          return 'Password is incorrect';
        }
        // Produces no error if a name is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
      },
    );
  }

  /// Builds the [Login] button.
  /// 
  /// Once the 'Login' button is clicked on, it makes sure the pin is correct,
  /// and then it goes to the main screen page.
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
        // Makes sure all the text boxes have valid information.
        if (!_formKey.currentState.validate()) {
          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      },
    );
  }

  /// Builds the [Create_New_Account] button.
  /// 
  /// This button can be clicked on when a user doesn't have an account.
  /// The pin then changes from 'TEST' which is what it is initialized to, to
  /// whatever the user sets it to be.
  Widget _buildCreateNewAccountButton(UserInfo info) {
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddAccountScreen(info)));
        },
    );
  }

  /// Builds the [Create_New_Account] button.
  ///
  /// This button can be clicked on when a user forgets their password.
  Widget _buildForgotPasswordButton(UserInfo info) {
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
  Widget _buildAddOrForgotPinButton(UserInfo info) {
    if(info.passwordHintQuestion == "TEST") {
      return _buildCreateNewAccountButton(info);
    }
    else {
      return _buildForgotPasswordButton(info);
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
                        children: <Widget>[

                          SizedBox(height: 150),
                          _buildPasswordField(userInfoList[0]),

                          SizedBox(height: 5),
                          _buildAddOrForgotPinButton(userInfoList[0]),

                          SizedBox(height: 50),
                          _buildLoginButton(),

                        ]
                    )
                )
            )
        )
    );
  }
}
