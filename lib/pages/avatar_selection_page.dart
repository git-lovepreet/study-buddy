import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_study_buddy/components/button_dark.dart';
import 'package:f_study_buddy/pages/people_recommendation_page.dart';
import 'package:f_study_buddy/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/auth/auth_service.dart';

class AvatarSelectionPage extends StatefulWidget {

  final bool newUser;
  AvatarSelectionPage({super.key, required this.newUser});

  @override
  _AvatarSelectionPageState createState() => _AvatarSelectionPageState();
}

class _AvatarSelectionPageState extends State<AvatarSelectionPage> {

  final AuthService _authService = AuthService();
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  final List<String> avatars = List.generate(
    28,
        (index) => "assets/avatars/avatar_${index + 1}.png", // Replace with your actual avatar paths
  );
  String? selectedAvatar;

  // Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to save the selected avatar to Firestore
  Future<void> saveAvatar(String userID, String avatarPath) async {
    try {
      await _firestore.collection('Users').doc(userID).set({
        'avatar': avatarPath,
      },
        SetOptions(merge: true),);
      print("Avatar saved successfully.");
    } catch (e) {
      print("Error saving avatar: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save avatar. Please try again.")),
      );
    }
  }

  Future<void> _loadUserData() async {
    final uid = _authService.getUId();
    if (uid != null) {
      try {
        // Fetch user data from Firebase
        final data = await _authService.fetchUserData(uid);

        // Send data to Flask server
        print('0000000000000000000');
        final response = await http.post(
          Uri.parse('https://866a-2401-4900-5944-7c7c-5d32-2ff8-3edc-8077.ngrok-free.app'), // Replace with the actual server IP/URL
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "age": data["age"],
            "Skills": data["Skills"],
            "Hobbies": data["Hobbies"],
            "Degree": data["Degree"],
            "Institute": data["Institute"],
          }),
        );
        print('111111111111');

        if (response.statusCode == 200) {
          print('222222222222222220');
          final recommendations = json.decode(response.body)["recommendations"];
          setState(() {
            userProfile = {
              "avatar": data["avatar"] ?? "assets/logo/default_avatar.png",
              "name": data["name"] ?? "Anonymous",
              "username": data["username"] ?? "guest",
              "age": data["age"] ?? "N/A",
              "degree": data["degree"] ?? "Unknown",
              "institute": data["institute"] ?? "Unknown",
              "skills": data["skills"] ?? [],
              "goal": data["goal"] ?? "None",
              "hobbies": data["hobbies"] ?? [],
              "recommendations": recommendations,
            };
            isLoading = false;
          });
        } else {
          throw Exception("Failed to fetch recommendations");
        }
      } catch (e) {
        print("Error is : $e");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
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
              const SizedBox(height: 28),
              Text(
                "Select Your Avatar",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Choose one avatar that represents you from the options below.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: avatars.length,
                  itemBuilder: (context, index) {
                    final avatar = avatars[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAvatar = avatar;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedAvatar == avatar
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[300]!,
                            width: selectedAvatar == avatar ? 3.0 : 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            avatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              DarkButton(
                onTap: () async {
                  if (selectedAvatar == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please select an avatar."),
                      ),
                    );
                  } else {
                    final String? userID = AuthService().getUId();

                    // Save avatar to Firestore
                    await saveAvatar(userID!, selectedAvatar!);

                    if(widget.newUser) {
                      _loadUserData();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PeopleRecommendationPage()),
                      );


                    }else{
                      _loadUserData();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyProfilePage()),
                      );
                    }
                  }
                },

                text: (widget.newUser)?"Submit":"Next",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
