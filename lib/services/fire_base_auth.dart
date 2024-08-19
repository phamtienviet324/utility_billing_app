import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/bill.dart'; // Ensure this path is correct

class FireAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  Future<void> signUp(
      String email, String password, String name, String phone) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await _createUser(user.uid, name, phone);
        _logger.i('User created: ${user.uid}');
      } else {
        _logger.w('User creation failed');
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        _logger.e('Sign up error: ${e.message}');
        // Handle specific FirebaseAuthException codes here, e.g.,
        // if (e.code == 'email-already-in-use') { ... }
      } else {
        _logger.e('Sign up error: $e');
      }
    }
  }

  Future<void> _createUser(String userId, String name, String phone) async {
    var user = {
      "name": name,
      "phone": phone,
    };

    // Make sure you choose the correct database service
    var ref = FirebaseDatabase.instance.ref().child("users");

    try {
      await ref.child(userId).set(user);
      _logger.i('User data stored for $userId');
    } catch (e) {
      _logger.e('Database error: $e');
      // Handle specific error codes here if necessary
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      _logger.e('Sign in error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _logger.i('User signed out');
  }
}

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Bill>> getBills() {
    return _db.collection('bills').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Bill.fromFirestore(doc)).toList());
  }

  Future<void> addBill(Bill bill) {
    return _db.collection('bills').add(bill.toFirestore());
  }

  Future<void> updateBill(Bill bill) {
    return _db.collection('bills').doc(bill.id).update(bill.toFirestore());
  }

  Future<void> deleteBill(String id) {
    return _db.collection('bills').doc(id).delete();
  }
}
