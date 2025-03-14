import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mad1/models/user.dart';
import 'package:mad1/services/firestore_service.dart';

class FinishProfile extends StatefulWidget {
  const FinishProfile({super.key});

  @override
  State<FinishProfile> createState() => _FinishProfileState();
}

class _FinishProfileState extends State<FinishProfile> {
  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userId = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final dobController = TextEditingController();
  final pinController = TextEditingController();
  DateTime dob = DateTime.now();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = MyUser(
          userId: userId.text,
          firstName: firstName.text,
          lastName: lastName.text,
          email: email.text,
          phoneNumber: phoneNumber.text,
          dob: dob,
          pin: pinController.text,
          accountNumber: '', //Will be set in createUser
          balance: 500.0, //Default balance
          currency: 'INR', //Default currency
          branchName: 'BRANCH', //Default branch name
        );
        await createUser(user);
        MyUserManager.instance.setCurrentUser(user);
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating user: $e')));
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != dob) {
      setState(() {
        dob = picked;
        dobController.text = DateFormat('yyyy-MM-dd').format(dob);
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    // MyUserManager.instance.myUserLogout();
    userLogout();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    email.text = args['email'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
        leading: IconButton(
          onPressed: () => logout(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  args['message'],
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: firstName,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter first name'
                              : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: lastName,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter last name'
                              : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: userId,
                  decoration: const InputDecoration(labelText: 'User ID'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter User ID'
                              : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  readOnly:
                      true, // Email is read-only, set from previous screen
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneNumber,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter phone number'
                              : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: dobController,
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: pinController,
                  decoration: const InputDecoration(labelText: '6-Digit PIN'),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a 6-digit PIN';
                    }
                    if (value.length != 6) {
                      return 'PIN must be 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
