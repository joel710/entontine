import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'connexion.dart';
import 'gard.dart';
import 'inscription.dart';
import 'home.dart';
import 'mots_de_passe.dart';
import 'profil.dart';
import 'tontine.dart';

void main() => runApp(EtontineApp());

class EtontineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'etontine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Sans',
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: GardScreen(), // Première page au lancement
      routes: {
        '/connexion': (context) => ConnexionScreen(),
        '/inscription': (context) => InscriptionScreen(),
        '/gard': (context) => GardScreen(),
        '/home': (context) => HomeScreen(), // Ajout de la route home
        '/tontine': (context) => TontineScreen(),
        '/profil': (context) => ProfilScreen(),
        '/changer_mot_de_passe': (context) => ChangerMotDePasseScreen(),
      },
    );
  }
}
