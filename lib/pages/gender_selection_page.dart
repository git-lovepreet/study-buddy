import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_study_buddy/components/button_dark.dart';
import 'package:f_study_buddy/pages/age_selector_page.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class GenderSelectionPage extends StatefulWidget {
  @override
  _GenderSelectionPageState createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  String? _selectedGender;
  bool _isLoading = false; // Loading state
  String _errorMessage = "";

  Future<void> saveGender(String gender) async {
    try {
      final CollectionReference users = FirebaseFirestore.instance.collection('Users');
      final String? userID = AuthService().getUId(); // Replace with authenticated user ID

      await users.doc(userID).set({
        'gender': gender,
      },
        SetOptions(merge: true),);
    } catch (e) {
      setState(() {
        _errorMessage = "Error saving gender. Please try again.";
      });
    }
  }

  void _onGenderSelect(String gender) {
    setState(() {
      _selectedGender = gender;
      _errorMessage = ""; // Clear error message on selection
    });
  }

  void _onNext() async {
    if (_selectedGender != null) {
      setState(() {
        _isLoading = true;
      });

      await saveGender(_selectedGender!);

      setState(() {
        _isLoading = false;
      });

      if (_errorMessage.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AgeSelectorPage(newUser: true,)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a gender")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Tell us about yourself!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "To give you a better experience, we need to know your gender.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/logo/logo01.png', // Replace with your image asset
              height: 180,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGenderOption(
                  context: context,
                  gender: 'Male',
                  icon: Icons.male,
                ),
                const SizedBox(width: 20),
                _buildGenderOption(
                  context: context,
                  gender: 'Female',
                  icon: Icons.female,
                ),
              ],
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            const Spacer(),
            _isLoading
                ? const CircularProgressIndicator()
                : DarkButton(
              onTap: _onNext,
              text: "Next",
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Gender Selection Widget
  Widget _buildGenderOption({
    required BuildContext context,
    required String gender,
    required IconData icon,
  }) {
    bool isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () => _onGenderSelect(gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 50,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              gender,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
