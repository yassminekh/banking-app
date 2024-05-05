import 'package:intl/intl.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final String date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  static String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDate;
  }
}

// Utilisation de la fonction getCurrentDate() pour créer une nouvelle transaction
String currentDate = Transaction.getCurrentDate();
Transaction newTransaction = Transaction(
  id: 'your_id',
  title: 'your_title',
  amount: 0.0,
  date: currentDate,
);
