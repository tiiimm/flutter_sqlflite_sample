import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter_mysql_sample/db_connection.dart';
import 'package:flutter_mysql_sample/home.dart';
import 'package:flutter_mysql_sample/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState(); //FMO
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController textUsername = TextEditingController();
  TextEditingController textPassword = TextEditingController();
  bool hidden = true;
  
  Future<bool> verifyPassword(String hashedPassword) async {
    return await FlutterBcrypt.verify(password: textPassword.text, hash: hashedPassword);
  }

  Future<List> login() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.connect();
    final conn = dbHelper.connection;

    var results = await conn!.query('SELECT * FROM users WHERE username= ?', [textUsername.text]);
    List rows = results.map((row) => row.fields).toList();
    if (rows.isNotEmpty) {
      if (await verifyPassword(rows[0]['password'].toString())) {
        return rows;
      }
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    //Follow your UI Design here
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login Screen Sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.black)
              ),
              width: 350,
              child: TextField(
                controller: textUsername,
                decoration: const InputDecoration(
                  border: InputBorder.none, 
                  label: Text('Username')
                ),
              )
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.black)
              ),
              width: 350,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textPassword,
                      decoration: const InputDecoration(
                        border: InputBorder.none, 
                        label: Text('Password')
                      ),
                      obscureText: hidden,
                    )
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        hidden = !hidden;
                      });
                    },
                    icon: Icon(hidden?Icons.visibility:Icons.visibility_off)
                  )
                ],
              )
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 55,
              width: 350,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  backgroundColor: Colors.deepPurple.shade200,
                ),
                onPressed: () {
                  login().then((value) {
                    if (value.isNotEmpty) {
                      sharedPreferences.setString('username', value[0]['username']);
                      Navigator.pushReplacement(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) => HomeScreen(username: value[0]['username']),
                      ),);
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid Credentials'),
                        ),
                      );
                    }
                  });
                },
                child: const Text('Login',
                style: TextStyle(
                  color: Colors.black
                ),)
              )
            )
          ],
        )
      )
    );
  }
}
