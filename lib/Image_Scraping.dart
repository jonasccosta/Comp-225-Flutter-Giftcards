import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageScrape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scraping Image Data',
      home: ImageScraping(),
    );
  }
}


class ImageScraping extends StatefulWidget{

  ImageScraping({Key key}) : super(key: key);

  @override
  _ImageScraperState createState() => _ImageScraperState();
}

class _ImageScraperState extends State<ImageScraping> {
  Future<Album> futureAlbum;
  @override
  void initState() {
    futureAlbum = fetchAlbum();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("fetching data testing")
        ),
        body: Center(
           child: FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.title);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            )
      )
    );
  }
}

Future<Album> fetchAlbum() async {
  final response =
  await http.get('https://api.ocr.space/parse/image', headers: {HttpHeaders.authorizationHeader: "5ca29a008488957", HttpHeaders.connectionHeader:
  "https://www.google.com/url?sa=i&url=https%3A%2F%2Ffliphtml5.com%2Facti%2Fktam%2Fbasic%2F51-100&psig=AOvVaw0utyDt3r4EitKS6p-GF6Fx&ust=1602006781429000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCPCiib2CnuwCFQAAAAAdAAAAABAI"});

  if(response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}