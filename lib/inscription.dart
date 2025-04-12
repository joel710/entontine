import 'package:flutter/material.dart';

class InscriptionScreen extends StatefulWidget {
  @override
  _InscriptionScreenState createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  final TextEditingController _nomControler = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _dateNaissanceController =
      TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              fontFamily: 'Sans',
            ),
            children: [
              TextSpan(text: 'e', style: TextStyle(color: Colors.blue)),
              TextSpan(text: 'tontine', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
