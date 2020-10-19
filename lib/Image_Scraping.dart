import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


/// Used to send files to app.nanonets.com API
Future<Map> sendFile(String filePath) async {
  var url =    Uri.parse('https://app.nanonets.com/api/v2/OCR/Model/4d764a71-89d1-4e9a-9053-97d098d599e3/LabelFile/');
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
  print(streamString);
  Map<String, dynamic> json = jsonDecode(streamString);
  Map<String, String> d = {};
  d['card number'] = json['result'][0]['prediction'][0]['ocr_text'];
  print(d['card number']);
  d['expiration date'] = json['result'][0]['prediction'][1]['ocr_text'];
  print(d['expiration date']);
  return d;

  }



