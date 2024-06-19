import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:pc_part/Explorer/explorer_page.dart';

class ThanksPage extends StatelessWidget {
  final String userID;
  final List<String> itemIDs; // Change to a list of strings
  final String total;


  ThanksPage({required this.userID, required this.itemIDs, required this.total});





  // Function to delete purchase records
  Future<void> deletePurchaseRecords(String userID, List<String> itemIDs, double total) async {
    var deleteUrl = Uri.parse('http://192.168.68.111/server/delete_items.php');

    try {
      // Convert itemIDs to comma-separated string
      String itemIDsString = itemIDs.join(',');

      // Send DELETE request to delete purchase records
      var deleteResponse = await http.post(
        deleteUrl,
        body: {
          'userID': userID,
          'itemIDs': itemIDsString,
          'total': total.toString(), // Change 'amount' to 'total' to match PHP
        },
      );

      if (deleteResponse.statusCode == 200) {
        print('Purchase records deleted successfully');
      } else {
        print('Failed to delete purchase records');
      }
    } catch (e) {
      print('Error deleting purchase records: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('UserID: $userID');

    // Print the list of integers

    print('ItemIDs: $itemIDs');
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanks for Your Purchase'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/done.png', // Adjust the path to your image asset
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Thank you for your purchase,',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (itemIDs.isNotEmpty) // Display each item ID if not empty
              for (var item in itemIDs)
                Text(
                  'item: $item',
                  style: TextStyle(fontSize: 18),
                ),
            if (itemIDs.isEmpty) // Display a message if the list is empty
              Text(
                'No items found.',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ExplorerPage(userID: '$userID')));

              },
              child: Text('Back To Home Page'),
            ),

          ],
        ),
      ),
    );
  }
}
