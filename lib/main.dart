import 'package:flutter/material.dart';
import 'package:flutter_app/Image_Scrapin.dart';
import 'Database.dart';
import 'Home_Screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(MaterialApp(
      home: MyApp()
  ));
}