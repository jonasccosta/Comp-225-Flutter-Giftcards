import 'package:flutter/material.dart';
import 'package:flutter_app/Login_Screen.dart';
import 'Databases/Database.dart';
import 'Unused Files/Add_Account_Screen.dart';
import 'User_Info.dart';
import 'Databases/User_Info_Database.dart';
import 'Unused Files/Forgot_Password_Screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  await UserDB.init();
  runApp(MaterialApp(
      home: LoginScreen()
  ));
}