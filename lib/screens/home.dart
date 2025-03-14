import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad1/models/transaction.dart';
import 'package:mad1/models/user.dart';
import 'package:mad1/providers/transaction_provider.dart';
import 'package:mad1/providers/user_provider.dart';
import 'package:mad1/screens/profile.dart';
import 'package:mad1/screens/send_money.dart';
import 'package:mad1/screens/transaction_history.dart';
import 'package:mad1/services/firestore_service.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final transactionsAsyncValue = ref.watch(transactionProvider);

    return user.when(
      data:
          (user) =>
              user == null
                  ? const Center(child: CircularProgressIndicator())
                  : Scaffold(
                    backgroundColor: Colors.black,
                    appBar: AppBar(
                      title: const Text('Home'),
                      actions: [
                        IconButton(
                          onPressed: () => logout(context),
                          icon: const Icon(Icons.logout),
                        ),
                      ],
                    ),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, ${user!.firstName}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Welcome back',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 50),
                              const Text(
                                'Total balance',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '₹${user!.balance}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  // Replace with dynamic advertisement/scheme display
                                  const SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: Text(
                                        'Advertisements/Schemes will go here',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  //Buttons for navigation
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildNavigationButton(
                                        context,
                                        Icons.send,
                                        'Send Money',
                                        '/sendmoney',
                                      ),
                                      _buildNavigationButton(
                                        context,
                                        Icons.history,
                                        'Transactions',
                                        '/transactions',
                                      ),
                                      _buildNavigationButton(
                                        context,
                                        Icons.person,
                                        'Profile',
                                        '/profile',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  //Last Transaction Display
                                  const Text(
                                    'Last Transaction',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(height: 10),
                                  transactionsAsyncValue.when(
                                    data:
                                        (transactions) =>
                                            transactions.isEmpty
                                                ? const Text(
                                                  'No transactions yet.',
                                                )
                                                : Text(
                                                  'To: ${transactions.last.toAccountId}, Amount: ${transactions.last.amount}, Type: ${transactions.last.transactionType}, Time: ${transactions.last.transactionDate}',
                                                ),
                                    error:
                                        (error, stackTrace) =>
                                            Text('Error: $error'),
                                    loading:
                                        () => const CircularProgressIndicator(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> logout(BuildContext context) async {
    // MyUserManager.instance.myUserLogout();
    userLogout();
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget _buildNavigationButton(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Center(child: Icon(icon, color: Colors.white)),
          ),
          const SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }
}
