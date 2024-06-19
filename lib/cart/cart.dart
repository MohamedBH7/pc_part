import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc_part/CheckOut/PaymentPage.dart';

class BasketPage extends StatefulWidget {
  final String userID;

  const BasketPage({required this.userID});

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  List<Map<String, dynamic>> basketItems = [];
  double total = 0.0;
  double shipping = 0.0;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    fetchBasketItems();
  }

  Future<void> fetchBasketItems() async {
    var url = Uri.parse('http://192.168.68.111/server/select_Basket_data.php');
    var response = await http.post(url, body: {'UserID': widget.userID});

    if (response.statusCode == 200) {
      setState(() {
        basketItems = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        basketItems.forEach((item) {
          item['isSelected'] = true;
        });
        calculateTotal();
      });
    } else {
      print('Failed to fetch basket items');
    }
  }

  void checkout() {
    List<String> selectedItemsIDs = [];
    for (var item in basketItems) {
      if (item['isSelected']) {
        selectedItemsIDs.add(item['ItemID'].toString());
      }
    }

    if (selectedItemsIDs.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No Items Selected'),
            content: Text('Please select at least one item to check out.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          userID: widget.userID,
          itemName: getItemNames(),
          itemQuantity: getItemQuantities(),
          total: total,
          itemID: selectedItemsIDs.join(','), // Join IDs into a string
          itemNames: [],
          itemQuantities: [],
          paymentMethod: '', // Pass the payment method here
        ),
      ),
    );
  }

  String getItemNames() {
    List<String> selectedItems = [];
    for (var item in basketItems) {
      if (item['isSelected']) {
        selectedItems.add(item['Name']);
      }
    }
    return selectedItems.join(', ');
  }

  String getItemQuantities() {
    List<String> quantities = [];
    for (var item in basketItems) {
      if (item['isSelected']) {
        quantities.add(item['Quantity'].toString());
      }
    }
    return quantities.join(', ');
  }

  void calculateTotal() {
    double sum = 0.0;
    bool anyItemSelected = false;

    for (var item in basketItems) {
      if (item['isSelected']) {
        sum += double.parse(item['Price']);
        anyItemSelected = true;
      }
    }

    setState(() {
      if (anyItemSelected) {
        shipping = 10.00;
      } else {
        shipping = 0.00;
      }

      total = sum + shipping;
      isButtonEnabled = anyItemSelected;
    });
  }

  void toggleItemSelection(int index) {
    setState(() {
      basketItems[index]['isSelected'] = !basketItems[index]['isSelected'];
      calculateTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Basket'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchBasketItems,
        child: Column(
          children: [
            Expanded(
              child: basketItems.isEmpty
                  ? Center(
                child: Text('Your basket is empty.'),
              )
                  : ListView.builder(
                itemCount: basketItems.length,
                itemBuilder: (context, index) {
                  final item = basketItems[index];
                  return Card(
                    elevation: 2.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(item['ImageURL']),
                        radius: 25,
                      ),
                      title: Text(item['Name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity: ${item['Quantity']}'),
                          Text('ItemID: ${item['ItemID']}'),
                        ],
                      ),
                      trailing: Checkbox(
                        value: item['isSelected'],
                        onChanged: (value) {
                          toggleItemSelection(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: basketItems.length,
                    itemBuilder: (context, index) {
                      final item = basketItems[index];
                      if (item['isSelected']) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'ItemID:${item['ItemID']} Item Name : ${item['Name']} \nQuantity : ${item['Quantity']} ',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Shipping:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${shipping.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isButtonEnabled ? Colors.blue : Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      onPressed: checkout,
                      child: Text(
                        'Checkout',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
