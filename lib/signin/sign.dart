import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pc_part/signin/Term.dart';

import 'SignUpSuccessPage.dart';

class Sign extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<Sign> {
  bool _agreeToTerms = false;
  String _birthday = '';
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _address = '';
  String _phoneNumber = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthday = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _signUp() async {
    // Validate form data
    if (_fullName.isEmpty ||
        _email.isEmpty ||
        _password.isEmpty ||
        _confirmPassword.isEmpty ||
        _birthday.isEmpty ||
        _address.isEmpty ||
        _phoneNumber.isEmpty) {
      // Show error message if any field is empty
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    // Check if passwords match
    if (_password != _confirmPassword) {
      // Show error message if passwords don't match
      _showErrorDialog('Passwords do not match.');
      return;
    }

    // Validate email format
    if (!_isValidEmail(_email)) {
      _showErrorDialog('Invalid email format.');
      return;
    }

    // Validate phone number length
    if (_phoneNumber.length != 8) {
      _showErrorDialog('Phone number must be 8 digits long.');
      return;
    }

    // Send form data to PHP script
    final response = await http.post(
      Uri.parse('http://192.168.68.111/server/sign.php'),
      body: {
        'full_name': _fullName,
        'email': _email,
        'password': _password,
        'birthday': _birthday,
        'address': _address,
        'phone_number': _phoneNumber,
      },
    );

    if (response.body.contains('Email already exists')) {
      // Email already exists in the database
      _showErrorDialog('Email already exists. Please use a different email.');
    } else if (response.body.contains('Password must be at least 8 characters long')) {
      // Password is not long enough
      _showErrorDialog('Password must be at least 8 characters long.');
    } else if (response.statusCode == 200) {
      // Data inserted successfully
      print('Sign Up Successful');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpSuccessPage()),
      );
    } else {
      // Error occurred
      print('Error: ${response.body}');
      // Show error message on screen
      _showErrorDialog('An error occurred. Please try again later.');
    }
  }

  bool _isValidEmail(String email) {
    // Simple email validation using a regular expression
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Sign Up Page'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (value) {
                    _fullName = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    _email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    _password = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    _confirmPassword = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(text: _birthday),
                      decoration: InputDecoration(
                        labelText: 'Select Birthday',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    _address = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '+973',
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        onChanged: (value) {
                          _phoneNumber = value;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'PHONE',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value!;
                        });
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Terms screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Terms()),
                        );
                      },
                      child: Text(
                        "Our Term ",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _agreeToTerms ? _signUp : null,
                  child: Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
