import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState(); //FMO
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController textUsername = TextEditingController();
  TextEditingController textPassword = TextEditingController();
  bool hidden = true;

  Future<List<Map>> login() async {
    Database db = await openDatabase('example_database.db');
    //below are two approaches to execute query, choose whichever you are comfortable with.
    // final List<Map> users = await db.query('users', where: 'username=? AND password=?', whereArgs: [textUsername.text, textPassword.text]);
    final List<Map> users = await db.rawQuery('SELECT * FROM users WHERE username=? AND password=?', [textUsername.text, textPassword.text]);
    db.close();
    return users;
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
                      Navigator.pushReplacementNamed(context, '/home', arguments: {'userId': value[0]['id'], 'username': value[0]['username']});
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
