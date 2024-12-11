import 'package:f_study_buddy/pages/avatar_selection_page.dart';
import 'package:f_study_buddy/pages/education_details_page.dart';
import 'package:f_study_buddy/pages/hobies_selector_page.dart';
import 'package:f_study_buddy/pages/people_recommendation_page.dart';
import 'package:f_study_buddy/pages/professional_data_page.dart';
import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/login_or_register.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = _authService.getUId();
    if (uid != null) {
      try {
        final data = await _authService.fetchUserData(uid);
        setState(() {
          userProfile = {
            "avatar": data["avatar"] ?? "assets/avatars/avatar_19.png", // Default avatar
            "name": data["name"] ?? "Anonymous", // Default name
            "username": data["username"] ?? "guest",
            "age": data["age"] ?? "N/A",
            "Degree": data["Degree"] ?? "Unknown",
            "Institute": data["Institute"] ?? "Unknown",
            "Skills": data["Skills"] ?? [],
            "goal": data["goal"] ?? "None",
            "Hobbies": data["Hobbies"] ?? [],
          };
          isLoading = false;
        });
      } catch (e) {
        print("Error fetching user data: $e");
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

  void logout() async {
    await _authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (userProfile == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: const Center(
          child: Text("Failed to load user data."),
        ),
      );
    }

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
                  size: 18, color: Theme.of(context).colorScheme.background),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PeopleRecommendationPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.logout,
                  size: 18,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
            onPressed: logout,
          ),
        ],
        title: Text(
          "Profile",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar and Basic Info
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userProfile!["avatar"].isNotEmpty
                            ? AssetImage(userProfile!["avatar"])
                            : const AssetImage("assets/logo/default_avatar.png"),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AvatarSelectionPage(newUser: false)),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userProfile!["name"],
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    "@${userProfile!["username"]}, ${userProfile!["age"]}",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Details Cards
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.school,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text("Degree"),
                subtitle: Text(userProfile!["Degree"]),
                trailing: IconButton(
                  icon: Icon(Icons.edit,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EducationDetailsPage(newUser: false)),
                    );
                  },
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.location_city,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text("Institute"),
                subtitle: Text(userProfile!["Institute"]),
                trailing: IconButton(
                  icon: Icon(Icons.edit,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EducationDetailsPage(newUser: false)),
                    );
                  },
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.code,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text("Skills"),
                subtitle: Text((userProfile!["Skills"] as List).join(", ")),
                trailing: IconButton(
                  icon: Icon(Icons.edit,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfessionalDataPage(newUser: false)),
                    );
                  },
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.flag,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text("Goal"),
                subtitle: Text(userProfile!["goal"]),
                trailing: IconButton(
                  icon: Icon(Icons.edit,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfessionalDataPage(newUser: false)),
                    );
                  },
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.sports_esports,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text("Hobbies"),
                subtitle: Text((userProfile!["Hobbies"] as List).join(", ")),
                trailing: IconButton(
                  icon: Icon(Icons.edit,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HobiesSelectorPage(newUser: false)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
