import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override //FMO
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String username = '';
  late Map args;

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback is a function that will allow the app to call loadData function after all widgets are mounted, to avoid errors
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {loadData();});
  }

  void loadData() {
    args = ModalRoute.of(context)!.settings.arguments! as Map;
    setState(() {
      username = args['username']; //it depends on your design if you will need this
    });
  }

  @override
  Widget build(BuildContext context) {
    //Follow your UI Design here
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Screen Sample'),
      ),
      body: Center(
        child: Text('Welcome, $username')
      )
    );
  }
}
