import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  String toAccountId;
  double amount;
  String transactionType;
  DateTime transactionDate;

  Transaction({
    required this.toAccountId,
    required this.amount,
    required this.transactionType,
    DateTime? transactionDate,
  }) : transactionDate = transactionDate ?? DateTime.now();

  // Method to convert Transaction object to map format for Firestore
  Map<String, dynamic> toMap() {
    return {
      'toAccountId': toAccountId,
      'amount': amount,
      'transactionType': transactionType,
      'transactionDate': transactionDate,
    };
  }

  // Method to create a Transaction object from a map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      toAccountId: map['toAccountId'],
      amount: map['amount'].toDouble(),
      transactionType: map['transactionType'],
      transactionDate: (map['transactionDate'] as Timestamp).toDate(),
    );
  }
}



/*
import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  String toAccountId;
  double amount;
  String transactionType;
  DateTime transactionDate;

  Transaction({
    required this.toAccountId,
    required this.amount,
    required this.transactionType,
    required this.transactionDate,
  });

  // Method to convert Transaction object to map format for Firestore
  Map<String, dynamic> toMap() {
    return {
      'toAccountId': toAccountId,
      'amount': amount,
      'transactionType': transactionType,
      'transactionDate': Timestamp.fromDate(transactionDate), // Firestore Timestamp
    };
  }

  // Method to create a Transaction object from a map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      toAccountId: map['toAccountId'],
      amount: map['amount'],
      transactionType: map['transactionType'],
      transactionDate: (map['transactionDate'] as Timestamp).toDate(),
    );
  }
}
*/