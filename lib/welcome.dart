import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _username = '';

  @override
  void initState() {
    _loadUsername();
    super.initState();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $_username!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.remove('username');
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
