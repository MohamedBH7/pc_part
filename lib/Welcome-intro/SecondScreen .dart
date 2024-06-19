import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 500.0,
            width: 1500,
            child: PageView(
              children: [
                _buildImageCard('lib/assets/exp_s.jpg', 'You Can Explorer The Items  -->  '),
                _buildImageCard('lib/assets/cart_s.jpg', 'You can add Items To Your Cart -->'),
                _buildImageCard('lib/assets/setting_s.jpg', 'Setting Page '),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            '\nWelcome ',
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String imagePath, String explanation) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              explanation,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
