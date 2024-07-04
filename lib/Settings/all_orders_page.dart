import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc_part/config.dart';

class AllOrdersPage extends StatefulWidget {
  final String userID;

  const AllOrdersPage({required this.userID});

  @override
  _AllOrdersPageState createState() => _AllOrdersPageState();
}

class _AllOrdersPageState extends State<AllOrdersPage> {
  List<Map<String, dynamic>> _allOrders = [];

  @override
  void initState() {
    super.initState();
    fetchAllOrders();
  }

  void fetchAllOrders() async {
    final response = await http.get(Uri.parse(
        '${Config.apiBaseUrl}/server/setting_data.php?userID=${widget.userID}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _allOrders = List<Map<String, dynamic>>.from(data['allOrders'] ?? []);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('All Orders'),
      ),
      body: ListView.builder(
        itemCount: _allOrders.length,
        itemBuilder: (context, index) {
          final order = _allOrders[index];
          final totalAmount = double.parse(order['totalAmount'].toString());

          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invoice Number: ${order['Invoice_Number']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.green)),
                  Text('Purchase Date: ${order['PurchaseDate']}', style: TextStyle(fontSize: 14)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: order['items'].length,
                    itemBuilder: (context, itemIndex) {
                      final item = order['items'][itemIndex];
                      return Card(
                        child: ListTile(
                          leading: Image.network(item['ImageURL'], width: 50, height: 50),
                          title: Text(item['Name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Category: ${item['Category']}'),
                              Text('Manufacturer: ${item['Manufacturer']}'),
                              Text('Description: ${item['Description']}'),
                              Text('Price: \$${item['Price']}'),
                              Text('shipping: \$10'),
                              Text('Quantity: ${item['ItemQuantities']}'),
                              Text('Review: ${item['Review']}'),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


