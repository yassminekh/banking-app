import 'package:flutter/material.dart';
import 'package:projetflutter/screens/auth/register_screen.dart';
import 'package:projetflutter/services/auth_service.dart';

import '../dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  LoginScreen({Key? key, required String email, required String password})
      : _emailController = TextEditingController(text: email),
        _passwordController = TextEditingController(text: password),
        super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordObscured = true;
  String? _emailErrorText;
  String? _passwordErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
            Text(
              'Bienvenue !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: widget._emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                errorText: _emailErrorText,
              ),
              onChanged: (_) {
                setState(() {
                  _emailErrorText = null;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: widget._passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                errorText: _passwordErrorText,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                  icon: Icon(_isPasswordObscured
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
              obscureText: _isPasswordObscured,
              onChanged: (_) {
                setState(() {
                  _passwordErrorText = null;
                });
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (widget._emailController.text.isEmpty ||
                    widget._passwordController.text.isEmpty) {
                  setState(() {
                    _emailErrorText = widget._emailController.text.isEmpty
                        ? 'Veuillez entrer votre email'
                        : null;
                    _passwordErrorText = widget._passwordController.text.isEmpty
                        ? 'Veuillez entrer votre mot de passe'
                        : null;
                  });
                  return;
                }
                String email = widget._emailController.text.trim();
                String password = widget._passwordController.text;
                dynamic result = await widget._auth
                    .signInWithEmailAndPassword(email, password);
                if (result == null) {
                  setState(() {
                    _emailErrorText =
                        'L\'email n\'existe pas, veuillez vous inscrire.';
                  });
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                }
              },
              child: Text('Connexion'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text(
                'Vous n\'avez pas de compte ? Inscrivez-vous',
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
