import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc_part/config.dart';
import 'dart:convert';
import '../Explorer/explorer_page.dart';
import '../forget_password/forget_password.dart';
import '../signin/sign.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> loginUser(BuildContext context) async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    // Check if username or password is empty
    if (username.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Email and password are required.'),
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

    setState(() {
      _isLoading = true;
    });

    var url = Uri.parse('${Config.apiBaseUrl}/server/login.php');
    var response = await http.post(url, body: {
      'Email': username,
      'password': password,
    });

    var data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      // Login successful, navigate to ExplorerPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ExplorerPage(userID: data['UserID'].toString())),
      );
    } else {
      // Login failed, display error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Error'),
            content: Text(data['message']),
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

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            // Clear text fields on refresh
            usernameController.clear();
            passwordController.clear();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 13,),
                SizedBox(
                  height: 160,
                  child: Image.asset('lib/assets/login_n.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 68,
                        ),
                      ),
                      SizedBox(height: 100),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: !_isLoading ? () => loginUser(context) : null,
                        child: _isLoading ? CircularProgressIndicator() : Text("Login"),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgetPassword()),
                          );
                        },
                        child: Text(
                          "Forget Password ? ",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Sign()),
                          );
                        },
                        child: Text(
                          "Don't Have Account Yet! , Join Us",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.red,
                          ),
                        ),
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
  }
}
