import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class SendMoneyPageScreen extends StatefulWidget {
  final String token;
  const SendMoneyPageScreen({Key? key, required this.token}) : super(key: key);

  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPageScreen> {
  String inputAmount = '';
  bool isLoading = false;

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

  void handleDeposit() async {
    setState(() {
      isLoading = true;
    });
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final service = args?['service'] ?? '';
    final phone = args?['phone'] ?? '';
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('Erreur'),
              content: Text('Utilisateur non connecté.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
      return;
    }
    final montant = double.tryParse(inputAmount) ?? 0;
    // 1. Récupérer la tontine de l'utilisateur (ici, la première trouvée)
    final tontines = await Supabase.instance.client
        .from('tontines')
        .select()
        .eq('createur_id', user.id)
        .limit(1);
    if (tontines.isEmpty) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('Erreur'),
              content: Text('Aucune tontine trouvée.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
      return;
    }
    final tontine = tontines[0];
    final montantCotisation =
        double.tryParse(tontine['montant'].toString()) ?? 0;
    final tontineId = tontine['id'];
    // 2. Vérifier que le montant du dépôt est suffisant
    if (montant < montantCotisation) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('Montant insuffisant'),
              content: Text(
                'Le montant du dépôt doit être supérieur ou égal à la cotisation définie pour la tontine.\n\nMontant minimum requis : ${montantCotisation.toStringAsFixed(0)} FCFA',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
      return;
    }
    // 3. Continuer le process normal (création transaction, appel Paygate...)
    final identifier =
        DateTime.now().millisecondsSinceEpoch.toString() +
        user.id.substring(0, 6);
    final insertResult =
        await Supabase.instance.client
            .from('transactions')
            .insert({
              'user_id': user.id,
              'type': 'depot',
              'montant': montant,
              'service': service,
              'status': 'en_attente',
              'date': DateTime.now().toIso8601String(),
              'details': {'phone': phone},
              'identifier': identifier,
              'tontine_id': tontineId,
            })
            .select()
            .single();
    final transactionId = insertResult['id'];
    final paygateResponse = await http.post(
      Uri.parse('https://paygateglobal.com/api/v1/pay'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'auth_token': '15c15ac9-b802-48d8-9d26-d7e2338a18d2',
        'phone_number': phone,
        'amount': montant,
        'description': 'Dépôt eTontine',
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
    await Supabase.instance.client
        .from('transactions')
        .update({
          'status': status,
          'details': {'phone': phone, 'tx_reference': txReference},
        })
        .eq('id', transactionId);
    setState(() {
      isLoading = false;
    });
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(status == 'reussi' ? 'Succès' : 'Erreur'),
            content: Text(
              status == 'reussi'
                  ? 'Dépôt effectué avec succès !'
                  : 'Le paiement a échoué ou a été annulé.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchUserProfile(),
      builder: (context, snapshot) {
        final userName = snapshot.data?['fullName'] ?? '';
        final userPhone = snapshot.data?['phone'] ?? '';
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
                          Navigator.pushNamed(context, '/payement');
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
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
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
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
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            userPhone,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Amount Display
                Text(
                  inputAmount.isEmpty ? "0 FCFA" : "$inputAmount FCFA",
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
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
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
                          child:
                              isLoading
                                  ? CircularProgressIndicator()
                                  : ElevatedButton(
                                    onPressed:
                                        inputAmount.isEmpty
                                            ? null
                                            : handleDeposit,
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
                                    child: const Text("Continuer"),
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
      },
    );
  }

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;
    final profile =
        await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();
    return {
      'fullName':
          ((profile['first_name'] ?? '') + ' ' + (profile['last_name'] ?? ''))
              .trim(),
      'phone': profile['phone_number'] ?? '',
    };
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
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/depot');
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
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
                      onPressed: () => Navigator.pushNamed(context, '/home'),
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

void deposit(String token, double montant) async {
  final response = await ApiService.deposit(token, montant);
  if (response.statusCode == 201) {
    print('Dépôt effectué avec succès');
  } else {
    print('Erreur lors du dépôt : ' + response.body);
  }
}
