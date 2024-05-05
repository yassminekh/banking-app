import 'package:flutter/material.dart';

class WidgetTauxDeChange extends StatefulWidget {
  @override
  _WidgetTauxDeChangeState createState() => _WidgetTauxDeChangeState();
}

class _WidgetTauxDeChangeState extends State<WidgetTauxDeChange> {
  late String deviseDepart;
  late String deviseArrivee;
  double montant = 0.0;
  double montantConverti = 0.0;

  final devises = ['USD', 'EUR', 'GBP', 'JPY', 'CAD'];

  @override
  void initState() {
    super.initState();
    deviseDepart = devises.first;
    deviseArrivee = devises.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Contrainte de largeur définie
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Taux de change',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: deviseDepart,
                onChanged: (String? newValue) {
                  setState(() {
                    deviseDepart = newValue!;
                    _convertirMontant();
                  });
                },
                items: devises.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(
                width: 150.0, // Contrainte de largeur définie pour le TextField
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      montant = double.tryParse(value) ?? 0.0;
                      _convertirMontant();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Montant',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: deviseArrivee,
                onChanged: (String? newValue) {
                  setState(() {
                    deviseArrivee = newValue!;
                    _convertirMontant();
                  });
                },
                items: devises.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Text(
                '$montantConverti',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _convertirMontant() {
    Map<String, double> tauxDeChange = {
      'USD': 1.0, // Par exemple, 1 USD équivaut à 1 USD (taux de base)
      'EUR': 0.85, // Taux de conversion fictif de USD à EUR
      'GBP': 0.72, // Taux de conversion fictif de USD à GBP
      'JPY': 110.0, // Taux de conversion fictif de USD à JPY
      'CAD': 1.25, // Taux de conversion fictif de USD à CAD
    };

    double taux = tauxDeChange[deviseArrivee]! / tauxDeChange[deviseDepart]!;
    montantConverti = montant * taux;
  }
}
