import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum(String title) async {
  final http.Response response =  await http.post(
    "https://app.nanonets.com/api/v2/OCR/4d764a71-89d1-4e9a-9053-97d098d599e3/LabelUrls/",
    headers: <String, String>{
      HttpHeaders.authorizationHeader: "Rv1MgHt79liaoa1uLdB5ZSAqJCMe1Hmz:", HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      // HttpHeaders.contentLocationHeader: "https://www.investopedia.com/thmb/mBTc8BmdQbvFCeEtwDxOIovkjC0=/900x0/filters:no_upscale():max_bytes(150000):strip_icc()/capital_one_secured_mastercard_FINAL-579b890d60ac48b3866aa79af690cfb4.png"
      // 'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
  print( response.statusCode);

  if (response.statusCode == 201) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Album {
  final int id;
  final String title;

  Album({this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}


class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  Future<Album> _futureAlbum;

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
                    _futureAlbum = createAlbum(_controller.text);
                  });
                },
              ),
            ],
          )
              : FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data.title);
                return Text(snapshot.data.title);
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