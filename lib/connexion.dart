import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'dart:convert';

import 'home.dart';
import 'inscription.dart';

class ConnexionScreen extends StatefulWidget {
  @override
  _ConnexionScreenState createState() => _ConnexionScreenState();
}

class _ConnexionScreenState extends State<ConnexionScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  InputDecoration champDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: const Color.fromRGBO(33, 150, 243, 1),
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(33, 150, 243, 1),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void login() async {
    final response = await ApiService.login(
      usernameController.text,
      passwordController.text,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      // Navigation vers le dashboard avec le token
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'token': token},
      );
    } else {
      String errorMsg = 'Erreur de connexion';
      try {
        final data = jsonDecode(response.body);
        errorMsg = data['error'] ?? data['detail'] ?? errorMsg;
      } catch (_) {}
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 36,
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
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Text(
              'Connexion',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(33, 150, 243, 1),
                fontFamily: 'Sans',
              ),
            ),
            SizedBox(height: 40),

            TextField(
              controller: usernameController,
              decoration: champDecoration('Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),

            TextField(
              controller: passwordController,
              decoration: champDecoration('Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 30),

            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(33, 150, 243, 1),
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Se connecter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => InscriptionScreen()),
                );
              },
              child: Text(
                ' S\'inscrire',
                style: TextStyle(
                  color: const Color.fromARGB(255, 19, 128, 230),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
