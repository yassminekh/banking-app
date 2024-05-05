import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeneficiaryService {
  static const _key = 'beneficiaries';

  Future<List<String>> getBeneficiaries() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> addBeneficiary(String beneficiary) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> beneficiaries = prefs.getStringList(_key) ?? [];
    beneficiaries.add(beneficiary);
    await prefs.setStringList(_key, beneficiaries);
  }
}

class BeneficiaryScreen extends StatefulWidget {
  @override
  _BeneficiaryScreenState createState() => _BeneficiaryScreenState();
}

class _BeneficiaryScreenState extends State<BeneficiaryScreen> {
  final BeneficiaryService _beneficiaryService = BeneficiaryService();
  final TextEditingController _controller = TextEditingController();
  List<String> _beneficiaries = [];

  @override
  void initState() {
    super.initState();
    _loadBeneficiaries();
  }

  Future<void> _loadBeneficiaries() async {
    final List<String> beneficiaries =
        await _beneficiaryService.getBeneficiaries();
    setState(() {
      _beneficiaries = beneficiaries;
    });
  }

  Future<void> _addBeneficiary() async {
    final String newBeneficiary = _controller.text;
    if (newBeneficiary.isNotEmpty) {
      await _beneficiaryService.addBeneficiary(newBeneficiary);
      _controller.clear();
      await _loadBeneficiaries(); // Reload the list of beneficiaries
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beneficiary Screen'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Enter beneficiary name',
            ),
          ),
          ElevatedButton(
            onPressed: _addBeneficiary,
            child: Text('Add Beneficiary'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _beneficiaries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_beneficiaries[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BeneficiaryScreen(),
  ));
}
