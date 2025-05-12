import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'dart:convert';

class InscriptionScreen extends StatefulWidget {
  @override
  _InscriptionScreenState createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _dateNaissanceController =
      TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateNaissanceController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  InputDecoration champDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: const Color.fromARGB(255, 49, 124, 223),
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 49, 124, 223),
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
      ),
    );
  }

  Widget champTexte({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType type = TextInputType.text,
    Widget? prefix,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: type,
      decoration: champDecoration(label).copyWith(prefix: prefix),
    );
  }

  void register() async {
    final response = await ApiService.register(
      _nomController.text,
      _emailController.text,
      _passwordController.text,
    );
    if (response.statusCode == 201) {
      // Succès, propose de se connecter
      print('Inscription réussie');
    } else {
      print('Erreur d\'inscription : ' + response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA), // fond très clair
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // Bouton retour noir
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/connexion');
          },
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Sans',
            ),
            children: [
              TextSpan(text: 'e', style: TextStyle(color: Colors.blue)),
              TextSpan(text: 'tontine', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              SizedBox(height: 30),
              champTexte(label: 'Nom', controller: _nomController),
              SizedBox(height: 16),
              champTexte(label: 'Prénom', controller: _prenomController),
              SizedBox(height: 16),
              champTexte(
                label: 'Email',
                controller: _emailController,
                type: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              champTexte(
                label: 'Mot de passe',
                controller: _passwordController,
                isPassword: true,
              ),
              SizedBox(height: 16),
              champTexte(
                label: 'Confirmer mot de passe',
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              SizedBox(height: 16),
              champTexte(
                label: 'Téléphone',
                controller: _telephoneController,
                type: TextInputType.phone,
                prefix: Text('+228 ', style: TextStyle(color: Colors.black)),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: champTexte(
                    label: 'Date de naissance',
                    controller: _dateNaissanceController,
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Les mots de passe ne correspondent pas',
                          ),
                        ),
                      );
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      // Logique d'inscription
                      register();
                      Navigator.pushReplacementNamed(context, '/tontine');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'S\'inscrire',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
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
}
