import 'package:flutter/material.dart';
import 'package:flutter_mysql_sample/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.username});
  final String? username;

  @override //FMO
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String username = '';

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback is a function that will allow the app to call loadData function after all widgets are mounted, to avoid errors
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {loadData();});
  }

  void loadData() {
    setState(() {
      username = widget.username!; //it depends on your design if you will need this
    });
  }

  @override
  Widget build(BuildContext context) {
    //Follow your UI Design here
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Screen Sample'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    backgroundColor: Colors.white,
                    title: const Text('Logout Confirmation'),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ))
                        ),
                        child: const Text("No"),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ))
                        ),
                        child: const Text("Yes"),
                        onPressed: () {
                          SharedPreferences.getInstance().then((sharedPreferences) {
                            sharedPreferences.setString('username', '');
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (BuildContext context) => const LoginScreen(),
                            ));
                          });
                        },
                      ),
                    ],
                  );
                }
              );
            }, 
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: Center(
        child: Text('Welcome, $username')
      )
    );
  }
}
