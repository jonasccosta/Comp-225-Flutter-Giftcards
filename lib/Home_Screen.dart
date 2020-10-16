import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/About_Page.dart';
import 'package:flutter_app/Gift_Card.dart';
import 'Database.dart';
import 'Card_Info_Screen.dart';
import 'package:flutter_app/Create_New_Card_Screen.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add or View Saved Cards',
      home: HomeScreenState(title: 'Add or View Saved Cards'),
    );
  }
}

class HomeScreenState extends StatefulWidget {
  HomeScreenState({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();

}

class _MyHomeScreenState extends State<HomeScreenState> {
  //Stores a list of the current gift cards
  List<GiftCard> giftCards = [];

  //Transforms each gift card stored in the database in a button widget
  List<Widget> get giftCardWidgets => giftCards.map((item) => seeGiftCardButton(item)).toList();

  _MyHomeScreenState();

  @override
  void initState() {
    //Retrieves the gift cards that are currently in the database when the user opens the app
    setUpGiftCards();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (giftCards.isNotEmpty){
      content = setUpNotEmptyList(context);
    } else {
      content = setUpEmptyList(context);
    }
    return Scaffold(
        appBar: AppBar(
        title: Text("Add or View Saved Cards", style: TextStyle(color: Colors.white, fontSize: 20.0)),
    centerTitle: true,
    backgroundColor: Colors.blue,
    leading: IconButton(
    icon: Icon(CupertinoIcons.info, color: Colors.white,),
    onPressed: () {goToAbout(context);},
    ),
    ),
    body: content);
  }

  //Updates the list of gift cards when there is a change
  void setUpGiftCards() async{
    List<Map<String, dynamic>> _results  = await DB.query(GiftCard.table);
    giftCards = _results.map((item) => GiftCard.fromMap(item)).toList();
    setState(() {    });
  }

  //Builds the home screen given there are no giftcards stored
  Widget setUpEmptyList(BuildContext context){
    return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: <Widget>[
              Expanded(
                child : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                      child: Image(
                        image: AssetImage("assets/emptywallet.png"),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                      child: Text(
                        "You don't have any giftcards yet!",
                        style: TextStyle(fontSize: 36, color: Colors.black26), textAlign: TextAlign.center,
                      )
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                      child: Text(
                        "Press the add button to get started!",
                        style: TextStyle(fontSize: 36, color: Colors.black26), textAlign: TextAlign.center,
                      )
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    // label: Text("Add A Card",
                    //     style: TextStyle(
                    //       fontSize: 25.0,
                    //       color: Colors.green,
                    //    )
                    // ),
                    // icon: Icon(Icons.add_a_photo, color: Colors.green, size: 50.0),
                    //
                    // color: Colors.greenAccent,
                    // padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                    child: Icon(Icons.add),
                    onPressed: (){
                      _getGiftCardInfo(context);
                    },
                  ),
                ],
              ),

            ]

        );

  }
//Builds the home screen given there are gift cards stored
  Widget setUpNotEmptyList(BuildContext context){
    return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: <Widget>[
              Expanded(
                child : ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children:
                    giftCardWidgets
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    // label: Text("Add A Card",
                    //     style: TextStyle(
                    //       fontSize: 25.0,
                    //       color: Colors.green,
                    //    )
                    // ),
                    // icon: Icon(Icons.add_a_photo, color: Colors.green, size: 50.0),
                    //
                    // color: Colors.greenAccent,
                    // padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                    child: Icon(Icons.add),
                    onPressed: (){
                      _getGiftCardInfo(context);
                    },
                  ),
                ],
              ),

            ]

        );


  }

  //Returns a button that when clicked, goes to the gift Card information page
  Widget seeGiftCardButton(GiftCard card){
    return Card(
        child: ListTile(
          onTap: () {
            _modifyGiftCard(context, card);
          },
          title: Text(card.name, style: TextStyle(fontSize: 28, color: Colors.black38)),
          leading: Image.file(File(card.photo)),//Image(
          //image: NetworkImage('https://www.foremansinc.com/wp-content/uploads/2016/12/GiftCardGeneric.png'),
          //),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Balance: \$' + card.balance, style: TextStyle(fontSize: 16, color: Colors.black38),),
              Text('Exp: ' + card.expirationDate, style: TextStyle(fontSize: 16, color: Colors.black38),)
            ],
          ),

        )
    );
  }

  //Handles changes in the screen when a card is deleted or edited
  _modifyGiftCard(BuildContext context, GiftCard card) async{
    await Navigator.push(context, MaterialPageRoute(
        builder: (context) => CardInfoScreen(card)));

    setUpGiftCards();

  }

  //Handles going to the About screen
  goToAbout(BuildContext context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AboutPageScreen()));
  }

  //Gets the information about the card the user inputted in the Gift Card Information Screen and adds it to the database and list of GiftCards
  _getGiftCardInfo(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateNewCardScreen()),
    );

    GiftCard card = result;

    if (card != null) {
      await DB.insert(GiftCard.table, card);
      setUpGiftCards();
    }
  }


}
