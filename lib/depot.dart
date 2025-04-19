import 'package:flutter/material.dart';

class SendMoneyPageScreen extends StatefulWidget {
  const SendMoneyPageScreen({Key? key}) : super(key: key);

  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPageScreen> {
  String inputAmount = '';

  void onKeyboardTap(String value) {
    setState(() {
      if (value == 'del') {
        if (inputAmount.isNotEmpty) {
          inputAmount = inputAmount.substring(0, inputAmount.length - 1);
        }
      } else {
        inputAmount += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.from(
        alpha: 1,
        red: 0.129,
        green: 0.588,
        blue: 0.953,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Back & Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Send Money",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Beneficiary Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                    radius: 24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Clarissa Bates",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Bank - 0002 1887 2532",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount Display
            Text(
              inputAmount.isEmpty ? "\$0.00" : "\$${inputAmount}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Keyboard & Button
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        children: List.generate(12, (index) {
                          if (index < 9) {
                            return buildKey('${index + 1}');
                          } else if (index == 9) {
                            return const SizedBox(); // vide
                          } else if (index == 10) {
                            return buildKey('0');
                          } else {
                            return buildKey('del');
                          }
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed:
                            inputAmount.isEmpty
                                ? null
                                : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => const TransferSuccessPage(),
                                    ),
                                  );
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.from(
                            alpha: 1,
                            red: 0.129,
                            green: 0.588,
                            blue: 0.953,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("Continue"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKey(String value) {
    if (value == 'del') {
      return GestureDetector(
        onTap: () => onKeyboardTap('del'),
        child: const Center(child: Icon(Icons.backspace_outlined)),
      );
    } else {
      return GestureDetector(
        onTap: () => onKeyboardTap(value),
        child: Center(child: Text(value, style: const TextStyle(fontSize: 24))),
      );
    }
  }
}

// Page de succès
class TransferSuccessPage extends StatelessWidget {
  const TransferSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.from(
        alpha: 1,
        red: 0.129,
        green: 0.588,
        blue: 0.953,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Retour & titre
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(width: 16),
                  Text(
                    "Receipt",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Transfer Successful!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Your money has been transferred successfully!",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Transfer Amount"), Text("\$120.24")],
                    ),
                    const Divider(height: 20),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                      title: Text("Clarissa Bates"),
                      subtitle: Text("Bank - 0002 1887 2532"),
                    ),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date & time"),
                        Text("12 Feb 2022, 10:30 PM"),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("No. Ref"), Text("11788889028711")],
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("See Detail"),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Done"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.from(
                          alpha: 1,
                          red: 0.129,
                          green: 0.588,
                          blue: 0.953,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
