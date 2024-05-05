import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projetflutter/screens/virement_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/beneficiaire.dart';
import '../services/beneficaire_service.dart';

class BeneficiaireScreen extends StatefulWidget {
  const BeneficiaireScreen({Key? key});

  @override
  _BeneficiaryScreenState createState() => _BeneficiaryScreenState();
}

class _BeneficiaryScreenState extends State<BeneficiaireScreen> {
  late BeneficiaryService _beneficiaryService; // Instance de BeneficiaryService

  List<Beneficiary> beneficiaries = []; // Liste des bénéficiaires

  @override
  void initState() {
    super.initState();
    _beneficiaryService = BeneficiaryService();
    // Initialisation de BeneficiaryService
    _refreshBeneficiaries();
  }

  void _navigateToVirementScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VirementScreen(beneficiaries: beneficiaries)),
    );

    // Vérifiez si un bénéficiaire a été ajouté
    if (result != null && result is Beneficiary) {
      // Ajoutez le bénéficiaire à la liste
      setState(() {
        beneficiaries.add(result);
      });
    }
  }

  // Méthode pour ajouter un bénéficiaire
  Future<Beneficiary?> _addBeneficiary(Beneficiary beneficiary) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? beneficiaryList = prefs.getStringList('beneficiaries');
    if (beneficiaryList == null) {
      beneficiaryList =
          [];
    }
    beneficiaryList.add(json.encode(beneficiary
        .toJson())); // Convertir l'objet Beneficiary en JSON avant de l'ajouter
    await prefs.setStringList('beneficiaries', beneficiaryList);
    _refreshBeneficiaries(); // Rafraîchir la liste après l'ajout
    return beneficiary; // Retourner le bénéficiaire ajouté
  }

// Méthode pour rafraîchir la liste des bénéficiaires
  Future<void> _refreshBeneficiaries() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? beneficiaryList = prefs.getStringList('beneficiaries');
    if (beneficiaryList != null) {
      final updatedBeneficiaries = beneficiaryList
          .map((beneficiaryJson) =>
              Beneficiary.fromJson(json.decode(beneficiaryJson)))
          .toList();
      setState(() {
        beneficiaries = updatedBeneficiaries;
      });
    }
  }

  // Méthode pour enregistrer la liste des bénéficiaires dans SharedPreferences
  Future<void> _saveBeneficiaries(List<Beneficiary> beneficiaries) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final beneficiaryList =
        beneficiaries.map((beneficiary) => beneficiary.toJson()).toList();
    await prefs.setStringList('beneficiaries', beneficiaryList.cast<String>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Créer un nouvel objet Beneficiary avec des valeurs vides
          Beneficiary newBeneficiary = Beneficiary(name: '', accountNumber: '');

          // Afficher une boîte de dialogue pour saisir les informations du bénéficiaire
          final result = await showDialog<Beneficiary>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Nouveau bénéficiaire'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Nom'),
                      onChanged: (value) {
                        // Mettre à jour le nom du bénéficiaire
                        newBeneficiary = Beneficiary(
                          name: value,
                          accountNumber: newBeneficiary.accountNumber,
                        );
                      },
                    ),
                    TextField(
                      decoration:
                          InputDecoration(labelText: 'Numéro de compte'),
                      onChanged: (value) {
                        // Mettre à jour le numéro de compte du bénéficiaire
                        newBeneficiary = Beneficiary(
                          name: newBeneficiary.name,
                          accountNumber: value,
                        );
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Annuler l'ajout du bénéficiaire
                      Navigator.pop(context);
                    },
                    child: Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Ajouter le bénéficiaire et fermer la boîte de dialogue
                      Navigator.pop(context, newBeneficiary);
                    },
                    child: Text('Ajouter'),
                  ),
                ],
              );
            },
          );

          // Vérifier si un nouveau bénéficiaire a été ajouté
          if (result != null) {
            // Ajouter le bénéficiaire à la liste
            _addBeneficiary(result);
          }
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Liste des bénéficiaires'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retourner à l'écran précédent (Dashboard)
          },
        ),
      ),
      body: beneficiaries.isEmpty
          ? Center(
              child: Text('Aucun bénéficiaire trouvé.'),
            )
          : ListView.builder(
              itemCount: beneficiaries.length,
              itemBuilder: (context, index) {
                final beneficiary = beneficiaries[index];
                return ListTile(
                  title: Text(beneficiary.name),
                  subtitle: Text(beneficiary.accountNumber),
                );
              },
            ),
    );
  }
}
