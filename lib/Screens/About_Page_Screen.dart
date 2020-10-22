import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// About Screen, contains general information about the app.

/// Adds in our special gray colors so it is easier to user later on.
Color specialGrey = Color.fromRGBO(174, 174, 174, 1.0);
Color darkerSpecialGrey = Color.fromRGBO(100, 100, 100, 1.0);

class AboutPageScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        title: 'About',
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(title: Text('About'),
              centerTitle: true,
              backgroundColor: Color.fromRGBO(32, 32, 48, 1.0),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),

          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color.fromRGBO(53, 51, 81, 1.0), Color.fromRGBO(21, 21, 25, 1.0)])
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                  child: Image(
                      image: AssetImage("assets/logonoback.png")),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text("Card Safe", style: TextStyle(fontSize: 48, color: specialGrey),
                        textAlign: TextAlign.center),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                    child: Text("This app was developed for COMP 225 at Macalester College by team JonTomJonLob", style: TextStyle(
                        fontSize: 16.0, color: darkerSpecialGrey), textAlign: TextAlign.center,
                    )
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: Text("Special thanks to Professor Shilad Sen and Preceptor Richard Tran", style: TextStyle(
                        fontSize: 16.0, color: specialGrey), textAlign: TextAlign.center,
                    )
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: Text("All gift card data is stored locally on your device.", style: TextStyle(
                        fontSize: 16.0, color: darkerSpecialGrey), textAlign: TextAlign.center,
                    )

                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: Text("We are not liable if any of your gift cards get stolen.", style: TextStyle(
                        fontSize: 16.0, color: specialGrey), textAlign: TextAlign.center,
                    )

                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: Text("Finally, we need more text here so here's a joke for you:", style: TextStyle(
                        fontSize: 16.0, color: darkerSpecialGrey), textAlign: TextAlign.center,
                    )
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                    child: Text("What kind of gift card does Santa give naughty children?", style: TextStyle(
                        fontSize: 16.0, color: specialGrey), textAlign: TextAlign.center,
                    )
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                    child: Text("Kohl's!", style: TextStyle(
                        fontSize: 16.0, color: darkerSpecialGrey), textAlign: TextAlign.center,
                    )
                ),
              ],
            ),
          )
        )
      );
  }
}

