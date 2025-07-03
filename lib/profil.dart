import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilScreen extends StatefulWidget {
  final String token;
  const ProfilScreen({Key? key, required this.token}) : super(key: key);

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _isEditing = false;
  late Future<Map<String, dynamic>?> profilFuture;

  @override
  void initState() {
    super.initState();
    profilFuture = fetchProfil();
  }

  Future<Map<String, dynamic>?> fetchProfil() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;
    final response =
        await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      body: FutureBuilder<Map<String, dynamic>?>(
        future: profilFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Aucune donnée trouvée.'));
          }
          final data = snapshot.data!;
          final nom = data['last_name'] ?? '';
          final prenom = data['first_name'] ?? '';
          final email = data['username'] ?? '';
          final tel = data['phone_number'] ?? '';
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: '$prenom $nom'),
                  enabled: false,
                  decoration: _inputDecoration("Nom complet"),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: TextEditingController(text: email),
                  enabled: false,
                  decoration: _inputDecoration("Adresse email"),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: TextEditingController(text: tel),
                  enabled: false,
                  decoration: _inputDecoration("Téléphone"),
                ),
                SizedBox(height: 30),
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
                // Afficher ici les dernières actions si disponibles dans l'API
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
          );
        },
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
}
