import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
        appBar: AppBar(
            title: Text("Add or View Saved Cards", style: TextStyle(color: Colors.white, fontSize: 20.0)),
            centerTitle: true,
            backgroundColor: Colors.blue
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child : ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                    children: giftCardWidgets
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
                    //     )
                    // ),
                    // icon: Icon(Icons.add_a_photo, color: Colors.green, size: 50.0),
                    //
                    // color: Colors.greenAccent,
                    // padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                    child: Icon(Icons.add),
                    onPressed: (){
                      _getGiftCardInfo(context);
                      //Navigator.of(context)
                      //  .push(
                      //MaterialPageRoute(
                      //  builder: (context) => FormScreen()
                      //)
                      //);
                    },
                  ),
                ],
              ),
              // ),
              // Flexible(
              // Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children:
              //     //<Widget>[
              //     giftCardWidgets
              //
              //   /*RaisedButton.icon(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => GiftCardInfoApp()));}, icon: Icon(Icons.card_giftcard, color: Colors.green, size: 60.0), label: Text("Subway", style: TextStyle(color: Colors.green, fontSize: 27.0)), color: Colors.greenAccent, padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
              //       ),
              //       RaisedButton.icon(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => GiftCardInfoApp()));}, icon: Icon(Icons.card_giftcard, color: Colors.green, size: 60.0), label: Text("McDonald's", style: TextStyle(color: Colors.green, fontSize: 27.0)), color: Colors.greenAccent, padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
              //       ),
              //       RaisedButton.icon(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => GiftCardInfoApp()));}, icon: Icon(Icons.card_giftcard, color: Colors.green, size: 60.0), label: Text("Dunkin' Donuts", style: TextStyle(color: Colors.green, fontSize: 27.0)), color: Colors.greenAccent, padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
              //       ),
              //       RaisedButton.icon(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => GiftCardInfoApp()));}, icon: Icon(Icons.card_giftcard, color: Colors.green, size: 60.0), label: Text("Target", style: TextStyle(color: Colors.green, fontSize: 27.0)), color: Colors.greenAccent, padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
              //       ),*/
              //   //]
              // ),
            ]

        )
    );
  }

  //Updates the list of gift cards when there is a change
  void setUpGiftCards() async{
    List<Map<String, dynamic>> _results  = await DB.query(GiftCard.table);
    giftCards = _results.map((item) => GiftCard.fromMap(item)).toList();
    setState(() {    });
  }

  //Returns a button that when clicked, goes to the gift Card information page
  Widget seeGiftCardButton(GiftCard card){
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => CardInfoScreen(card)));
        },
        title: Text(card.name, style: TextStyle(fontSize: 36, color: Colors.black38)),
        leading: Image(
          image: NetworkImage('https://www.wildcatgolfclub.com/wp-content/uploads/sites/7721/2017/09/giftcard.png'),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('40.00', style: TextStyle(fontSize: 18, color: Colors.black38)),
          Text('Exp:' + card.expirationDate, style: TextStyle(fontSize: 18, color: Colors.black38)
              )]
            )
        ),

      );




  }

  //Gets the information about the card the user inputed in the Gift Card Information Screen and adds it to the database and list of GiftCards
  _getGiftCardInfo(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateNewCardScreen()),
    );

    GiftCard card = result;

    await DB.insert(GiftCard.table, card);

    setState(() {});
    setUpGiftCards();

  }

}

class ScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Screen Two :(")
      ),
    );
  }
}