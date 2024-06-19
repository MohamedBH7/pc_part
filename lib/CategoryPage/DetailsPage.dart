import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class DetailsPage extends StatefulWidget {
  final String category;
  final String description;
  final String imageURL;
  final String price;
  final String review;
  final String quantityAvailable;
  final String userID;
  final String itemID;
  final String name;


  DetailsPage({
    required this.category,
    required this.description,
    required this.imageURL,
    required this.price,
    required this.review,
    required this.quantityAvailable,
    required this.userID,
    required this.itemID,
    required this.name,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int quantity = 1;
  String dateShip = '';
  String formattedDate = '';
  String shippingAddress = '';
  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filterRelatedProducts();
    printDateAfterThreeDays();
    showShippingAddress();

  }

  void filterRelatedProducts() async {
    try {
      var filteredData = await fetchDataForCategory(widget.name);
      setState(() {
        filteredProducts = (filteredData as List<Map<String, dynamic>>?) ?? [];
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to fetch related products: $e"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<Map<String, dynamic>>?> fetchDataForCategory(String name) async {
    var categoryName = name.split(' ').first;
    var url = "http://192.168.68.111/server/filter.php?Name=$categoryName";
    try {
      var res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        var decodedData = jsonDecode(res.body);

        if (decodedData is List && decodedData.isEmpty) {
          print("No data found for category: $categoryName");
          return null;
        }

        if (decodedData is List &&
            decodedData.isNotEmpty &&
            decodedData.first is Map<String, dynamic>) {
          return List<Map<String, dynamic>>.from(decodedData);
        } else {
          throw Exception("Invalid data format received from the server.");
        }
      } else {
        throw Exception(
            "Failed to load data for category $categoryName. Status code: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch data for category $categoryName: $e");
    }
  }

  Future<void> _refreshData() async {
    filterRelatedProducts();
  }

  void addToCart() async {
    var url = Uri.parse('http://192.168.68.111/server/add_to_cart.php');
    var response = await http.post(url, body: {
      'UserID': widget.userID,
      'ItemID': widget.itemID,
      'Quantity': quantity.toString(),
      'Name': widget.name,
      'Description': widget.description,
      'Price': widget.price,
      'Category': widget.category,
      'ImageURL': widget.imageURL,
      'Review': widget.review,
      'QuantityAvailable': widget.quantityAvailable,
    });

    if (response.statusCode == 200) {
      if (response.body.contains('add done')) {
        print("done");

      } else {
        // Handle other cases if needed
      }
    } else {
      print('Failed to add item to cart. Error: ${response.statusCode}');
    }
  }

  void printDateAfterThreeDays() {
    // Get current date and time
    DateTime now = DateTime.now();

    // Add 3 days to the current date
    DateTime afterThreeDays = now.add(Duration(days: 3));
     formattedDate = DateFormat('yyyy-MM-dd').format(now);

    setState(() {
      // Update dateShip with the formatted date after 3 days
      dateShip = '${afterThreeDays.toString().split(' ')[0]}';

    });

  }

  void showShippingAddress() async {
    var url = Uri.parse('http://192.168.68.111/server/show_shipping_address.php');
    var response = await http.post(url, body: {
      'UserID': widget.userID,
    });

    if (response.statusCode == 200) {
      // Assuming response.body contains JSON data of shipping address
      var addressData = jsonDecode(response.body);
      // Update the shippingAddress variable
      setState(() {
        shippingAddress = addressData['address'];
      });

    } else {
      print('Failed to fetch shipping address. Error: ${response.statusCode}');
    }
  }

// Widget build and other functions remain unchanged...


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Details'),
    ),
    body: RefreshIndicator(
    onRefresh: _refreshData,
    child: SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    AspectRatio(
    aspectRatio: 16 / 15,
    child: Image.network(
    widget.imageURL,
    fit: BoxFit.contain,
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Category: ${widget.category}',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8),
    Text(
    'Name: ${widget.name}',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 20),
    Text(
    'Description: ${widget.description}',
    style: TextStyle(fontSize: 20),
    ),
      SizedBox(height: 8),
      Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          'Price: ${widget.price}',
          style: TextStyle(fontSize: 16, color: Colors.green),
        ),
      ),

    SizedBox(height: 8),
    Text(
    'Quantity Available: ${widget.quantityAvailable}',
    style: TextStyle(fontSize: 20),
    ),
    Text(
    'Rate : \n ${widget.review}',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 16),
    Row(
    children: [
    GestureDetector(
    onTap: quantity > 1 ? () => setState(() => quantity--) : null,
    child: Image.asset(
    'lib/assets/download-removebg-preview (2).png',
    height: 24,
    width: 24,
    ),
    ),
    SizedBox(width: 16),
      Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          'Quantity: $quantity',
          style: TextStyle(fontSize: 18, color: Colors.green),
        ),
      ),

      SizedBox(width: 16),
    GestureDetector(
    onTap: quantity < int.parse(widget.quantityAvailable) ? () => setState(() => quantity++) : null,
    child: Image.asset(
    'lib/assets/above.png',
    height: 24,
    width: 24,
    ),
    ),
    ],
    ),
    SizedBox(width: 17),
      Text(
        '\n'

      ),

      Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\n Shipping Information: \n',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Text(
              'Expected Shipping Date:  $formattedDate',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Shipping From: Bahrain-pcparts',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Shipping To: \n ($shippingAddress)',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Estimated Delivery Date: $dateShip                                          ',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Shipping Cost: \$10.00',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),


    ElevatedButton(
    onPressed: quantity <= int.parse(widget.quantityAvailable) ? addToCart : null,

    child: Text('Add to Cart'),
    ),
    SizedBox(height: 20),
    Text(
    'Return Policy',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8),
      Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          'Our return policy aims to provide you with peace of mind when making a purchase from our store. We understand that sometimes items may need to be returned or exchanged, and we want to make this process as smooth as possible for you.\n\n'
              '1. 30-Day Return Policy: We offer a 30-day return policy for most items purchased from our store. If you\'re not completely satisfied with your purchase, you may return it within 30 days of receipt for a full refund or exchange.\n\n'
              '2. Conditions for Returns: To be eligible for a return, the item must be unused and in the same condition that you received it. It must also be in the original packaging.\n\n'
              '3. Exclusions: Please note that certain items, such as perishable goods, personalized items, and gift cards, are exempt from being returned.\n\n'
              '4. Return Procedure: To initiate a return, please contact our customer service team. They will provide you with instructions on how to return the item and assist you throughout the process.\n\n'
              '5. Refund Process: Once your return is received and inspected, we will send you an email to notify you that we have received your returned item. We will also notify you of the approval or rejection of your refund. If approved, your refund will be processed, and a credit will automatically be applied to your original method of payment.\n\n'
              '6. Shipping Costs: Please note that shipping costs are non-refundable. If you receive a refund, the cost of return shipping will be deducted from your refund.\n\n'
              '7. Damaged or Defective Items: If you receive a damaged or defective item, please contact us immediately. We will arrange for a replacement or refund, depending on the circumstances.\n\n'
              '8. Final Sale Items: Certain items may be marked as final sale and are not eligible for return or exchange. Please check the product description carefully before making your purchase.\n\n'
              '9. Exceptions: In some cases, exceptions to our return policy may be made at our discretion. If you have any questions or concerns about our return policy, please don\'t hesitate to contact us.\n\n'
              '10. Policy Changes: We reserve the right to update or modify our return policy at any time. Any changes will be effective immediately upon posting on our website.',
          style: TextStyle(fontSize: 16),
        ),
      )

    ],
    ),
    ),



      SizedBox(height: 20),
      Text(
        'Related Products',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      Container(
        height: 200,
        child: filteredProducts.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final relatedProduct = filteredProducts[index];
            return Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  if (relatedProduct['Category'] != null &&
                      relatedProduct['Description'] != null &&
                      relatedProduct['ImageURL'] != null &&
                      relatedProduct['Price'] != null &&
                      relatedProduct['Review'] != null &&
                      relatedProduct['QuantityAvailable'] != null &&
                      relatedProduct['ItemID'] != null &&
                      relatedProduct['Name'] != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          category: relatedProduct['Category'],
                          description: relatedProduct['Description'],
                          imageURL: relatedProduct['ImageURL'],
                          price: relatedProduct['Price'],
                          review: relatedProduct['Review'],
                          quantityAvailable: relatedProduct['QuantityAvailable'],
                          userID: widget.userID,
                          itemID: relatedProduct['ItemID'],
                          name: relatedProduct['Name'],
                        ),
                      ),
                    );
                  } else {
                    // Display a message indicating that details are not available
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Details for this item are not available Right Now.'),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Card(
                    child: Column(
                      children: [
                        Image.network(
                          relatedProduct['ImageURL'],
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                relatedProduct['Name'],
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                relatedProduct['Price'],
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      ],
    ),
    ),
    ),
    );
  }
}
