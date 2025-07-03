import 'package:flutter/material.dart';

class PaymentMethodPageScreen extends StatefulWidget {
  const PaymentMethodPageScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodPageScreen> createState() =>
      _PaymentMethodPageScreenState();
}

class _PaymentMethodPageScreenState extends State<PaymentMethodPageScreen> {
  String? selectedMethod;
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Sans',
            ),
            children: [
              TextSpan(
                text: 'e',
                style: TextStyle(color: Color.fromRGBO(33, 150, 243, 1)),
              ),
              TextSpan(text: 'tontine', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Sélectionner un moyen de paiement',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              buildMethodTile(
                title: 'Moov Money',
                subtitle: 'Portefeuille mobile',
                imagePath: 'assets/images/Moov.png',
                methodKey: 'moov',
              ),
              buildMethodTile(
                title: 'Mix by Yassir',
                subtitle: 'Banque digitale',
                imagePath: 'assets/images/Yas.png',
                methodKey: 'yas',
              ),
              if (selectedMethod != null) ...[
                const SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Entrez votre numéro',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (phoneController.text.isNotEmpty &&
                          selectedMethod != null) {
                        Navigator.pushNamed(
                          context,
                          '/depot',
                          arguments: {
                            'service': selectedMethod,
                            'phone': phoneController.text.trim(),
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Suivant',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMethodTile({
    required String title,
    required String subtitle,
    required String imagePath,
    required String methodKey,
  }) {
    final isSelected = selectedMethod == methodKey;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = methodKey;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightBlue[100] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected
                  ? Border.all(color: Colors.blueAccent, width: 2)
                  : null,
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
