import 'package:flutter/material.dart';

class PaymentMethodPageScreen extends StatefulWidget {
  const PaymentMethodPageScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodPageScreen> createState() =>
      _PaymentMethodPageScreenState();
}

class _PaymentMethodPageScreenState extends State<PaymentMethodPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
        title: const Text(
          'Select Payment Method',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            buildMethodTile(
              context,
              title: 'Moov Money',
              subtitle: 'Your mobile wallet',
              imagePath: 'assets/images/Moov.png',
            ),
            buildMethodTile(
              context,
              title: 'Mix by Yassir',
              subtitle: 'Digital bank',
              imagePath: 'assets/images/Yas.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMethodTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/depot');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage(imagePath), radius: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
