import 'package:flutter/material.dart';
import '../Login/Login.dart';

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Get Started \n"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to the login page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Text("Get Started"),
          ),
        ],
      ),
    );
  }
}
