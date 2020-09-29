import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Gift_Card.dart';
import 'Create_New_Card_Screen.dart';
import 'Database.dart';

// ignore: must_be_immutable
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
    //Retrieves the gift cards that are currently in the database when the user opens the app
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Gift Card Info Screen',
      home: Scaffold(
          appBar: AppBar(
            title: Text(card.name, style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, card);

              },
            ),
          ),

          body: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                child: Image(
                  image: NetworkImage('https://www.nicepng.com/png/full/11-112487_gift-card-target-target-gift-card-png.png'),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                   "Balance: " + card.balance, //giftcard.getRemainingAmount?
                    style: TextStyle(
                        fontSize: 25.0,
                      color: Colors.black38
                    )
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                  child: Text(
                    '#: ' + card.number, //giftcard.getNumber?
                    style: TextStyle(
                        fontSize: 20.0,
                      color: Colors.black38
                    ),
                  )
              ),
              Container(
                  padding:EdgeInsets.all(10.0),
                  child: Text(
                      'SC: ' + card.securityCode, //giftcard.getSecurityCode?
                      style: TextStyle(
                          fontSize: 20.0,
                        color: Colors.black38
                      )
                  )
              ),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      'Expires: ' + card.expirationDate, //giftcard.getSecurityCode?
                      style: TextStyle(
                          fontSize: 20.0,
                        color: Colors.black38
                      )
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          _editGiftCard(context, card);
                          print('Edited!');},
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              fontSize: 20.0,
                          color: Colors.white),
                        ),
                        color: Colors.blue,
                        highlightColor: Colors.blueGrey,

                      )
                  ),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          _deleteGiftCard(context, card);},
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              fontSize: 20.0,
                          color: Colors.white),
                        ),
                        color: Colors.redAccent,
                        highlightColor: Colors.red,
                      )
                  )
                ],
              )
            ],
          )
      ),
    );
  }

  //Handles changes in the database when the edit button is clicked and a card is edited
  _editGiftCard(BuildContext context, GiftCard card) async{
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateNewCardScreen(card)));


    GiftCard giftCard = result;

    await DB.update(GiftCard.table, GiftCard(
      id: card.id,
      name: giftCard.name,
      number: giftCard.number,
      securityCode: giftCard.securityCode,
      expirationDate: giftCard.expirationDate,
      balance: giftCard.balance
    ));
    setState(() {this.card = giftCard;});

  }

  //Handles changes in the database when the delete button is pressed
  _deleteGiftCard(BuildContext context, GiftCard card) async{
    await DB.delete(GiftCard.table, card);
    Navigator.pop(context);
  }
}
