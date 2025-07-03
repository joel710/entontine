import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WithdrawPageScreen extends StatefulWidget {
  const WithdrawPageScreen({Key? key, required token}) : super(key: key);

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPageScreen> {
  String inputAmount = '';
  String selectedMethod = 'Moov';
  final TextEditingController phoneController = TextEditingController();

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

  void handleWithdraw() async {
    setState(() { }); // Pour afficher le loader si besoin
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Utilisateur non connecté.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
        ),
      );
      return;
    }
    final montant = double.tryParse(inputAmount) ?? 0;
    final phone = phoneController.text.trim();
    final service = selectedMethod.toLowerCase();
    final identifier = DateTime.now().millisecondsSinceEpoch.toString() + user.id.substring(0, 6);
    // 1. Créer la transaction dans Supabase
    final insertResult = await Supabase.instance.client.from('transactions').insert({
      'user_id': user.id,
      'type': 'retrait',
      'montant': montant,
      'service': service,
      'status': 'en_attente',
      'date': DateTime.now().toIso8601String(),
      'details': {'phone': phone},
      'identifier': identifier,
    }).select().single();
    final transactionId = insertResult['id'];
    // 2. Appeler l'API Paygate
    final paygateResponse = await http.post(
      Uri.parse('https://paygateglobal.com/api/v1/pay'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'auth_token': '15c15ac9-b802-48d8-9d26-d7e2338a18d2',
        'phone_number': phone,
        'amount': montant,
        'description': 'Retrait eTontine',
        'identifier': identifier,
        'network': service == 'moov' ? 'FLOOZ' : 'TMONEY',
      }),
    );
    String status = 'en_attente';
    String txReference = '';
    if (paygateResponse.statusCode == 200) {
      final data = jsonDecode(paygateResponse.body);
      txReference = data['tx_reference'] ?? '';
      if (data['status'] == 0) {
        status = 'reussi';
      } else {
        status = 'echoue';
      }
    } else {
      status = 'echoue';
    }
    // 3. Mettre à jour la transaction dans Supabase
    await Supabase.instance.client.from('transactions').update({
      'status': status,
      'details': {'phone': phone, 'tx_reference': txReference},
    }).eq('id', transactionId);
    // 4. Afficher le résultat
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(status == 'reussi' ? 'Succès' : 'Erreur'),
        content: Text(status == 'reussi'
            ? 'Retrait effectué avec succès !'
            : 'Le paiement a échoué ou a été annulé.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      ),
    );
    if (status == 'reussi') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WithdrawalSuccessPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Retrait",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Méthode de retrait
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text(
                    "Méthode: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedMethod = value!;
                      });
                    },
                    items:
                        ['Moov', 'Yas']
                            .map(
                              (method) => DropdownMenuItem(
                                value: method,
                                child: Text(method),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),

            // Champ numéro : affiché seulement si une méthode est sélectionnée
            if (selectedMethod.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Entrez le numéro',
                    border: InputBorder.none,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Affichage du montant
            Text(
              inputAmount.isEmpty ? "\$0.00" : "\$$inputAmount",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Clavier personnalisé
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
                            return const SizedBox(); // Espace vide
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
                            inputAmount.isEmpty || phoneController.text.isEmpty
                                ? null
                                : handleWithdraw,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            33,
                            150,
                            243,
                            1,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("Confirmer"),
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
    return GestureDetector(
      onTap: () => onKeyboardTap(value),
      child: Center(
        child:
            value == 'del'
                ? const Icon(Icons.backspace_outlined)
                : Text(value, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

class WithdrawalSuccessPage extends StatelessWidget {
  const WithdrawalSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      body: SafeArea(
        child: Column(
          children: [
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
                    "Retrait Réussi",
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
                      "Retrait effectué avec succès !",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Merci d'avoir utilisé notre service."),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/home'),
                      child: const Text("Terminer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          33,
                          150,
                          243,
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
