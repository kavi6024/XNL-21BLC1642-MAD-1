import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'transaction.dart' as trans;

class MyUser {
  String? uid;
  String userId;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  DateTime dob;
  String address;
  String profilePictureUrl;
  bool isVerified;
  bool isBlocked;
  DateTime createdAt;
  DateTime updatedAt;

  // Bank Account Details
  String accountNumber;
  double balance;
  String currency;
  String branchName;
  DateTime accountCreatedAt;
  DateTime accountUpdatedAt;

  // List of Transactions (subcollection in Firestore)
  List<trans.Transaction> transactions;

  String pin;

  MyUser({
    String? uid,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    this.address = "ADDRESS",
    this.profilePictureUrl = "",
    this.isVerified = false,
    this.isBlocked = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.accountNumber,
    required this.balance,
    required this.currency,
    required this.branchName,
    DateTime? accountCreatedAt,
    DateTime? accountUpdatedAt,
    List<trans.Transaction>? transactions,
    required this.pin,
  }) : uid = FirebaseAuth.instance.currentUser?.uid,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       accountCreatedAt = accountCreatedAt ?? DateTime.now(),
       accountUpdatedAt = accountUpdatedAt ?? DateTime.now(),
       transactions = transactions ?? [];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'dob': dob,
      'address': address,
      'profilePictureUrl': profilePictureUrl,
      'isVerified': isVerified,
      'isBlocked': isBlocked,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'accountNumber': accountNumber,
      'balance': balance,
      'currency': currency,
      'branchName': branchName,
      'accountCreatedAt': accountCreatedAt,
      'accountUpdatedAt': accountUpdatedAt,
      'transactions': transactions.map((e) => e.toMap()).toList(),
      'pin': pin,
    };
  }

  factory MyUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MyUser(
      uid: data['uid'],
      userId: data['userId'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      dob: (data['dob'] as Timestamp).toDate(),
      address: data['address'],
      profilePictureUrl: data['profilePictureUrl'],
      isVerified: data['isVerified'],
      isBlocked: data['isBlocked'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      accountNumber: data['accountNumber'],
      balance: data['balance'].toDouble(),
      currency: data['currency'],
      branchName: data['branchName'],
      accountCreatedAt: (data['accountCreatedAt'] as Timestamp).toDate(),
      accountUpdatedAt: (data['accountUpdatedAt'] as Timestamp).toDate(),
      transactions:
          (data['transactions'] as List)
              .map((e) => trans.Transaction.fromMap(e))
              .toList(),
      pin: data['pin'],
    );
  }

  MyUser copyWith({
    String? uid,
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    DateTime? dob,
    String? address,
    String? profilePictureUrl,
    bool? isVerified,
    bool? isBlocked,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? accountNumber,
    double? balance,
    String? currency,
    String? branchName,
    DateTime? accountCreatedAt,
    DateTime? accountUpdatedAt,
    List<trans.Transaction>? transactions,
    String? pin,
  }) {
    return MyUser(
      uid: uid ?? this.uid,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isVerified: isVerified ?? this.isVerified,
      isBlocked: isBlocked ?? this.isBlocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      branchName: branchName ?? this.branchName,
      accountCreatedAt: accountCreatedAt ?? this.accountCreatedAt,
      accountUpdatedAt: accountUpdatedAt ?? this.accountUpdatedAt,
      transactions: transactions ?? this.transactions,
      pin: pin ?? this.pin,
    );
  }
}

class MyUserManager {
  static final MyUserManager _instance = MyUserManager._privateConstructor();
  MyUserManager._privateConstructor();
  static MyUserManager get instance => _instance;
  MyUser? _currentUser;
  MyUser? get currentUser => _currentUser;

  void setCurrentUser(MyUser? user) {
    _currentUser = user;
  }

  Future<void> logout() async {
    _currentUser = null;
  }

}
