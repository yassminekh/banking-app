import 'package:flutter/material.dart';
import '../models/beneficiaire.dart';

class BeneficiaryDetailsScreen extends StatelessWidget {
  final Beneficiary beneficiary;

  const BeneficiaryDetailsScreen({super.key, required this.beneficiary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beneficiary Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${beneficiary.name}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Account Number: ${beneficiary.accountNumber}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
