import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad1/models/user.dart';
import 'package:mad1/providers/user_provider.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: userAsyncValue.when(
        data:
            (user) =>
                user == null
                    ? const Center(child: Text('User not found.'))
                    : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'assets/images/profile.png',
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildProfileItem(
                            label: 'User ID',
                            value: user.userId,
                          ),
                          _buildProfileItem(
                            label: 'Name',
                            value: '${user.firstName} ${user.lastName}',
                          ),
                          _buildProfileItem(label: 'Email', value: user.email),
                          _buildProfileItem(
                            label: 'Phone',
                            value: user.phoneNumber,
                          ),
                          _buildProfileItem(
                            label: 'Date of Birth',
                            value: user.dob.toString(),
                          ),
                          _buildProfileItem(
                            label: 'Account Number',
                            value: user.accountNumber,
                          ),
                          _buildProfileItem(
                            label: 'Balance',
                            value: '₹${user.balance}',
                          ),
                        ],
                      ),
                    ),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildProfileItem({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
