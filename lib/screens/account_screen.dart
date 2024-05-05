import 'package:flutter/material.dart';

import '../models/compte_bancaire.dart';
import '../services/compte_bancaire_service.dart';

class CompteBancaireScreen extends StatefulWidget {
  @override
  _CompteBancaireScreenState createState() => _CompteBancaireScreenState();
}

class _CompteBancaireScreenState extends State<CompteBancaireScreen> {
  final CompteBancaireService _compteBancaireService = CompteBancaireService();
  late CompteBancaire _compteBancaire = CompteBancaire(solde: 0.0);
  TextEditingController _montantController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chargerCompteBancaire();
  }

  Future<void> _chargerCompteBancaire() async {
    try {
      final compte = await _compteBancaireService.obtenirCompteBancaire();
      setState(() {
        _compteBancaire = compte;
      });
    } catch (e) {
      print('Échec du chargement du solde du compte: $e');
    }
  }

  Future<void> _effectuerDepot() async {
    try {
      double montant = double.tryParse(_montantController.text) ?? 0.0;
      await _compteBancaireService.deposerArgent(montant: montant);
      // Actualiser le solde après dépôt
      _chargerCompteBancaire();
    } catch (e) {
      print('Échec du dépôt: $e');
    }
  }

  Future<void> _effectuerRetrait() async {
    try {
      double montant = double.tryParse(_montantController.text) ?? 0.0;
      await _compteBancaireService.retirerArgent(montant: montant);
      // Actualiser le solde après retrait
      _chargerCompteBancaire();
    } catch (e) {
      print('Échec du retrait: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Compte Bancaire'),
      ),
      body: Center(
        child: _compteBancaire == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Solde actuel:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    '\$${_compteBancaire.solde}',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _montantController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Montant à déposer/retirer',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _effectuerDepot,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12), // Espacement interne du bouton
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8)), // Bord arrondi du bouton
                        ),
                        child: Text(
                          'Déposer',
                          style: TextStyle(fontSize: 16), // Taille du texte
                        ),
                      ),
                      SizedBox(width: 10.0),
                      ElevatedButton(
                        onPressed: _effectuerRetrait,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Couleur de fond rouge
                          padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12), // Espacement interne du bouton
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8)), // Bord arrondi du bouton
                        ),
                        child: Text(
                          'Retirer',
                          style: TextStyle(fontSize: 16), // Taille du texte
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _chargerCompteBancaire,
                    child: Text('Actualiser'),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _montantController.dispose();
    super.dispose();
  }
}
