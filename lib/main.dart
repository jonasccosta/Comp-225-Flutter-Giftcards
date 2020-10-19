import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/Login_Screen.dart';
import 'Databases/Gift_Card_Database.dart';
import 'Databases/User_Info_Database.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  await UserDB.init();
  runApp(MaterialApp(

      home: LoginScreen()
  ));
}