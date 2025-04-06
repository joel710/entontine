import 'package:flutter/material.dart';

import 'connexion.dart';

class GardScreen extends StatefulWidget {
  @override
  _GardScreenState createState() => _GardScreenState();
}

class _GardScreenState extends State<GardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ConnexionScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'etontine',
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sans', // Tu peux personnaliser ici la police
              ),
              children: [
                TextSpan(text: 'e', style: TextStyle(color: Colors.blue)),
                TextSpan(
                  text: 'tontine',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
