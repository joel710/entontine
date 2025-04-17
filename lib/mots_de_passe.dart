import 'package:flutter/material.dart';

class ChangerMotDePasseScreen extends StatefulWidget {
  @override
  _ChangerMotDePasseScreenState createState() =>
      _ChangerMotDePasseScreenState();
}

class _ChangerMotDePasseScreenState extends State<ChangerMotDePasseScreen> {
  final TextEditingController _ancienMotDePasse = TextEditingController();
  final TextEditingController _nouveauMotDePasse = TextEditingController();
  final TextEditingController _confirmationMotDePasse = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "Changer le mot de passe",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _motDePasseField(_ancienMotDePasse, "Ancien mot de passe"),
              SizedBox(height: 16),
              _motDePasseField(_nouveauMotDePasse, "Nouveau mot de passe"),
              SizedBox(height: 16),
              _motDePasseField(
                _confirmationMotDePasse,
                "Confirmer le nouveau mot de passe",
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Logique de changement de mot de passe ici
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Mot de passe modifié avec succès !"),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Valider",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _motDePasseField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Veuillez remplir ce champ";
        }
        if (label == "Confirmer le nouveau mot de passe" &&
            value != _nouveauMotDePasse.text) {
          return "Les mots de passe ne correspondent pas";
        }
        return null;
      },
      decoration: InputDecoration(
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
      ),
    );
  }
}
