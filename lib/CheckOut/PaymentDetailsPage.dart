import 'package:flutter/material.dart';
import 'package:pc_part/CheckOut/NotApprovedPage.dart';
import 'package:pc_part/CheckOut/ThanksPage.dart';
import 'package:http/http.dart' as http;

class PaymentDetailsPage extends StatelessWidget {
  final String userID;
  final List<String> itemNames;
  final String itemQuantities;
  final String itemID; // Change to String
  final double total;
  final String paymentMethod;

  PaymentDetailsPage({
    required this.userID,
    required this.itemNames,
    required this.itemQuantities,
    required this.itemID, // Update parameter name
    required this.total,
    required this.paymentMethod,
  });


  int _invoiceNumberCounter = 1000; // Start counter from 1000

  Future<void> deletePurchaseRecords(String userID, String itemID, double total, String itemQuantities) async {
    var deleteUrl = Uri.parse('http://192.168.68.111/server/delete_items.php');

    try {
      // Generate invoice number
      var invoiceNumber = getNextInvoiceNumber();

      // Send POST request to delete purchase records
      var deleteResponse = await http.post(
        deleteUrl,
        body: {
          'userID': userID,
          'itemIDs': itemID, // Pass itemID as a string
          'total': total.toString(),
          'itemQuantities': itemQuantities, // Pass itemQuantities as a string
          'invoiceNumber': invoiceNumber.toString(), // Pass invoice number
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

// Function to get the next invoice number in the loop
  int getNextInvoiceNumber() {
    _invoiceNumberCounter++; // Increment counter
    return _invoiceNumberCounter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Payment Details '),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UserID: $userID',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Item ID: $itemID ', // Display Item ID
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                for (int i = 0; i < itemNames.length; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item Name: ${itemNames[i]}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 5), // Add spacing between item name and quantity
                      Text(
                        'Item Quantity: ${itemQuantities[i]}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                SizedBox(height: 10),
                Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                SizedBox(height: 10),
                Text(
                  'Payment Method: $paymentMethod',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print('ItemIDs: $itemID');
                        deletePurchaseRecords(userID, itemID, total, itemQuantities);
                        // Navigate to the thanks page with user ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ThanksPage(userID: userID,  itemIDs: [itemID], total: '$total',),
                          ),
                        );
                      },
                      child: Text('Approved'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the not approved page with user ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotApprovedPage(userID: userID),
                          ),
                        );
                      },
                      child: Text('Not Approved'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
