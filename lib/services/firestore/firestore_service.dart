import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(String userID, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(userID).set(
        userData,// Merges new data with existing fields
      );
      print('Data saved successfully');
    } catch (e) {
      print('Error saving data: $e');
      rethrow;
    }
  }
}
