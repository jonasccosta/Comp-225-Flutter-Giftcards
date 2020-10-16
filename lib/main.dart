import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/Login_Screen.dart';
import 'Databases/Gift_Card_Database.dart';
import 'Databases/User_Info_Database.dart';
import 'Image_Scraping.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  await UserDB.init();
  runApp(MaterialApp(
      home: LoginScreen()
  ));
  //sendFile('assets/images/fakecard8.jpeg');
}