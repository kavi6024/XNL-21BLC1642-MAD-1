import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad1/models/transaction.dart';
import 'package:mad1/models/user.dart';
import 'package:mad1/providers/user_provider.dart';
import 'package:mad1/services/firestore_service.dart';

final transactionProvider = StreamProvider<List<Transaction>>((ref) {
  final user = ref.watch(userProvider);
  return user.when(
    data:
        (user) =>
            user != null
                ? getTransactionsForUser(user.userId).asStream()
                : Stream.value([]),
    error: (error, stackTrace) => Stream.error(error),
    loading: () => Stream.value([]),
  );
});
