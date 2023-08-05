import 'package:bmi_calculator/signup_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo image
            Image.asset(
              'assets/welcome.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            // Title
            Text(
              'Let’s help you get better!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Description
            Text(
              'This app can you calculate your body mass index (BMI). '
                  'Your BMI can help you determine if you are at a healthy weight, or if you need to make changes to your diet or exercise habits.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            // Get Started Button
            ElevatedButton(
              onPressed: () {
                // Add any navigation logic here to move to the next screen
                // For example:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              child: Text('Get Started'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
