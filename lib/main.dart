import 'package:flutter/material.dart';

import 'Gift_Card_Information_Page.dart';

import 'Info_Screen.dart';


void main() {
  runApp(MaterialApp(
    home: Home()
  ));
}
  class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
        title: Text("Add or View Saved Cards", style: TextStyle(color: Colors.green, fontSize: 20.0)),
        centerTitle: true,
        backgroundColor: Colors.greenAccent
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // Row(
        //   children: <Widget>[
        //     Text("")
        //   ]
        // ),
        // Flexible(
        // child:
             Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RaisedButton.icon(
                  label: Text("Add A Card",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.green,
                      )
                  ),
                    icon: Icon(Icons.add_a_photo, color: Colors.green, size: 50.0),

                    color: Colors.greenAccent,
                    padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                    onPressed: (){
                Navigator.of(context)
                    .push(
                        MaterialPageRoute(
                          builder: (context) => ScreenTwo()
                        )
                    );
                },
                ),
              ],
            ),
        // ),
        // Flexible(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton.icon(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenTwo()));}, icon: Icon(Icons.card_giftcard, color: Colors.green, size: 60.0), label: Text("Subway", style: TextStyle(color: Colors.green, fontSize: 27.0)), color: Colors.greenAccent, padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            ),
            RaisedButton.icon(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenTwo()));}, icon: Icon(Icons.card_giftcard, color: Colors.green, size: 60.0), label: Text("McDonald's", style: TextStyle(color: Colors.green, fontSize: 27.0)), color: Colors.greenAccent, padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            ),
            RaisedButton.icon(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenTwo()));}, icon: Icon(Icons.card_giftcard, color: Colors.green, size: 60.0), label: Text("Dunkin' Donuts", style: TextStyle(color: Colors.green, fontSize: 27.0)), color: Colors.greenAccent, padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            ),
            RaisedButton.icon(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenTwo()));}, icon: Icon(Icons.card_giftcard, color: Colors.green, size: 60.0), label: Text("Target", style: TextStyle(color: Colors.green, fontSize: 27.0)), color: Colors.greenAccent, padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            ),
          ]
        ),
    ]

    )
  );
  }
  }
  class ScreenTwo extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Screen Two")
        ),
      );
    }
  }






