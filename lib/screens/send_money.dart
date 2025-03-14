import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad1/models/user.dart';
import 'package:mad1/providers/transaction_provider.dart';
import 'package:mad1/providers/user_provider.dart';
import 'package:mad1/services/firestore_service.dart';
import 'package:mad1/models/transaction.dart' as trans;

class SendMoneyScreen extends ConsumerStatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  ConsumerState<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends ConsumerState<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final userIdController = TextEditingController();
  final amountController = TextEditingController();
  final passwordController = TextEditingController();
  String _message = '';
  bool _isRecipientValid = false;
  Color _messageColor = Colors.green;

  Future<void> _verifyRecipient() async {
    final userId = userIdController.text.trim();
    if (userId.isEmpty) {
      _showMessage('Please enter a valid user ID.', Colors.red);
      return;
    }
    final recipient = await getUserById(userId);
    if (recipient == null) {
      _showMessage('User ID not found.', Colors.red);
    } else {
      setState(() {
        _message = 'User ID is valid. Enter the amount to send.';
        _messageColor = Colors.green;
        _isRecipientValid = true;
      });
    }
  }

  Future<void> _sendMoney() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isRecipientValid) {
      _showMessage(
        'Please verify the recipient before sending money.',
        Colors.red,
      );
      return;
    }
    final amountStr = amountController.text.trim();
    final amount = double.tryParse(amountStr);
    final pin = passwordController.text.trim();

    if (amount == null || amount <= 0) {
      _showMessage('Please enter a valid amount.', Colors.red);
      return;
    }
    if (pin.length != 6) {
      _showMessage('Please enter a 6-digit PIN.', Colors.red);
      return;
    }

    final userAsyncValue = ref.read(userProvider);
    userAsyncValue.when(
      data: (user) async {
        if (user == null) {
          _showMessage('User not found', Colors.red);
          return;
        }
        if (pin != user.pin) {
          _showMessage('Incorrect PIN.', Colors.red);
          return;
        }
        if (user.balance < amount) {
          _showMessage('Insufficient balance.', Colors.red);
          return;
        }

        try {
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            final userRef = FirebaseFirestore.instance
                .collection('users')
                .doc(user.userId);
            final recipientRef = FirebaseFirestore.instance
                .collection('users')
                .doc(userIdController.text);

            final userDoc = await transaction.get(userRef);
            final recipientDoc = await transaction.get(recipientRef);

            if (!userDoc.exists || !recipientDoc.exists) {
              throw Exception('User or recipient not found');
            }

            final existingUser = MyUser.fromFirestore(userDoc);
            final existingRecipient = MyUser.fromFirestore(recipientDoc);

            final updatedUser = existingUser.copyWith(
              balance: existingUser.balance - amount,
            );
            final updatedRecipient = existingRecipient.copyWith(
              balance: existingRecipient.balance + amount,
            );

            final debitTransaction = trans.Transaction(
              toAccountId: userIdController.text,
              amount: amount,
              transactionType: 'DEBIT',
            );
            final creditTransaction = trans.Transaction(
              toAccountId: user.userId,
              amount: amount,
              transactionType: 'CREDIT',
            );

            transaction.set(
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.userId)
                  .collection('transactions')
                  .doc(),
              debitTransaction.toMap(),
            );
            transaction.set(
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(userIdController.text)
                  .collection('transactions')
                  .doc(),
              creditTransaction.toMap(),
            );

            transaction.update(userRef, updatedUser.toMap());
            transaction.update(recipientRef, updatedRecipient.toMap());
          });
          _showMessage('Transaction successful!', Colors.green);

          // Refresh providers to update the UI
          ref.refresh(userProvider);
          ref.refresh(transactionProvider);
        } catch (e) {
          _showMessage('Transaction failed: $e', Colors.red);
          // Consider adding more specific error handling here based on the type of exception
        }
      },
      error: (error, stackTrace) {
        _showMessage('Error fetching user data: $error', Colors.red);
      },
      loading: () => _showMessage('Loading user data...', Colors.blue),
    );
  }

  void _showMessage(String message, Color color) {
    setState(() {
      _message = message;
      _messageColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Money')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: userIdController,
                decoration: const InputDecoration(
                  labelText: 'Recipient User ID',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyRecipient,
                child: const Text('Verify User ID'),
              ),
              if (_isRecipientValid) ...[
                const SizedBox(height: 20),
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    final amount = double.tryParse(value ?? '');
                    return amount == null || amount <= 0
                        ? 'Enter a valid amount'
                        : null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'PIN'),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return value == null || value.length != 6
                        ? 'Enter a 6-digit PIN'
                        : null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendMoney,
                  child: const Text('Send'),
                ),
              ],
              const SizedBox(height: 20),
              Text(_message, style: TextStyle(color: _messageColor)),
            ],
          ),
        ),
      ),
    );
  }
}
