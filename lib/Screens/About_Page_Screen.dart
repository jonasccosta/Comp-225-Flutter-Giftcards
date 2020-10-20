import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// About Screen, contains general information about the app.
class AboutPageScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        title: 'About',
        home: Scaffold(
          appBar: AppBar(title: Text('About'),
              centerTitle: true,
              backgroundColor: Color(0xff1100FF),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),

          body: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                child: Image(
                    image: AssetImage("assets/logo.png")),
              ),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text("This app was developed for COMP 225 at Macalester College", style: TextStyle(
                      fontSize: 16.0, color: Colors.black), textAlign: TextAlign.center,
                  )
              ),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text("All gift card data is stored locally on your device.", style: TextStyle(
                      fontSize: 16.0, color: Colors.black), textAlign: TextAlign.center,
                  )

              ),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text("We are not liable if any of your gift cards get stolen.", style: TextStyle(
                      fontSize: 16.0, color: Colors.black), textAlign: TextAlign.center,
                  )
              ),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text("We kinda need more things on this page. So here's some jokes.", style: TextStyle(
                      fontSize: 16.0, color: Colors.black), textAlign: TextAlign.center
                ),
              ),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text("Nope")
              )
            ],
          ),
        )
    );
  }
}

