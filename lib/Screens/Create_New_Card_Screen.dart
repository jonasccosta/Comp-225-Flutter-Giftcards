import 'dart:io';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Gift_Card.dart';
import 'package:flutter_app/Image_Scraping.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

/// Screen in which the user will enter the information about the gift card
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

  /// The name of the image for the card
  File _frontCardImage;

  /// The Names of the variables that the user inputs.
  String _name;
  String _number;
  String _expirationDate;
  String _securityCode;
  String _balance;




  TextEditingController _cardNumberController = new TextEditingController();
  TextEditingController _expirationDateController = new MaskedTextController(mask: '00/00');



  /// Allows variables to be used across the page.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Checks if the user is editing an existing gift card or creating a new one.
  CreateNewCardScreenState([this.currentCard]){
    _checkParameter();

    //Sets the initial value of the controller for the expiration date text field.
    _expirationDateController.text = currentCard.expirationDate;
    _cardNumberController.text = currentCard.number;

  }

  /// Builds the [TakeAPicture] Button.
  ///
  /// The widget inside the button is decided with the [updateCameraButton()]
  /// method.
  Widget _buildTakeAPictureButton() {
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
              color: Color(0xffFF000B),
              elevation: 10,
              child:
              _updateCameraButton(),
              onPressed: () async {
                _frontCardImage = await showDialog(
                  context: context,
                  builder: (context) => Camera(
                        mode: CameraMode.normal,
                        enableCameraChange: false,
                        orientationEnablePhoto: CameraOrientation.landscape,
                      ),
                );
                //sending the picture from the camera through the API's and to the
                //sending the picture from the camera through the API and getting the data to the variables
                Map json = await sendFile(_frontCardImage.path);
                _number = json['card number'];
                _cardNumberController.text = _number;
                _expirationDate = json['expiration date'];
                _expirationDateController.text = _expirationDate;

              }
          ),
        ),
      ),
    );
  }

  /// Builds a Text widget with information about the camera.
  ///
  /// The camera only takes a picture when the phone is on the horizontal
  Widget _buildCameraInfoText(){
    return Text(
        "Scan the card with the phone on the horizontal",
        style: TextStyle(
            fontSize: 14,
            color: Colors.black54),
      textAlign: TextAlign.center,);
  }

  /// Builds the [Name] TextFormField.
  ///
  /// Returns an error message to the user if no name is given.
  /// The value in the TextFormField is saved to the [_name] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Card Name *',
          hintText: 'ex. Subway'),
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

  /// Builds the [Balance] TextFormField.
  ///
  /// Returns an error message to the user if no balance is given.
  /// The value in the TextFormField is saved to the [_balance] variable
  /// once the 'Save Card' button is pushed.
  Widget _buildBalanceField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Gift Card Balance *',
          hintText: '\$0.00'),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      initialValue: currentCard.balance,
      inputFormatters: [CurrencyTextInputFormatter(
        locale: 'en',
        symbol: '\$',
      )],
      enableInteractiveSelection: false,
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

  /// Builds the [Number] TextFormField.
  ///
  /// Returns an error message to the user if no number is given.
  /// The value in the TextFormField is saved to the [_number] variable once
  /// the 'Save Card' button is pushed.
  Widget _buildNumberField() {
    return TextFormField(

      decoration: InputDecoration(labelText: 'Card Number *'),

      //initialValue: currentCard.number,
      controller: _cardNumberController,

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

          hintText: 'mm/yy'

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
      // The text box now only allows 4 numbers plus 1 slash total.
      inputFormatters: [
        LengthLimitingTextInputFormatter(5),
      ],


      // Once the 'Save Card' button is clicked, the value gets saved.
      // If the value is empty, the [_expirationDate] is 'N/A' by default.
      onSaved: (String value) {
        if(value.isEmpty){
          _expirationDate = 'N/A';
        }
        else{
          _expirationDate = value;
        }
      },
    );
  }

  /// Builds the [SecurityCode] TextFormField.
  ///
  /// Returns an error message to the user if no security code is given.
  /// The value in the TextFormField is saved to the [_securityCode] variable
  /// once the 'Save Card' button is pushed.
  Widget _buildSecurityCodeField() {
    // Chooses the initial value of the text field.
    String initialValue = "";
    if(currentCard.securityCode != 'N/A'){
      initialValue = currentCard.securityCode;
    }

    return TextFormField(
      decoration: InputDecoration(labelText: 'Security Code'),
      initialValue:initialValue,

      // Once the 'Save Card' button is clicked, the value gets saved.
      // If the value is empty, the [_securityCode] is 'N/A' by default.
      onSaved: (String value) {
        if(value.isEmpty){
          _securityCode = 'N/A';
        }
        else {
          _securityCode = value;
        }
      },
    );
  }



  /// Builds a Text widget with information about the TextFields.
  ///
  /// Lets the user know which fields are required.
  Widget _buildFieldsInfoText(){
    return Text(
      "Fields marked with an asterisk (*) are required",
      style: TextStyle(
          fontSize: 14,
          color: Colors.black54),
      textAlign: TextAlign.left,);
  }

  /// Builds the [SaveCard] Button.
  ///
  /// Once the button is clicked, the value of the text fields are transferred
  /// to the corresponding variables and, if all the information was entered
  /// correctly, a [GiftCard] object is created and it returns to the
  /// [HomeScreen].
  Widget _buildSaveButton(){
    return RaisedButton(
      color: Color(0xffFF000B),
      elevation: 5,
      child:Text(
          'Save Card',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16
          )
      ),
      onPressed: () {

        // Makes sure all the text boxes have valid information.
        if(!_formKey.currentState.validate()){
          return;
        }

        // Triggers all of the 'value' variables to be saved in
        // their respective new variables.
        _formKey.currentState.save();


        // Creates a gift card object with the information the user entered.
        GiftCard giftCard = GiftCard(
            name: _name,
            number: _number,
            expirationDate: _expirationDate,
            securityCode: _securityCode,
            balance: _balance,
            photo: _frontCardImage.path);

        // Returns to the screen that the user viewed prior to this screen, returning a gift card.
        Navigator.pop(context, giftCard);
      },
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
          title: Text("Scan Card Then Enter Remaining Info.", style: TextStyle(color: Colors.white, fontSize: 15.0)),
          centerTitle: true,
          backgroundColor: Color(0xff1100FF)
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

                _buildCameraInfoText(),
                SizedBox(height: 10),

                _buildNameField(),
                SizedBox(height: 10),

                _buildBalanceField(),
                SizedBox(height: 10),

                _buildNumberField(),
                SizedBox(height: 10),

                _buildExpirationDateField(),
                SizedBox(height: 10),

                _buildSecurityCodeField(),
                SizedBox(height: 10),


                _buildFieldsInfoText(),
                SizedBox(height: 50),

                _buildSaveButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Checks if the user is editing an existing gift card.
  ///
  /// If the user is creating a card for the first time, the current card is a
  /// card which has empty strings as its variables. Otherwise, the current card
  /// is the card the user is editing.
  void _checkParameter(){
    if(currentCard == null){
      currentCard = new GiftCard(name:"", number: "", expirationDate: "", securityCode: "", balance: "", photo: "");
    }
  }

  /// Returns and updates the widget inside the camera button.
  ///
  /// If the user is creating a new card and already took a picture of the new
  /// card, the widget returned is an Image widget containing the picture the
  /// user took. If the user is editing an existing card, the widget returned is
  /// an Image widget containing the button is the picture of the card that is
  /// being edited. If the user is creating a new card and did not take a picture
  /// of the new card yet, the widget returned is an Image widget containing the
  /// picture the user took.
  Widget _updateCameraButton() {
    if(_frontCardImage != null){
      return Image.file(_frontCardImage);
    }

    else if(currentCard.photo != ""){
      _frontCardImage = File(currentCard.photo);
      return Image.file(_frontCardImage);
    }

    else return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.add_a_photo, size: 50, color: Colors.white,),
            Text("Scan Card (# side)", style: TextStyle(fontSize: 18, color: Colors.white),
            )]
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
  String year = inputDate.toString().substring(2,);

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





