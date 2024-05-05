import 'package:flutter/material.dart';
import 'package:projetflutter/models/transaction.dart';
import 'package:projetflutter/services/transaction_service.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Transaction> _transactions = [];
  final TransactionService _transactionService = TransactionService();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  int _transactionCounter = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions(); // Charger les transactions initiales depuis la base de données
  }

  // Fonction pour charger les transactions depuis la base de données
  void _loadTransactions() async {
    List<Transaction> transactions = await _transactionService.getTransactions();
    setState(() {
      _transactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          // Afficher chaque transaction dans la liste
          Transaction transaction = _transactions[index];
          return ListTile(
            title: Text(transaction.title),
            subtitle: Text(transaction.amount.toString()),
            onTap: () {
              // Afficher les détails de la transaction lorsque l'utilisateur clique dessus
              _showTransactionDetails(transaction);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Afficher le formulaire d'ajout de transaction lorsque l'utilisateur appuie sur le bouton flottant
          _showAddTransactionForm();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Fonction pour afficher les détails de la transaction
  void _showTransactionDetails(Transaction transaction) {
    // Afficher les détails de la transaction dans un dialogue ou une nouvelle page
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transaction Details'),
          content: Text(
              'Title: ${transaction.title}\nAmount: ${transaction.amount}'),
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

  // Fonction pour afficher le formulaire d'ajout de transaction
  void _showAddTransactionForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addTransaction(); // Appeler la fonction pour ajouter la transaction
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  String generateUniqueId() {
    _transactionCounter++;
    return 'transaction_$_transactionCounter';
  }

  void _addTransaction() {
    String title = _titleController.text;
    double amount = double.parse(_amountController.text);
    String id = generateUniqueId();
    // Créer une nouvelle transaction avec les données saisies par l'utilisateur
    String currentDate = Transaction.getCurrentDate();
    Transaction newTransaction = Transaction(
      title: title,
      amount: amount,
      id: id,
      date: currentDate,
    );

    // Ajouter la nouvelle transaction à la liste et à la base de données
    _transactionService.addTransaction(newTransaction);
    // Recharger la liste des transactions
    _loadTransactions();
  }
}
