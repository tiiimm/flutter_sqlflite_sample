import 'package:flutter/material.dart';
import 'package:flutter_mysql_sample/db_connection.dart';
import 'package:flutter_mysql_sample/home.dart';
import 'package:flutter_mysql_sample/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance().then((preference) async {
    sharedPreferences = preference;
    final dbHelper = DatabaseHelper();
    await dbHelper.connect();
    await dbHelper.createTables();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App with MySql Connection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: sharedPreferences.containsKey('username') && sharedPreferences.getString('username')!.isNotEmpty?HomeScreen(username: sharedPreferences.getString('username')):const LoginScreen()
    );
  }
}