import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad1/providers/transaction_provider.dart';
import 'package:mad1/providers/user_provider.dart';
import 'package:mad1/screens/home.dart';
import 'package:mad1/screens/profile.dart';
import 'package:mad1/screens/send_money.dart';
import 'package:mad1/screens/transaction_history.dart';
import 'package:mad1/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final user = ref.watch(userProvider);
        return user.when(
          data: (user) {
            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }
            MyUserManager.instance.setCurrentUser(user);
            return Scaffold(
              body: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: const [
                  Home(),
                  SendMoneyScreen(),
                  TransactionHistory(),
                  Profile(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.monetization_on_sharp),
                    label: "Send Money",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: "Transactions",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
