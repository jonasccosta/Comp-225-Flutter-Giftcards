import 'dart:io';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Gift_Card.dart';

class CreateNewCardScreen extends StatefulWidget {
  final GiftCard currentCard;

  CreateNewCardScreen([this.currentCard]);

  @override
  State<StatefulWidget> createState() {
    return CreateNewCardScreenState(currentCard);
  }
}

class CreateNewCardScreenState extends State<CreateNewCardScreen> {
  GiftCard currentCard;

  // The name of the image for the card
  File _frontCardImage;

  // The Names of the variables that the user inputs.
  String _name;
  String _number;
  String _expirationDate;
  String _securityCode;
  String _balance;

  final TextEditingController _expirationDateController = new TextEditingController();

  // Allows variables to be used across the page.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Constructor that checks if the user is editing an existing gift card or creating a new one
  CreateNewCardScreenState([this.currentCard]){
    checkParameter();

    //Sets the initial value of the controller for the expiration date text field
    //If the user is creating a new card, its value is an empty string
    _expirationDateController.text = currentCard.expirationDate;
  }

  /// Builds the [Name] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_name] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      initialValue: currentCard.name,
      validator: (String value) {
        // Produces the error if no name is entered.
        if(value.isEmpty) {
          return 'Name is Required';
        }
        // Produces no error if a name is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  /// Builds the [Number] TextFormField.
  ///
  /// Returns an error message to the user if no number is given.
  /// The value in the TextFormField is saved to the [_number] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildNumberField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Number'),
      initialValue: currentCard.number,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      validator: (String value) {
        // Produces the error if no number is entered.
        if(value.isEmpty) {
          return 'Number is Required';
        }
        // Produces no error if a number is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _number = value;
      },
    );
  }

  /// Builds the [ExpirationDate] TextFormField.
  ///
  /// Returns an error message to the user if no expiration date is given.
  /// The value in the TextFormField is saved to the [_expirationDate] variable
  /// once the 'Save Card' button is pushed.
  Widget _buildExpirationDateField() {

    return TextFormField(
      // Adds in the label and the hint to the text box.
      decoration: InputDecoration(
          labelText: 'Expiration Date',
          hintText: 'mm dd yyyy'
      ),
      controller: _expirationDateController,

      // Sets the keyboard to use the date, and when you click 'done', it
      // formats the date to be easier to read.
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        value = formatDate(value);
        _expirationDateController.text = formatDate(value);

      },
      // The text box now only allows 8 numbers total.
      inputFormatters: [
        LengthLimitingTextInputFormatter(8),
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      validator: (String value) {

        // Produces an error if the date is left empty.
        if(value.isEmpty) {
          return 'Expiration Date is Required';
        }

        // Produces an error if the date isn't valid.
        else {
          if(! validDateCheck(value)) {
            return 'Please enter a valid expiration date';
          }
        }
        // Produces no error if a valid expiration date is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _expirationDate = value;
      },
    );
  }

  /// Builds the [SecurityCode] TextFormField.
  ///
  /// Returns an error message to the user if no security code is given.
  /// The value in the TextFormField is saved to the [_securityCode] variable
  /// once the 'Save Card' button is pushed.
  Widget _buildSecurityCodeField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Security Code'),
      initialValue: currentCard.securityCode,
      validator: (String value) {

        // Produces the error if no security code is entered.
        if(value.isEmpty) {
          return 'Security Code is Required';
        }
        // Produces no error if a security code is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _securityCode = value;
      },
    );
  }

  Widget _buildBalanceField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Gift Card Balance'),
      initialValue: currentCard.balance,
      validator: (String value) {

        // Produces the error if no security code is entered.
        if(value.isEmpty) {
          return 'Gift Card Balance is Required';
        }
        // Produces no error if a security code is provided.
        return null;
      },

      // Once the 'Save Card' button is clicked, the value gets saved.
      onSaved: (String value) {
        _balance = value;
      },
    );
  }

  Widget _buildTakeAPictureButton(){
    return Align(
      child: Container(
        alignment: Alignment.topCenter,
        color: Colors.green,
        width: MediaQuery.of(context).size.width * 0.7,
        height: 150,
        child: ButtonTheme(
          minWidth: double.infinity,
          height: double.infinity,
          child: RaisedButton(
              color:Colors.cyan,
              elevation: 10,
              child:
              updateCameraButton(),
              onPressed: () async {
                _frontCardImage = await showDialog(
                  context: context,
                  builder: (context) => Camera(
                    mode: CameraMode.normal,
                    enableCameraChange: false,
                    orientationEnablePhoto: CameraOrientation.landscape,
                  ),
                );
              }
          ),
        ),
      ),
    );
  }

  /// Builds the [GiftCardInformation] page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Fixes the error that is caused by a pixel overflow.
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
          title: Text("Enter Card Info or Take a Picture", style: TextStyle(color: Colors.white, fontSize: 20.0)),
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
                _buildTakeAPictureButton(),
                SizedBox(height: 10),

                _buildNameField(),
                SizedBox(height: 10),

                _buildNumberField(),
                SizedBox(height: 10),

                _buildExpirationDateField(),
                SizedBox(height: 10),

                _buildSecurityCodeField(),
                SizedBox(height: 10),

                _buildBalanceField(),
                SizedBox(height: 100),

                RaisedButton(
                  elevation: 5,
                  child:Text(
                      'Save Card',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16
                      )
                  ),

                  // Button clicked action happens here/
                  onPressed: () {

                    // Makes sure all the text boxes have valid information.
                    if(!_formKey.currentState.validate()){
                      return;
                    }

                    // Triggers all of the 'value' variables to be saved in
                    // their respective new variables.
                    _formKey.currentState.save();

                    _expirationDateController.text = formatDate(_expirationDate);


                    // Currently prints out the stored data, but this is where
                    // the data can be saved to a file.
                    print(_name);
                    print(_number);
                    print(_expirationDate);
                    print(_securityCode);
                    print(_balance);
                    print(_frontCardImage.path);


                    //Creates a gift card object with the information the user entered
                    GiftCard giftCard = GiftCard(name: _name, number: _number, expirationDate: _expirationDate, securityCode: _securityCode, balance: _balance, photo: _frontCardImage.path);

                    //Returns to the screen that the user viewed prior to this screen, returning a gift card
                    Navigator.pop(context, giftCard);


                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Check if the user is editing an existing gift card. If not, the current card is a card which has empty strings as its variables
  void checkParameter(){
    if(currentCard == null){
      currentCard = new GiftCard(name:"", number: "", expirationDate: "", securityCode: "", balance: "", photo: null);
    }
  }


  //Returns and updates the widget inside the camera button
  Widget updateCameraButton(){
    //If the user is creating a new card and already took a picture of the new
    //card, the widget returned is an Image widget containing the picture the
    //user took.
    if(_frontCardImage != null){
      return Image.file(_frontCardImage);
    }


    //If the user is editing an existing card, the widget returned is an Image
    //widget containing the button is the picture of the card that is being edited.
    else if(currentCard.photo != null){
      return Image.file(File(currentCard.photo));
    }

    //If the user is creating a new card and did not take a picture of the new
    //card yet, the widget returned is an Image widget containing the picture the
    //user took.
    else return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.add_a_photo, size: 40),
            Text("Take a picture!"),
          ]
      );
  }

}

