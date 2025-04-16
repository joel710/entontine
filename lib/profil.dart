import 'package:flutter/material.dart';

class ProfilScreen extends StatefulWidget {
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _isEditing = false;

  final TextEditingController _nomController = TextEditingController(
    text: "e etontine",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "etontine@example.com",
  );
  final TextEditingController _telController = TextEditingController(
    text: "+228 90 00 00 00",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Mon Profil", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Photo de profil
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
            SizedBox(height: 16),

            // Nom
            TextField(
              controller: _nomController,
              enabled: _isEditing,
              decoration: _inputDecoration("Nom complet"),
            ),
            SizedBox(height: 12),

            // Email
            TextField(
              controller: _emailController,
              enabled: _isEditing,
              decoration: _inputDecoration("Adresse email"),
            ),
            SizedBox(height: 12),

            // Téléphone
            TextField(
              controller: _telController,
              enabled: _isEditing,
              decoration: _inputDecoration("Téléphone"),
            ),
            SizedBox(height: 30),

            // Historique d’actions
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Dernières actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 12),
            _actionTile(
              "Tontine créée : Jeunes Entrepreneurs",
              "12 Avril 2025",
            ),
            _actionTile("Dépôt effectué : 5000 FCFA", "13 Avril 2025"),
            _actionTile("Seuil modifié : 10000 FCFA", "14 Avril 2025"),
            SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/changer_mot_de_passe');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.lock_reset),
              label: Text(
                "Changer le mot de passe",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),

            // Déconnexion
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/connexion');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.logout),
              label: Text(
                "Déconnexion",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
    );
  }

  Widget _actionTile(String title, String date) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.check_circle, color: Colors.green),
      title: Text(title),
      subtitle: Text(date),
    );
  }
}
