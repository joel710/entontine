import 'package:flutter/material.dart';

class SupportPageScreen extends StatefulWidget {
  const SupportPageScreen({super.key});

  @override
  State<SupportPageScreen> createState() => _SupportPageScreen();
}

class _SupportPageScreen extends State<SupportPageScreen> {
  // Fonction pour afficher le logo "etontine"
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
        title: _buildEtontineTitle(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              'Support & Aide',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Vous avez un problème ou une question ? Contactez notre équipe ou consultez les questions fréquentes ci-dessous.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Action à définir : envoyer un message, ouvrir un formulaire, etc.
              },
              icon: const Icon(Icons.support_agent),
              label: const Text("Contacter le support"),
            ),
            const SizedBox(height: 30),
            const Text(
              'Questions fréquentes :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.help_outline),
              title: Text("Comment faire un dépôt ?"),
              subtitle: Text(
                "Allez sur l'accueil et appuyez sur le bouton 'Dépôt'.",
              ),
            ),
            const ListTile(
              leading: Icon(Icons.help_outline),
              title: Text("Pourquoi je ne peux pas retirer ?"),
              subtitle: Text(
                "Votre solde doit dépasser un seuil avant le retrait.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
