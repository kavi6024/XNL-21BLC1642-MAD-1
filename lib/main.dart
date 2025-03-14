import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad1/models/user.dart';
import 'package:mad1/screens/finish_profile.dart';
import 'package:mad1/screens/home_screen.dart';
import 'package:mad1/screens/login_screen.dart';
import 'package:mad1/screens/signup_screen.dart';
import 'package:mad1/screens/send_money.dart';
import 'package:mad1/screens/transaction_history.dart';
import 'package:mad1/screens/profile.dart';
import 'package:mad1/services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'XBanking',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => AuthWrapper(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/home': (context) => HomeScreen(),
          '/finish-profile': (context) => FinishProfile(),
          '/sendmoney': (context) => SendMoneyScreen(),
          '/transactions': (context) => TransactionHistory(),
          '/profile': (context) => Profile(),
        },
      ),
    );
  }
}

// Wrapper to handle authentication state
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  MyUser? myUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      myUser = await getUserByEmail(user.email);
      MyUserManager.instance.setCurrentUser(myUser);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return myUser != null ? const HomeScreen() : const LoginScreen();
  }
}
