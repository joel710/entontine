import 'package:flutter/material.dart';

class RetraitPageScreen extends StatefulWidget {
  final double soldeActuel;
  final double seuilMinimum;

  const RetraitPageScreen({
    Key? key,
    required this.soldeActuel,
    required this.seuilMinimum,
  }) : super(key: key);

  @override
  State<RetraitPageScreen> createState() => _RetraitPageState();
}

class _RetraitPageState extends State<RetraitPageScreen> {
  final TextEditingController _montantController = TextEditingController();

  void effectuerRetrait() {
    double montant = double.tryParse(_montantController.text) ?? 0;

    if (widget.soldeActuel < widget.seuilMinimum) {
      _afficherMessage(
        'Votre solde est insuffisant. Le montant minimum requis est de ${widget.seuilMinimum} FCFA.',
      );
    } else if (montant <= 0) {
      _afficherMessage('Veuillez entrer un montant valide.');
    } else if (montant > widget.soldeActuel) {
      _afficherMessage('Montant supérieur à votre solde.');
    } else {
      // Logique du retrait ici
      _afficherMessage('Retrait de $montant FCFA effectué avec succès !');
    }
  }

  void _afficherMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildEtontineTitle() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Sans',
        ),
        children: [
          TextSpan(
            text: 'e',
            style: TextStyle(
              color: Color.fromRGBO(33, 150, 243, 1), // Bleu personnalisé
            ),
          ),
          TextSpan(text: 'tontine', style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildEtontineTitle(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Solde disponible : ${widget.soldeActuel} FCFA',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _montantController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Montant à retirer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: effectuerRetrait,
              child: const Text('Retirer'),
            ),
          ],
        ),
      ),
    );
  }
}
