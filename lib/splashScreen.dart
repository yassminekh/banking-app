import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projetflutter/screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen(
                  email: '',
                  password: '',
                )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Container(
          width: 300, // Largeur de la zone du cercle
          height: 300, // Hauteur de la zone du cercle
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Forme de cercle
            color: Colors.white, // Couleur de fond du cercle
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
              radius: 100, // Rayon du cercle
            ),
          ),
        ),
      ),
    );
  }
}
