import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_study_buddy/components/button_dark.dart';
import 'package:f_study_buddy/pages/education_details_page.dart';
import 'package:f_study_buddy/pages/hobies_selector_page.dart';
import 'package:f_study_buddy/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../services/auth/auth_service.dart';

class AgeSelectorPage extends StatefulWidget {

  final bool newUser;

  AgeSelectorPage({super.key, required this.newUser});

  @override
  _AgeSelectorPageState createState() => _AgeSelectorPageState();
}

class _AgeSelectorPageState extends State<AgeSelectorPage> {
  int _selectedAge = 18; // Default selected age
  bool _isLoading = false; // Loading state
  String _errorMessage = "";


  // Firestore Integration
  Future<void> saveAge(int age) async {
    try {
      final CollectionReference users = FirebaseFirestore.instance.collection('Users');
      final String? userID = AuthService().getUId();

      await users.doc(userID).set({
        'age': age,
      },
        SetOptions(merge: true),); // Merge to avoid overwriting other data
    } catch (e) {
      setState(() {
        _errorMessage = "Error saving age. Please try again.";
      });
    }
  }

  void _onNext() async {
    setState(() {
      _isLoading = true;
    });

    await saveAge(_selectedAge);

    setState(() {
      _isLoading = false;
    });

    if (_errorMessage.isEmpty) {
      if(widget.newUser) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EducationDetailsPage(newUser: true,)),
        );
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>MyProfilePage()),
        );
      }
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            "How old are you?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "This helps us to personalize your experience.",
            style: TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 200,
                child: CupertinoPicker(
                  itemExtent: 50,
                  scrollController: FixedExtentScrollController(
                    initialItem: _selectedAge - 11,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedAge = index + 11;
                    });
                  },
                  children: List<Widget>.generate(50, (index) {
                    return Center(
                      child: Text(
                        "${index + 11}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          _isLoading
              ? const CircularProgressIndicator()
              : DarkButton(
            onTap: _onNext,
            text: "Next",
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
