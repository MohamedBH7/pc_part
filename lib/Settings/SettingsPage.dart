import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc_part/Settings/all_orders_page.dart';
import 'package:pc_part/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final String userID;

  const SettingsPage({required this.userID});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _prefs;
  String _selectedLanguage = 'English';
  String _name = '';
  String _address = '';
  String _phone = '';
  double _spend = 0;
  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> AOrders = [];

  final String _appVersion = '1.0.0';
  final String _appDeveloper = 'Mohamed Alsaffar';
  final String _appRegion = 'Bahrain';
  final String _thecurrency = 'USD';

  @override
  void initState() {
    super.initState();
    initPrefs();
    fetchData();
  }

  void initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = _prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  void fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          '${Config.apiBaseUrl}/server/setting_data.php?userID=${widget.userID}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _name = data['userInfo']['Username'] ?? '';
          _address = data['userInfo']['Address'] ?? '';
          _phone = data['userInfo']['Phone'] ?? '';
          _orders = List<Map<String, dynamic>>.from(data['recentOrders'] ?? []);
          _spend = double.parse(data['spend'].toString() ?? '0');
          AOrders = List<Map<String, dynamic>>.from(data['allOrders'] ?? []);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text('Settings'),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Version: $_appVersion'),
                Text('Developer: $_appDeveloper'),
                Text('Region: $_appRegion'),
                Text('The currency: $_thecurrency'),
                SizedBox(height: 16),
                Text(
                  'Language',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text('English'),
                  onTap: () {
                    // Action for changing language
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'User Information ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text('Name : $_name'),
                  onTap: () {
                    _editName();
                  },
                ),
                ListTile(
                  title: Text('Shipping Address : $_address'),
                  onTap: () {
                    _editAddress();
                  },
                ),
                ListTile(
                  title: Text('Phone :+973  $_phone'),
                  onTap: () {
                    _editPhone();
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Additional Options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text('All Orders :${AOrders.length} '),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllOrdersPage(userID: widget.userID),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('My Current Orders (${_orders.length})'),
                  subtitle: Text('\nOn Shipping  '),
                  onTap: () {
                    // Action for viewing current orders
                  },
                  trailing: ImageIcon(
                    AssetImage('lib/assets/pc.png'),
                    size: 24,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _orders.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> order = _orders[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('      Order ${order['Invoice_Number']}'),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: order['items']?.length ?? 0,
                            itemBuilder: (context, itemIndex) {
                              var item = order['items'][itemIndex];
                              return ListTile(
                                leading: Image.network(
                                  item['ImageURL'],
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(item['Name']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Purchase Date: ${order['PurchaseDate']}'),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Price: \$${item['Price']}'),
                                        Text('Shipping: \$10'),
                                        Text('Quantity: ${item['ItemQuantities']}'),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Action for tapping on an order item
                                },
                              );
                            },
                          ),

                        ],
                      );
                    },
                  )
                      : Center(child: Text('No current orders')),
                ),
                ListTile(
                  title: Text(
                    'My Spend: \$$_spend',
                    style: TextStyle(color: Colors.green),
                  ),
                  onTap: () {
                    // Action for viewing spend details
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _editName() async {
    final newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Name'),
          content: TextFormField(
            initialValue: _name,
            decoration: InputDecoration(hintText: 'Enter your new name'),
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, _name),
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newName != null) {
      setState(() {
        _name = newName;
        updateUserInfo('Username', newName);
      });
    }
  }

  Future<void> _editAddress() async {
    final newAddress = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Address'),
          content: TextFormField(
            initialValue: _address,
            decoration: InputDecoration(hintText: 'Enter your new address'),
            onChanged: (value) {
              setState(() {
                _address = value;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, _address),
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newAddress != null) {
      setState(() {
        _address = newAddress;
        updateUserInfo('Address', newAddress);
      });
    }
  }

  Future<void> _editPhone() async {
    final newPhone = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Phone'),
          content: TextFormField(
            initialValue: _phone,
            decoration: InputDecoration(hintText: 'Enter your new phone number'),
            onChanged: (value) {
              setState(() {
                _phone = value;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, _phone),
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newPhone != null) {
      setState(() {
        _phone = newPhone;
        updateUserInfo('Phone', newPhone);
      });
    }
  }

  void updateUserInfo(String field, String value) async {
    final uri = Uri.parse('${Config.apiBaseUrl}/server/update.php');
    final body = {
      'userID': widget.userID,
      'field': field,
      'value': value,
    };

    print('Sending update request: $body');

    try {
      final response = await http.post(uri, body: body);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        print('Update successful: $field = $value');
      } else {
        print('Failed to update $field. Message: ${responseData['message']}');
        _showErrorDialog(responseData['message']);
      }
    } catch (e) {
      print('Error updating $field: $e');
      _showErrorDialog('An error occurred. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}