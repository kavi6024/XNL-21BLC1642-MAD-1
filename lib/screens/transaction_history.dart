import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad1/providers/transaction_provider.dart';

class TransactionHistory extends ConsumerWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsyncValue = ref.watch(transactionProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: transactionsAsyncValue.when(
        data: (transactions) {
          // Reverse the transactions list
          final reversedTransactions = transactions.reversed.toList();
          return reversedTransactions.isEmpty
              ? const Center(child: Text('No transactions yet.'))
              : ListView.builder(
                itemCount: reversedTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = reversedTransactions[index];
                  return ListTile(
                    title: Text('To: ${transaction.toAccountId}'),
                    subtitle: Text(
                      'Amount: ₹${transaction.amount}, Date: ${transaction.transactionDate}',
                    ),
                  );
                },
              );
        },
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
