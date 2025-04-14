import 'package:flutter/material.dart';

class TontineScreen extends StatefulWidget {
  @override
  _TontineScreenState createState() => _TontineScreenState();
}

class _TontineScreenState extends State<TontineScreen> {
  final TextEditingController _nomTontineController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _seuilRetraitController = TextEditingController();
  String _frequence = 'Jour';

  final List<String> _frequences = ['Jour', 'Semaine', 'Mois'];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Icône noire
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/inscription',
            ); // Retour à la page de connexion
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'My Tontine',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _nomTontineController,
                decoration: champDecoration('Nom de la tontine'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _montantController,
                keyboardType: TextInputType.number,
                decoration: champDecoration('Montant'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _frequence,
                items:
                    _frequences
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                decoration: champDecoration('Fréquence'),
                onChanged: (newValue) {
                  setState(() {
                    _frequence = newValue!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: _seuilRetraitController,
                keyboardType: TextInputType.number,
                decoration: champDecoration('Seuil de retrait'),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logique pour créer la tontine
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Créer la tontine',
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
