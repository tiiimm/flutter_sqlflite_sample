import 'package:flutter/material.dart';
import 'package:flutter_sqlflite_sample/home.dart';
import 'package:flutter_sqlflite_sample/login.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
} //FMO

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void initializeDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'example_database.db'); //database name is up to you
    openDatabase(path, onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, gender TEXT, username TEXT, password TEXT)');  //table name is users, follow the required fields. This is just for sample
      
      //The two lines below is supposed to be part of your registration screen, I just included it here to have dummy data for login
      await db.insert('users', {'name': 'Tim', 'gender': 'female', 'username': 'timtim', 'password': 'timtim'});
      await db.rawInsert('INSERT into users(name, gender, username, password) VALUES("arfel", "male", "arfel", "arfel")');
    }, version: 1).then((value) => value.close());
  }

  @override
  Widget build(BuildContext context) {
    initializeDatabase(); //Create database and tables. Only called once on the app's first run. If you make errors, you might need to delete your app and rebuild again
    return MaterialApp(
      title: 'Sample App with SQL Lite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
      home: const LoginScreen()
    );
  }
}