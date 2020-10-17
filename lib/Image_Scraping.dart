import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http_parser/http_parser.dart';


/// Used to send files to app.nanonets.com API
Future<String> sendFile(String filePath) async {
  // 'http://192.168.0.4:5000/',
  // 'https://app.nanonets.com/api/v2/OCR/Model/4d764a71-89d1-4e9a-9053-97d098d599e3/LabelUrls/',
  var url =    Uri.parse('https://app.nanonets.com/api/v2/OCR/Model/4d764a71-89d1-4e9a-9053-97d098d599e3/LabelFile/');
  //     headers: {
  //       'authorization': 'Basic UnYxTWdIdDc5bGlhb2ExdUxkQjVaU0FxSkNNZTFIbXo6',
  //       'accept': 'application/x-www-form-urlencoded'
  //     },
  //     body: {
  //       //'urls':'https://www.suntrust.com/content/dam/suntrust/us/en/credit-card/card-art/consumer-secured-mc.png'
  //       //PUT IMAGE PATH FROM CAMERA HERE
  //       'file': 'assets/images/fakecard10.jpeg'
  //       // Image.asset(filePath)
  //           //.readAsBytesSync(),
  //
  //       await rootBundle.load('assets/images/fakecard8.jpeg')
  //     }
  // );
  // var audioByteData = await rootBundle.load('assets/images/fakecard8.jpeg');
  // var audioUint8List = audioByteData.buffer.asUint8List(audioByteData.offsetInBytes, audioByteData.lengthInBytes);
  // List<int> audioListInt = audioUint8List.cast<int>();


  var request = new http.MultipartRequest("POST",  url);
  request.headers['authorization'] = 'Basic UnYxTWdIdDc5bGlhb2ExdUxkQjVaU0FxSkNNZTFIbXo6';
  request.headers['accept'] = 'application/json';
  // var byteFile = new http.MultipartFile.fromBytes('file',
  //     audioListInt, filename: 'fakecard8.jpeg', contentType: new MediaType('image', 'jpeg'));
  request.files.add(await http.MultipartFile.fromPath('file', filePath));
  //request.files.add(byteFile);
  var response = await request.send();


  print(response.statusCode);
  var streamString = await response.stream.bytesToString();
  Map<String, dynamic> json = jsonDecode(streamString);
  Map<String, String> d = {};
  d['card number'] = json['result'][0]['prediction'][0]['ocr_text'];
  print(d['card number']);
  d['expiration date'] = json['result'][0]['prediction'][1]['ocr_text'];
  print(d['expiration date']);

 //
 //  if (response.statusCode == 200) {
 //    print(jsonDecode(response.body));
 //    print(jsonDecode(response.body)['Card Number']);
 //    print(jsonDecode(response.body)['Expiration Date']);
 //
 //    // return Album.fromJson(jsonDecode(response.body));
 //    return jsonDecode(response.body);
 //  } else {
 //    throw Exception('Failed to create album.');
 //  }
  }



//run this in the main to test
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