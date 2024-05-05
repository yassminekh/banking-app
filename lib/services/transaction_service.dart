import 'package:projetflutter/models/transaction.dart';

class TransactionService {
  // Liste pour stocker les transactions localement
  List<Transaction> _transactions = [];

  // Méthode pour ajouter une transaction
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
  }

  // Méthode pour récupérer toutes les transactions
  List<Transaction> getTransactions() {
    return List<Transaction>.from(_transactions);
  }

  // Méthode pour mettre à jour une transaction
  void updateTransaction(String id, Transaction updatedTransaction) {
    int index = _transactions.indexWhere((transaction) => transaction.id == id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
    }
  }

  // Méthode pour supprimer une transaction
  void deleteTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
  }
}
