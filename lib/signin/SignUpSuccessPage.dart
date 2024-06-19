import 'package:flutter/material.dart';
import 'package:pc_part/Login/Login.dart';
class SignUpSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Sign Up Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/assets/done.png',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Your account has been created successfully!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );              },
              child: Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}