import 'package:flutter/material.dart';
import 'package:pc_part/Explorer/explorer_page.dart';

class NotApprovedPage extends StatelessWidget {
  final String userID;

  NotApprovedPage({required this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Approved'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/x.png', // Adjust the path to your image asset
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Your purchase was not approved.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the main page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExplorerPage(userID: '$userID',)),
                );
              },
              child: Text('Back to Main Page'),
            ),
          ],
        ),
      ),
    );
  }
}