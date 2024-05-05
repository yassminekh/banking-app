import 'package:flutter/material.dart';
import 'package:projetflutter/models/beneficiaire.dart';

import 'beneficaire_screen.dart';

class VirementScreen extends StatefulWidget {
  final List<Beneficiary> beneficiaries; // Liste des bénéficiaires

  VirementScreen({required this.beneficiaries});

  @override
  _VirementScreenState createState() => _VirementScreenState();
}

class _VirementScreenState extends State<VirementScreen> {
  final TextEditingController _amountController = TextEditingController();
  Beneficiary? _selectedBeneficiary;

  Widget _buildBeneficiaryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final selectedBeneficiary = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BeneficiaireScreen()),
        );

        if (selectedBeneficiary != null && selectedBeneficiary is Beneficiary) {
          setState(() {
            widget.beneficiaries.add(selectedBeneficiary);
            _selectedBeneficiary = selectedBeneficiary;
          });
        }
      },
      child: Text(_selectedBeneficiary != null
          ? _selectedBeneficiary!.name
          : 'Sélectionner un bénéficiaire'),
    );
  }

  void _addBeneficiary(Beneficiary beneficiary) {
    setState(() {
      widget.beneficiaries.add(beneficiary);
    });
  }

  Widget _buildBeneficiaryDropdown() {
    return DropdownButtonFormField<Beneficiary>(
      value: _selectedBeneficiary,
      onChanged: (value) {
        setState(() {
          _selectedBeneficiary = value;
        });
      },
      items: widget.beneficiaries.map((beneficiary) {
        return DropdownMenuItem(
          value: beneficiary,
          child: Text(beneficiary.name),
        );
      }).toList(),
      // Utilisez la liste des bénéficiaires passée en paramètre ou affichez un texte indicatif si la liste est vide
      hint: widget.beneficiaries.isNotEmpty
          ? null
          : Text('Aucun bénéficiaire disponible'),
      decoration: InputDecoration(
        labelText: 'Bénéficiaire',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Effectuer un virement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBeneficiaryButton(
                context), // Ajoutez cette ligne à votre Column
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Montant',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Vérifier si un bénéficiaire est sélectionné et si le montant est valide
                if (_selectedBeneficiary != null &&
                    _amountController.text.isNotEmpty) {
                  // Effectuer le virement en utilisant le bénéficiaire sélectionné
                  makeTransfer(_selectedBeneficiary!,
                      double.parse(_amountController.text));
                } else {
                  // Afficher un message d'erreur si le bénéficiaire n'est pas sélectionné ou si le montant est invalide
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Veuillez sélectionner un bénéficiaire et entrer un montant valide'),
                    ),
                  );
                }
              },
              child: Text('Effectuer le virement'),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour afficher la liste déroulante des bénéficiaires

  // Méthode pour effectuer un virement
  void makeTransfer(Beneficiary beneficiary, double amount) {
    // Simulation du processus de virement
    if (beneficiary != null && amount > 0) {
      // Virement réussi
      onSuccess();
    } else {
      // Erreur lors du virement
      onError('Montant invalide ou bénéficiaire non sélectionné');
    }
  }

  // Méthode pour gérer le succès du virement
  void onSuccess() {
    // Afficher un message de succès ou effectuer d'autres actions nécessaires
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Virement réussi'),
      ),
    );
  }

  // Méthode pour gérer les erreurs lors du virement
  void onError(String error) {
    // Afficher un message d'erreur ou effectuer d'autres actions nécessaires
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur lors du virement: $error'),
      ),
    );
  }
}
