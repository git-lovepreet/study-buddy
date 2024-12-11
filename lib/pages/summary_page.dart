import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:f_study_buddy/components/button_dark.dart';
import 'package:f_study_buddy/pages/people_recommendation_page.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final TextEditingController aboutController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore reference
  String errorMessage = "";

  // Function to save the about info to Firestore
  Future<void> saveAboutInfo(String userID, String aboutText) async {
    try {
      await _firestore.collection('Users').doc(userID).set({
        'about': aboutText,
      },
        SetOptions(merge: true),);
      print("About info saved successfully.");
    } catch (e) {
      print("Error saving about info: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save your summary. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: Icon(Icons.arrow_back_ios_new,
                      size: 18, color: Theme.of(context).colorScheme.background))),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                "Your Summary",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Provide a brief description about yourself in 100 characters or less.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                maxLines: 2,
                controller: aboutController,
                maxLength: 100,
                decoration: InputDecoration(
                  labelText: "About",
                  hintText: "Brief description",
                  prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 12.0,
                  ),
                  counterText: "${aboutController.text.length}/100",
                  counterStyle: TextStyle(
                    color: aboutController.text.length > 100 ? Colors.red : Colors.grey,
                  ),
                ),
                style: TextStyle(fontSize: 16, color: Colors.black),
                onChanged: (value) {
                  setState(() {
                    errorMessage = value.length > 100
                        ? "Maximum 100 characters allowed."
                        : value.isEmpty
                        ? "This field cannot be empty."
                        : "";
                  });
                },
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              const Spacer(),
              DarkButton(
                onTap: () async {
                  if (aboutController.text.isEmpty || aboutController.text.length > 100) {
                    setState(() {
                      errorMessage = aboutController.text.isEmpty
                          ? "Please provide a brief description."
                          : "Maximum 100 characters allowed.";
                    });
                  } else {
                    final String? userID = AuthService().getUId(); // Replace with actual user ID

                    // Save about info to Firestore
                    await saveAboutInfo(userID!, aboutController.text);

                    // Navigate to the next screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PeopleRecommendationPage()),
                    );
                  }
                },
                text: "Submit",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
