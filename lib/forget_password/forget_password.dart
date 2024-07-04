import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc_part/config.dart';

class ForgetPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  void sendEmailRequest(BuildContext context) async {
    var url = Uri.parse('${Config.apiBaseUrl}/server/REQUEST_METHOD.php');
    var response = await http.post(url, body: {'email': emailController.text});

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.body)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to insert email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Forget Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your registered email address to reset your password.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendEmailRequest(context);
              },
              child: Text('Send Request'),
            ),
          ],
        ),
      ),
    );
  }
}