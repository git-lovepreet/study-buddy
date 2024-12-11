import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the currently signed-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get the UID of the currently signed-in user
  String? getUId() {
    return _auth.currentUser?.uid;
  }



  Future<String> getCurrentUserName() async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User is not logged in.");
      }

      final DocumentSnapshot userDoc =
      await _firestore.collection("Users").doc(userId).get();

      if (userDoc.exists) {
        return userDoc['name'] ?? "Unknown User";
      } else {
        throw Exception("User document does not exist.");
      }
    } catch (e) {
      throw Exception("Failed to fetch user name: $e");
    }
  }

  // Get Current User Degree
  Future<String> getCurrentUserDegree() async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User is not logged in.");
      }

      final DocumentSnapshot userDoc =
      await _firestore.collection("Users").doc(userId).get();

      if (userDoc.exists) {
        return userDoc['Degree'] ?? "Unknown Degree";
      } else {
        throw Exception("User document does not exist.");
      }
    } catch (e) {
      throw Exception("Failed to fetch user Degree: $e");
    }
  }

  // Get Current User Institute
  Future<String> getCurrentUserInstitute() async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User is not logged in.");
      }

      final DocumentSnapshot userDoc =
      await _firestore.collection("Users").doc(userId).get();

      if (userDoc.exists) {
        return userDoc['institute'] ?? "Unknown Institute";
      } else {
        throw Exception("User document does not exist.");
      }
    } catch (e) {
      throw Exception("Failed to fetch user institute: $e");
    }
  }




  // Prepare user data for use in models
  Future<Map<String, dynamic>> prepareDataForModel(String uid) async {
    Map<String, dynamic> userData = await fetchUserData(uid);

    // Preprocess and handle missing data
    return {
      'age': userData['age'] ?? 0,
      'avatar': userData['avatar'] ?? '',
      'Degree': userData['Degree'] ?? 'Unknown',
      'email': userData['email'] ?? '',
      'goal': userData['goal'] ?? '',
      'Hobbies': (userData['Hobbies'] as List?)?.join(',') ?? '', // Convert list to string
      'Institute': userData['Institute'] ?? 'Unknown',
      'name': userData['name'] ?? 'Anonymous',
      'Skills': (userData['Skills'] as List?)?.join(',') ?? '', // Convert list to string
      'uid': userData['uid'] ?? '',
      'username': userData['username'] ?? 'guest',
    };
  }

  // Fetch user data from Firestore
  Future<Map<String, dynamic>> fetchUserData(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
      await _firestore.collection('Users').doc(uid).get();
      if (userSnapshot.exists) {
        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("Error fetching user data: $e");
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the document exists before writing to Firestore
      DocumentReference userDoc = _firestore.collection("Users").doc(userCredential.user!.uid);
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Create the user document only if it doesn't exist
        await userDoc.set({
          'uid': userCredential.user!.uid,
          'email': email,
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      // Create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data in Firestore with default values
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': 'Anonymous',
        'age': 0,
        'Skills': [],
        'Hobbies': [],
        'Degree': 'Unknown',
        'goal': '',
        'Institute': 'Unknown',
        'username': 'guest',
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<String> signInWithGoogle() async {

    await GoogleSignIn().signOut();

    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      throw Exception("Google sign-in was canceled.");
    }

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final String? email = userCredential.user?.email;
    final String uid = userCredential.user!.uid;

    // Check if the email exists in Firestore
    DocumentSnapshot userDoc = await _firestore.collection("Users").doc(uid).get();

    if (userDoc.exists) {
      // Email is registered, return a 'registered' flag
      return "registered";
    } else {
      // If email is not registered, create a partial user document and return 'not registered'
      await _firestore.collection("Users").doc(uid).set({
        'uid': uid,
        'email': email,
        'name': 'Anonymous',
        'age': 0,
        'Skills': [],
        'Hobbies': [],
        'Degree': 'Unknown',
        'goal': '',
        'Institute': 'Unknown',
        'username': '',
      });
      return "not registered";
    }
  }


}
