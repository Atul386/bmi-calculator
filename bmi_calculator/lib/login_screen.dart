import 'dart:convert';

import 'package:bmi_calculator/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bmi_calculator_screen.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _showAlertDialog(BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final usersData = prefs.getString('usersData');

    if (usersData == null) {
      _showAlertDialog(context, 'Error', 'No user data found. Please sign up first.');
      return;
    }

    final userDataList = jsonDecode(usersData) as List<dynamic>;
    final enteredUsername = _usernameController.text.trim();
    final enteredPassword = _passwordController.text.trim();

    for (var userData in userDataList) {
      final storedUsername = userData['email'];
      final storedPassword = userData['password'];

      if (enteredUsername == storedUsername && enteredPassword == storedPassword) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BMICalculatorScreen()),
        );
        return;
      }
    }

    _showAlertDialog(context, 'Error', 'Invalid credentials.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username (Email)'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _handleLogin(context),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
