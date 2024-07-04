import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pc_part/config.dart';
class AccountPage extends StatefulWidget {
  final String userID;

  const AccountPage({Key? key, required this.userID}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    _userData = {};
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    var url = Uri.parse('${Config.apiBaseUrl}/server/select_User_data.php');
    var response = await http.post(url, body: {'UserID': widget.userID});

    if (response.statusCode == 200) {
      setState(() {
        _userData = jsonDecode(response.body);
      });
    } else {
      print('Failed to fetch user data');
    }
  }

  Widget _buildDataRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                value,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Account Page'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('lib/assets/user.png'),
              ),

              SizedBox(height: 24),
              if (_userData.isNotEmpty) ...[
                _buildDataRow('Username', _userData['Username'] ?? 'N/A'),
                _buildDataRow('Email', _userData['Email'] ?? 'N/A'),
                _buildDataRow('Address', _userData['Address'] ?? 'N/A'),
                _buildDataRow('Phone ', '+973 '+_userData['Phone'] ?? 'N/A'),
                _buildDataRow('User ID', '# '+_userData['UserID'] ?? 'N/A'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
