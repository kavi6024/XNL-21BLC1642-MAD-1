import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mad1/models/transaction.dart' as trans;
import 'package:mad1/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Create a new User
Future<void> createUser(MyUser user) async {
  final firestore = FirebaseFirestore.instance;
  try {
    final snapshot = await firestore.collection('users').get();
    final len = snapshot.docs.length;
    final accountNumber = 1000000000 + len;
    // user = user.copyWith(accountNumber: accountNumber.toString());
    user.accountNumber = accountNumber.toString();
    await firestore.collection('users').doc(user.userId).set(user.toMap());
  } catch (e) {
    rethrow; // Re-throw the exception to be handled by the caller
  }
}

// Get User data by userId
Future<MyUser?> getUserById(String userId) async {
  final firestore = FirebaseFirestore.instance;
  try {
    final doc = await firestore.collection('users').doc(userId).get();
    return doc.exists ? MyUser.fromFirestore(doc) : null;
  } catch (e) {
    print('Error getting user by ID: $e');
    return null;
  }
}

Future<MyUser?> getUserByEmail(String? email) async {
  final firestore = FirebaseFirestore.instance;
  try {
    final snapshot =
        await firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
    return snapshot.docs.isNotEmpty
        ? MyUser.fromFirestore(snapshot.docs.first)
        : null;
  } catch (e) {
    print('Error getting user by email: $e');
    return null;
  }
}

// Add Transaction to User's transaction list
Future<void> addTransactionToUser(
  String userId,
  trans.Transaction transaction,
) async {
  final firestore = FirebaseFirestore.instance;
  try {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .add(transaction.toMap());
  } catch (e) {
    print('Error adding transaction: $e');
    rethrow;
  }
}

Future<void> updateUserBalance(MyUser user) async {
  final firestore = FirebaseFirestore.instance;
  try {
    await firestore.collection('users').doc(user.userId).update({
      'balance': user.balance,
    });
  } catch (e) {
    print('Error updating user balance: $e');
    rethrow;
  }
}

// Get Transactions for a User
Future<List<trans.Transaction>> getTransactionsForUser(String userId) async {
  final firestore = FirebaseFirestore.instance;
  try {
    final snapshot =
        await firestore
            .collection('users')
            .doc(userId)
            .collection('transactions')
            .get();
    return snapshot.docs
        .map(
          (doc) =>
              trans.Transaction.fromMap(doc.data() as Map<String, dynamic>),
        )
        .toList();
  } catch (e) {
    print('Error getting transactions: $e');
    return [];
  }
}

Future<void> userLogout() async {
  await FirebaseAuth.instance.signOut();
  MyUserManager.instance.logout(); // Clear the user from MyUserManager
  // Optionally, you might want to clear any other relevant state here.
}
