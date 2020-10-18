import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Gift_Card.dart';
import 'Create_New_Card_Screen.dart';
import '../Databases/Gift_Card_Database.dart';

/// Screen that shows information about an individual gift card.
/// ignore: must_be_immutable
class CardInfoScreen extends StatefulWidget {
  GiftCard card;

  CardInfoScreen(this.card);
  @override
  State<StatefulWidget> createState() {
    return CardInfoScreenState(card);
  }

}

class CardInfoScreenState extends State<CardInfoScreen>{
  GiftCard card;

  CardInfoScreenState(this.card);

  @override
  void initState() {
    // Sets the initial state of the screen
    super.initState();
  }

  /// Builds a Text Widget containing the Gift Card's balance.
  Widget _buildBalanceText(){
    return Text(
        "Balance: " + card.balance,
        style: TextStyle(
        fontSize: 25.0,
        color: Colors.black38
      )
    );
  }

  /// Builds a Text Widget containing the Gift Card's number.
  Widget _buildNumberText(){
    return Text(
      '#: ' + card.number,
      style: TextStyle(
          fontSize: 20.0,
          color: Colors.black38
      ),
    );
  }

  /// Builds a Text Widget containing the Gift Card's security code.
  Widget _buildSecurityCodeText(){
    return Text(
        'SC: ' + card.securityCode,
        style: TextStyle(
            fontSize: 20.0,
            color: Colors.black38
        )
    );
  }

  /// Builds a Text Widget containing the Gift Card's expiration date.
  Widget _buildExpirationDateText(){
    return Text(
        'Expires: ' + card.expirationDate,
        style: TextStyle(
            fontSize: 20.0,
            color: Colors.black38
        )
    );
  }

  /// Builds the edit button.
  Widget _buildEditButton(){
    return FlatButton(
      onPressed: () {
        _editGiftCard(context, card);
      },
      child: Text(
        'Edit',
        style: TextStyle(
            fontSize: 20.0,
            color: Colors.white),
      ),
      color: Color(0xff31D867),
      highlightColor: Colors.blueGrey,
    );
  }

  /// Builds the delete button.
  Widget _buildDeleteButton(){
   return FlatButton(
     onPressed: () {
       _deleteGiftCard(context, card);},
     child: Text(
       'Delete',
       style: TextStyle(
           fontSize: 20.0,
           color: Colors.white),
     ),
     color: Color(0xffFF000B),
     highlightColor: Colors.red,
    );
  }

  /// Builds the [CardInfoScreen].
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Gift Card Info Screen',
      home: Scaffold(
          appBar: AppBar(
            title: Text(card.name, style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Color(0xff1100FF),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, card);
              },
            ),
          ),

          body: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                child: Image.file(File(card.photo)),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: _buildBalanceText(),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                  child: _buildNumberText(),
              ),
              Container(
                  padding:EdgeInsets.all(10.0),
                  child: _buildSecurityCodeText(),
              ),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: _buildExpirationDateText(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(10.0),

                      // child: FlatButton(
                      //   onPressed: () {
                      //     _editGiftCard(context, card);
                      //     print('Edited!');},
                      //   child: Text(
                      //     'Edit',
                      //     style: TextStyle(
                      //         fontSize: 20.0,
                      //         color: Colors.white),
                      //   ),
                      //   color: Color(0xff06E212),
                      //   highlightColor: Colors.blueGrey,
                      //
                      // ),

                      child: _buildEditButton()


                  ),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: _buildDeleteButton()
                  )
                ],
              )
            ],
          )
      ),
    );
  }

  /// Updates the database when the edit button is clicked and a card is edited.
  _editGiftCard(BuildContext context, GiftCard card) async{
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateNewCardScreen(card)));

    GiftCard giftCard = result;

    if(giftCard != null) {
      await DB.update(GiftCard.table, GiftCard(
          id: card.id,
          name: giftCard.name,
          number: giftCard.number,
          securityCode: giftCard.securityCode,
          expirationDate: giftCard.expirationDate,
          balance: giftCard.balance,
          photo:  giftCard.photo
      ));
      setState(() {
        this.card = giftCard;
      });
    }
  }

  /// Deletes a [card] from the database when the delete button is pressed
  _deleteGiftCard(BuildContext context, GiftCard card) async{
    await DB.delete(GiftCard.table, card);
    Navigator.pop(context);
  }

}