import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/User_Info.dart';
import 'package:flutter_app/Databases/User_Info_Database.dart';
import 'Login_Screen.dart';

/// Screen in which the user creates their account.
class AddAccountScreen extends StatefulWidget {
  final UserInfo userInfo;

  AddAccountScreen([this.userInfo]);

  @override
  State<StatefulWidget> createState() {
    return AddAccountScreenState();
  }
}

class AddAccountScreenState extends State<AddAccountScreen> {

  @override
  void initState() {
    // Retrieves the users that are currently in the database when the user opens the app.
    setUpUserList();
    super.initState();
  }

  /// Updates the list of users when there is a change.
  void setUpUserList() async {
    List<Map<String, dynamic>> _results = await UserDB.query(UserInfo.table);
    userInfoList = _results.map((item) => UserInfo.fromMap(item)).toList();
    setState(() {});
  }

  /// Adds in our special gray color so it is easier to user later on.
  Color specialGrey = Color.fromRGBO(174, 174, 174, 1.0);

  /// Stores a list of the current users.
  List<UserInfo> userInfoList = [];

  UserInfo userInfo;

  AddAccountScreenState([this.userInfo]);

  /// Controllers for accessing what's in the text fields later.
  final TextEditingController _pinController = new TextEditingController();
  final TextEditingController _confirmPinController = new TextEditingController();
  final TextEditingController _securityAnswerController = new TextEditingController();

  /// The names of the variables that the user inputs.
  String _username;
  String _pin;
  String _confirmPin;
  String _securityQuestion;
  String _securityAnswer;

  /// Allows variables to be used across the page.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Builds the [CreatePin] text box.
  Widget _buildCreatePinText() {
    return Text(
      "Create Pin",
      style: TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.start,
    );
  }

  /// Builds the [SecurityQuestion] text box.
  Widget _buildSecurityQuestionText() {
    return Text(
      "Security Question",
      style: TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.start,
    );
  }

  /// Builds the [Pin] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_pin] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildPinField() {
    return TextFormField(
      style: TextStyle(color: specialGrey),
      decoration: InputDecoration(
        labelText: 'Pin Number',
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
      obscureText: true,
      controller: _pinController,
      maxLength: 6,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      validator: (String value) {
        // Produces the error if no name is entered.
        if(value.isEmpty) {
          return 'Password is Required';
        }

        if(value.length != 6) {
          return 'Pin is not long enough';
        }

        // Produces no error if a name is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _pin = value;
      },
    );
  }

  /// Builds the [Confirm_Pin] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_confirmPin] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildConfirmPinField() {
    return TextFormField(
      style: TextStyle(color: specialGrey),
      decoration: InputDecoration(
          labelText: 'Confirm Pin Number',

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
      obscureText: true,
      controller: _confirmPinController,
      maxLength: 6,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      validator: (String value) {
        // Produces the error if no name is entered.
        if(value.isEmpty) {
          return 'Empty';
        }

        if(value.length != 6) {
          return 'Pin is not long enough';
        }

        if(_confirmPinController.text != _pinController.text) {
          return 'Pin does not match';
        }

        // Produces no error if a name is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _confirmPin = value;
      },
    );
  }

  /// Builds the [Security_Question] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_securityQuestion] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildSecurityQuestionField() {
    return TextFormField(
      style: TextStyle(color: specialGrey),
      decoration: InputDecoration(
          labelText: 'Security Question',

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
      maxLength: 50,
      keyboardType: TextInputType.text,
      validator: (String value) {
        // Produces the error if no name is entered.
        if(value.isEmpty) {
          return 'Please enter a Security Question';
        }
        // Produces no error if a name is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _securityQuestion = value;
      },
    );
  }

  /// Builds the [Security_Answer] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_securityAnswer] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildSecurityAnswerField() {
    return TextFormField(
      style: TextStyle(color: specialGrey),
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
      ),
      controller: _securityAnswerController,
      maxLength: 10,
      keyboardType: TextInputType.text,
      validator: (String value) {
        // Produces the error if no name is entered.
        if(value.isEmpty) {
          return 'Please enter a Security Answer';
        }
        // Produces no error if a name is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _securityAnswer = value;
      },
    );
  }

  /// Builds the [CreateAccount] button.
  ///
  /// Checks to make sure the pin and confirm pin variables are the same,
  /// and then it makes sure the 'Security Question' and 'Security Answer'
  /// text boxes have values in them. If everything has the correct values, it
  /// updates the database with the new information and then goes to the
  /// login screen.
  Widget _buildCreateAccountButton() {
    return RaisedButton(
      color: specialGrey,
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

        UserInfo userInfo = UserInfo(
            username: _username,
            password: _pin,
            passwordHintQuestion: _securityQuestion,
            passwordHintAnswer: _securityAnswer
        );

        UserInfo info = userInfoList[0];

        if (userInfo != null) {
          // Updates the database with the user's new pin.
          await UserDB.update(UserInfo.table, UserInfo(
            id: info.id,
            username: "TEST",
            password: _pin,
            passwordHintQuestion: _securityQuestion,
            passwordHintAnswer: _securityAnswer,
          ));

          // Updates the values.
          setState(() {
            info.username = "TEST";
            info.password = _pin;
            info.passwordHintQuestion = _securityQuestion;
            info.passwordHintAnswer = _securityAnswer;

          });

          userInfo = UserInfo(username: "TEST", password: _pin, passwordHintQuestion: _securityQuestion, passwordHintAnswer: _securityAnswer);
          setUpUserList();
        }

        // Makes the app go to the login page.
        Navigator.pop(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
                            // The 'SizedBox's create more space between the text fields.

                            _buildCreatePinText(),
                            SizedBox(height: 10),

                            _buildPinField(),
                            SizedBox(height: 10),

                            _buildConfirmPinField(),
                            SizedBox(height: 30),

                            _buildSecurityQuestionText(),
                            SizedBox(height: 10),

                            _buildSecurityQuestionField(),
                            SizedBox(height: 10),

                            _buildSecurityAnswerField(),
                            SizedBox(height: 30),

                            _buildCreateAccountButton(),

                          ]
                      )
                  )
              )
          ),
        )
    );
  }
}
