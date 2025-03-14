import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad1/models/user.dart';
import 'package:mad1/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userProvider = FutureProvider<MyUser?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return await getUserByEmail(user.email);
  }
  return null;
});

final myUserManagerProvider = Provider<MyUserManager>(
  (ref) => MyUserManager.instance,
);
