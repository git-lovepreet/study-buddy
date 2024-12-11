import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_study_buddy/components/button_dark.dart';
import 'package:f_study_buddy/pages/avatar_selection_page.dart';
import 'package:f_study_buddy/pages/location_getter_page.dart';
import 'package:f_study_buddy/pages/professional_data_page.dart';
import 'package:f_study_buddy/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class HobiesSelectorPage extends StatefulWidget {
  final bool newUser;

  HobiesSelectorPage({super.key, required this.newUser});
  @override
  _HobiesSelectorPageState createState() => _HobiesSelectorPageState();
}

class _HobiesSelectorPageState extends State<HobiesSelectorPage> {
  final List<String> interests = [
    'Gaming',
    'Music',
    'Arts',
    'Book',
    'Photography',
    'Football',
    'GYM',
    'Car',
    'Animal',
    'Travel',
    'Fashion',
    'Nature',
    'Business',
    'Finance',
    'Cricket',
    'Cooking',
    'Garnering'
  ];

  final Set<String> selectedInterests = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void toggleSelection(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else if (selectedInterests.length < 5) {
        selectedInterests.add(interest);
      }
    });
  }

  Future<void> saveHobbiesToFirestore() async {
    try {
      final String? userID = AuthService().getUId();
      await _firestore.collection('Users').doc(userID).set({
        'Hobbies': selectedInterests.toList(),
      },
        SetOptions(merge: true),);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save Hobbies: $e')),
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
                      size: 18,
                      color: Theme.of(context).colorScheme.background))),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Select up to 5 interests",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Discover meaningful connections by selecting your interests",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: interests.map((interest) {
                  final isSelected = selectedInterests.contains(interest);
                  return ChoiceChip(
                    label: Text(interest),
                    selected: isSelected,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) => toggleSelection(interest),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            DarkButton(
              onTap: selectedInterests.isNotEmpty
                  ? () async {
                await saveHobbiesToFirestore();
                if(widget.newUser){
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvatarSelectionPage(newUser: true,),
                          ),
                        );
                      }else{
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProfilePage(),
                    ),
                  );
                }
                    }
                  : null,
              text: "Next",
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
