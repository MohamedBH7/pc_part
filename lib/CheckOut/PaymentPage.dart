import 'package:flutter/material.dart';
import 'package:pc_part/CheckOut/PaymentDetailsPage.dart';

class PaymentPage extends StatelessWidget {
  final String userID;
  final String itemName;
  final String itemQuantity;
  final double total;
  final String itemID; // Change the type to String
  final List<String> itemNames;
  final List<String> itemQuantities;
  final String paymentMethod;

  PaymentPage({
    required this.userID,
    required this.itemName,
    required this.itemQuantity,
    required this.total,
    required this.itemID, // Change the type to String
    required this.itemNames,
    required this.itemQuantities,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PaymentMethodCard(
                  imagePath: 'lib/assets/visa.png',
                  label: 'Visa',
                  onTap: () {
                    _navigateToPaymentDetails(context, 'Visa', itemID as String);
                  },
                ),
                PaymentMethodCard(
                  imagePath: 'lib/assets/mastercard.png',
                  label: 'Mastercard',
                  onTap: () {
                    _navigateToPaymentDetails(context, 'Mastercard', itemID as String);
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PaymentMethodCard(
                  imagePath: 'lib/assets/cash.png',
                  label: 'Cash',
                  onTap: () {
                    _navigateToPaymentDetails(context, 'Cash', itemID as String);
                  },
                ),
                PaymentMethodCard(
                  imagePath: 'lib/assets/benefitpay.png',
                  label: 'BenefitPay',
                  onTap: () {
                    _navigateToPaymentDetails(context, 'BenefitPay', itemID as String);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPaymentDetails(BuildContext context, String selectedMethod, String itemID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDetailsPage(
          userID: userID,
          itemNames: itemNames,
          total: total,
          paymentMethod: selectedMethod,
          itemID: itemID, itemQuantities: '$itemQuantity', // Pass itemID to PaymentDetailsPage
        ),
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const PaymentMethodCard({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(imagePath, width: 80, height: 80),
              SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
