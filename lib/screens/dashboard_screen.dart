import 'package:flutter/material.dart';
import 'package:projetflutter/screens/transaction_screen.dart';
import 'package:projetflutter/screens/virement_screen.dart';
import '../demande_credit.dart';
import '../models/beneficiaire.dart';
import '../services/auth_service.dart';
import 'account_screen.dart';
import 'auth/login_screen.dart';
import 'beneficaire_screen.dart';
import 'exchange_rate_widget.dart';

class DashboardScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final List<Beneficiary> beneficiaries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.greenAccent,
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            buildListTile(
              context,
              title: 'Mon Compte Bancaire',
              onTap: () => navigateToScreen(context, CompteBancaireScreen()),
            ),
            buildListTile(
              context,
              title: 'Transaction',
              onTap: () => navigateToScreen(context, TransactionScreen()),
            ),
            buildListTile(
              context,
              title: 'Demande de crédit',
              onTap: () => navigateToScreen(context, DemandeCreditScreen()),
            ),
            buildListTile(
              context,
              title: 'Beneficiaire',
              onTap: () => navigateToScreen(context, BeneficiaireScreen()),
            ),
            buildListTile(
              context,
              title: 'Virement',
              onTap: () => navigateToScreen(
                  context, VirementScreen(beneficiaries: beneficiaries)),
            ),
            buildListTile(
              context,
              title: 'Login',
              onTap: () async {
                _auth.currentUser != null
                    ? showLoggedInDialog(context, _auth.currentUser!.email![0])
                    : navigateToScreen(
                        context, LoginScreen(email: '', password: ''));
              },
            ),
            buildListTile(
              context,
              title: 'Sign Out',
              onTap: () => _auth.signOut(),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bienvenue dans Notre Banque',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Nous sommes une institution financière dédiée à vous fournir des services bancaires de haute qualité '
              'et des solutions financières adaptées à vos besoins. Notre équipe dexperts est là pour vous accompagner '
              'à chaque étape de votre parcours financier, que ce soit pour vos comptes courants, vos épargnes, vos '
              'placements ou vos prêts. Chez Notre Banque, la satisfaction de nos clients est notre priorité absolue. '
              'Rejoignez-nous dès aujourd\'hui et découvrez une nouvelle façon de gérer vos finances.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            WidgetTauxDeChange(),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(BuildContext context,
      {required String title, required Function onTap}) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void showLoggedInDialog(BuildContext context, String emailInitial) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logged in as'),
          content: CircleAvatar(
            child: Text(emailInitial),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
