import 'package:flutter/material.dart';

import 'connexion.dart';
import 'gard.dart';
import 'inscription.dart';
import 'mots_de_passe.dart';
import 'profile.dart';
import 'tontine.dart';

void main() => runApp(EtontineApp());

class EtontineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'etontine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Sans'),
      home: GardScreen(),
      routes: {
        '/connexion': (context) => ConnexionScreen(),
        '/inscription': (context) => InscriptionScreen(),
        '/gard': (context) => GardScreen(),
        '/tontine': (context) => TontineScreen(),
        '/profils': (context) => ProfilScreen(),
        '/changer_mot_de_passe': (context) => ChangerMotDePasseScreen(),
      },
    );
  }
}
