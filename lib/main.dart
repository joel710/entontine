import 'package:entontine/payement.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'connexion.dart';
import 'depot.dart'; // Import the missing file
import 'gard.dart';
import 'home.dart';
import 'inscription.dart';
import 'mots_de_passe.dart';
import 'notification.dart';
import 'profil.dart';
import 'retrait.dart';
import 'support.dart';
import 'tontine.dart';
import 'transactions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR'); // Initialisation pour le français
  runApp(EtontineApp());
}

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr', 'FR')],

      home: GardScreen(), // Première page au lancement
      routes: {
        '/connexion': (context) => ConnexionScreen(),
        '/inscription': (context) => InscriptionScreen(),
        '/gard': (context) => GardScreen(),
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final token = args?['token'] ?? '';
          return HomeScreen(token: token);
        },
        '/tontine': (context) => TontineScreen(),
        '/profil': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final token = args?['token'] ?? '';
          return ProfilScreen(token: token);
        },
        '/changer_mot_de_passe': (context) => ChangerMotDePasseScreen(),
        '/notification': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final token = args?['token'] ?? '';
          return NotificationsScreen(token: token);
        },
        '/depot': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final token = args?['token'] ?? '';
          return SendMoneyPageScreen(token: token);
        },
        '/payement': (context) => PaymentMethodPageScreen(),
        '/transactions': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final token = args?['token'] ?? '';
          return TransactionScreen(token: token);
        },
        '/support': (context) => SupportPageScreen(),
        '/retrait': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final token = args?['token'] ?? '';
          return WithdrawPageScreen(token: token);
        },
      },
    );
  }
}
