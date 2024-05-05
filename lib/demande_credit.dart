import 'package:flutter/material.dart';

import 'models/demande_credit_model.dart';

class DemandeCreditScreen extends StatefulWidget {
  const DemandeCreditScreen({super.key});

  @override
  _DemandeCreditScreenState createState() => _DemandeCreditScreenState();
}

class _DemandeCreditScreenState extends State<DemandeCreditScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _montantController = TextEditingController();
  TextEditingController _raisonController = TextEditingController();
  List<DemandeCredit> listeDemandes = [];
  void envoyerDemandeCredit(String montant, String raison) {
    // Ajoutez la demande de crédit à la liste
    listeDemandes.add(DemandeCredit(montant, raison));

    // Affichez un message de confirmation à l'utilisateur
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Demande de crédit envoyée'),
          content: Text('Votre demande de crédit a été envoyée avec succès.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demande de crédit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _montantController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Montant souhaité',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un montant';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _raisonController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Raison de la demande',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une raison';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    envoyerDemandeCredit(
                        _montantController.text, _raisonController.text);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Demande de crédit envoyée'),
                          content: Text(
                              'Votre demande de crédit a été envoyée avec succès.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Envoyer la demande de crédit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
