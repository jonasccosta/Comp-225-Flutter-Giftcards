import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:open_file/open_file.dart';

import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:path_provider/path_provider.dart';

// main() async {
//   var client = http_auth.BasicAuthClient('thayes@macalester.edu', );
//   var response = client.post('https://app.nanonets.com/api/v2/OCR/Model/4d764a71-89d1-4e9a-9053-97d098d599e3/LabelFile/');
// }

Future<String> sendFile(String title) async {
  final response =  await http.post(
    'http://192.168.0.4:5000/',
     headers:{
      'Content-Type': 'application/json',
     },
     body: jsonEncode({
      //PUT IMAGE PATH FROM CAMERA HERE the value for the key 'file'
      'file': '/Users/tommyhayes/AndroidStudioProjects/Comp-225-Flutter-Giftcards/lib/fakecard10.jpeg',
    }),
   );

  print(response.statusCode);

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    // return Album.fromJson(jsonDecode(response.body));
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to create album.');
  }
 }

// class Album {
//   final int id;
//   final String title;
//
//   Album({this.id, this.title});
//
//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       id: json['id'],
//       title: json['title'],
//     );
//   }
// }

//
//run this in the main
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

//UI TO SEND TEST REQUEST TO SERVERS
class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  Future<String> _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null)
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Enter Title'),
              ),
              RaisedButton(
                child: Text('Create Data'),
                onPressed: () {
                  setState(() {
                    _futureAlbum = sendFile(_controller.text);
                  });
                },
              ),
            ],
          )
              : FutureBuilder<String>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return Text(snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}