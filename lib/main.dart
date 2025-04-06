import 'package:flutter/material.dart';

import 'connexion.dart';
import 'gard.dart';
import 'inscription.dart';

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
      },
    );
  }
}
