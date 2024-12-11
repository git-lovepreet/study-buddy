import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_study_buddy/components/button_dark.dart';
import 'package:f_study_buddy/components/text_field_01.dart';
import 'package:f_study_buddy/pages/age_selector_page.dart';
import 'package:f_study_buddy/services/auth/auth_service.dart';

class UserNamePage extends StatefulWidget {
  @override
  _UserNamePageState createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool isLoading = false; // Tracks loading state
  String errorMessage = "";

  Future<void> saveNameAndUsername(String name, String username) async {
    try {
      final CollectionReference users = FirebaseFirestore.instance.collection('Users');
      final String? userID = AuthService().getUId();

      // Check if the username already exists
      final QuerySnapshot result = await users.where('username', isEqualTo: username).get();
      if (result.docs.isNotEmpty) {
        setState(() {
          errorMessage = "Username is already taken. Please choose another one.";
        });
        return;
      }

      // Save data to Firestore
      await users.doc(userID).set({
        'name': name,
        'username': username,
      }, SetOptions(merge: true));

      setState(() {
        errorMessage = ""; // Clear error message on success
      });

      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AgeSelectorPage(newUser: true)),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Error saving user data: $e";
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside
          },
          child: SingleChildScrollView( // Allows scrolling when the keyboard is open
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Enter Your Details",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "We need this information to personalize your experience.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Name Input Field
                  MyTextField01(
                    icon: const Icon(Icons.person),
                    labeltext: "Full Name",
                    controller: nameController,
                  ),
                  const SizedBox(height: 20),
                  // Username Input Field
                  MyTextField01(
                    icon: const Icon(Icons.alternate_email),
                    labeltext: "Username",
                    controller: usernameController,
                  ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  const SizedBox(height: 40),
                  // Next Button
                  isLoading
                      ? CircularProgressIndicator()
                      : DarkButton(
                    onTap: () async {
                      final String name = nameController.text.trim();
                      final String username = usernameController.text.trim();

                      if (name.isEmpty || username.isEmpty) {
                        setState(() {
                          errorMessage = "Please fill in all fields.";
                        });
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      await saveNameAndUsername(name, username);
                    },
                    text: "Next",
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