/// Checks to make sure the input date is in the correct format.
///
/// Takes in [inputDate] which is the raw data from the user. It then parses it
/// into three sections for month, day, and year. It checks to see if each of
/// these new variables are in the correct range.
/// Returns [True] or [False] depending on if the date is correct or not.
bool validDateCheck(inputDate)
{
  inputDate = inputDate.toString().replaceAll('/', '');

  // Parsing the input string.
  String month = inputDate.toString().substring(0, 2);
  String day = inputDate.toString().substring(2, 4);
  String year = inputDate.toString().substring(4,);

  // Testing the parsed variables.
  if (month.length == 2 && int.parse(month) > 0 && int.parse(month) < 13) {
    if (day.length == 2 && int.parse(day) > 0 && int.parse(day) < 32) {
      if (year.length == 4 && int.parse(year) > 2019) {
        return true;
      }
    }
  }
  return false;
}

/// Changes the input string so that it is an easier to read date format.
///
/// It takes out any slashes that are already in the input string. Then it
/// parses through the input string creating a month, day, and year variable.
/// It then adds in new slashes and returns the new [formattedDate].
String formatDate(inputDate) {

  inputDate = inputDate.toString().replaceAll('/', '');
  String month = inputDate.toString().substring(0, 2);
  String day = inputDate.toString().substring(2, 4);
  String year = inputDate.toString().substring(4,);

  String formattedDate = month + "/" + day + "/" + year;
  return formattedDate;
}





